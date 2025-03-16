//
//  SwiftDataManager.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 6/8/24.
//

import SwiftData
import OSLog

/// Helper methods for SwiftData (an abstraction on top of Core Data)
///
/// - Note: SwiftData stored at `~/Library/Developer/CoreSimulator/Devices/_Device-UUID_/data/Containers/Data/Application/_App-UUID_/Library/Application Support`
/// (`/var/mobile/Containers/...` on real devices) (`~/Library/Developer/Xcode/UserData/Previews/Simulator Devices/...` in previews) (Device-UUID and App-UUID gotten from `xcrun simctl get_app_container booted BUNDLE-ID data`)
@MainActor
struct SwiftDataManager {
    static let shared = SwiftDataManager()
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? Constants.appName, category: "SwiftDataManager")
    
    /// Initialize SwiftData in-memory for SwiftUI previews & unit tests
    static let preview: SwiftDataManager = {
        let manager = SwiftDataManager(inMemory: true)
        guard let modelContext = manager.container?.mainContext else { return manager }
        
        // Populate SwiftData with mock recipes
        modelContext.insert(RecentRecipe(recipe: Constants.Mocks.blueberryYogurt))
        modelContext.insert(RecentRecipe(recipe: Constants.Mocks.chocolateCupcake))
        modelContext.insert(RecentRecipe(recipe: Constants.Mocks.thaiBasilChicken))
        
        do {
            try modelContext.save()
        } catch {
            logger.warning("Couldn't save mock recipes in SwiftData :: error: \(error.localizedDescription)")
            modelContext.rollback()
        }
        
        return manager
    }()
    
    var container: ModelContainer? = nil
    
    init(inMemory: Bool = false) {
        // Part of workaround for RecentRecipe with SwiftData
        let transformer = SecureValueTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: NSValueTransformerName("SecureValueTransformer"))
        
        do {
            let modelConfiguration = inMemory ?
                // Alternatively, set the URL to /dev/null
                ModelConfiguration(isStoredInMemoryOnly: true) :
                // Point to Core Data's container file so saved data is retained (SwiftData creates default.store by default)
                ModelConfiguration(url: URL.applicationSupportDirectory.appending(path: "\(Constants.appName).sqlite"))
            
            self.container = try ModelContainer(for: RecentRecipe.self, configurations: modelConfiguration)
            SwiftDataManager.logger.debug("SwiftData loaded successfully! :: configuration: \(modelConfiguration.debugDescription)")
        } catch {
            /*
             Typical reasons for an error here include:
             * The parent directory does not exist, cannot be created, or disallows writing.
             * The persistent store is not accessible, due to permissions or data protection when the device is locked.
             * The device is out of space.
             * The store could not be migrated to the current model version.
             Check the error message to determine what the actual problem was.
             */
            SwiftDataManager.logger.warning("Couldn't load persistent stores from SwiftData :: error: \(error.localizedDescription)")
        }
    }
    
    /// Save a recipe to the recents store in SwiftData.
    ///
    /// If the recipe already exists, its timestamp will be updated to the current time. If the number of recipes exceeds the max, the oldest recipe will be removed.
    /// - Note: This executes in the background and will log if an error occurred.
    /// - Parameter recipe: the recipe to store in SwiftData
    func saveRecentRecipe(_ recipe: Recipe) {
        guard let modelContext = container?.mainContext else { return }
        
        // If the recipe already exists in the store, replace the timestamp with the current time
        let existingRecipePredicate = #Predicate<RecentRecipe> { $0.id == recipe.id }
        var existingRecipeFetchDescriptor = FetchDescriptor<RecentRecipe>(predicate: existingRecipePredicate)
        existingRecipeFetchDescriptor.fetchLimit = 1
        
        do {
            let existingRecipes = try modelContext.fetch(existingRecipeFetchDescriptor)
            
            if existingRecipes.count == 1 {
                existingRecipes[0].timestamp = Date()
                // Also make sure all recipe stats are up-to-date
                existingRecipes[0].recipe = recipe.dictionary
                try modelContext.save()
                return
            }
            
            // If there are too many recipes, delete the oldest recipe
            let timestampSortDescriptor = SortDescriptor(\RecentRecipe.timestamp, order: .forward)
            let allRecipesFetchDescriptor = FetchDescriptor<RecentRecipe>(sortBy: [timestampSortDescriptor])
            let allRecipes = try modelContext.fetch(allRecipesFetchDescriptor)
            
            if allRecipes.count >= Constants.HomeView.maxRecentRecipes {
                let oldestRecipe = allRecipes[0]
                modelContext.delete(oldestRecipe)
            }
            
            modelContext.insert(RecentRecipe(recipe: recipe))
            try modelContext.save()
        } catch {
            SwiftDataManager.logger.warning("Failed to save recent recipe with ID \(recipe.id) :: error: \(error.localizedDescription)")
            modelContext.rollback()
        }
    }
    
    /// Get all recent recipes stored in SwiftData, sorted in descending order by timestamp
    /// - Returns: an array of `RecentRecipe`, or empty if no recipes could be found
    func getAllRecentRecipes() -> [RecentRecipe] {
        guard let modelContext = container?.mainContext else { return [] }
        
        let timestampSortDescriptor = SortDescriptor(\RecentRecipe.timestamp, order: .reverse)
        let allRecipesFetchDescriptor = FetchDescriptor<RecentRecipe>(sortBy: [timestampSortDescriptor])
        
        do {
            return try modelContext.fetch(allRecipesFetchDescriptor)
        } catch {
            SwiftDataManager.logger.warning("Failed to get recent recipes :: error: \(error.localizedDescription)")
            return []
        }
    }
    
    /// Toggle the `isFavorite` attribute for a recent recipe, if it exists
    func toggleFavoriteRecentRecipe(forId id: Int) {
        guard let modelContext = container?.mainContext else { return }
        
        let existingRecipePredicate = #Predicate<RecentRecipe> { $0.id == id }
        var existingRecipeFetchDescriptor = FetchDescriptor<RecentRecipe>(predicate: existingRecipePredicate)
        existingRecipeFetchDescriptor.fetchLimit = 1
        
        do {
            let existingRecipes = try modelContext.fetch(existingRecipeFetchDescriptor)
            // If the recipe doesn't exist, return early
            guard existingRecipes.count == 1 else { return }
            
            existingRecipes[0].isFavorite.toggle()
            try modelContext.save()
        } catch {
            SwiftDataManager.logger.warning("Failed to toggle isFavorite for recent recipe with ID \(id) :: error: \(error.localizedDescription)")
            modelContext.rollback()
        }
    }
}
