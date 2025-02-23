//
//  CoreDataManager.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 6/8/24.
//

import CoreData
import OSLog

/// Helper methods for Core Data
///
/// - Note: Core Data stored at `~/Library/Developer/CoreSimulator/Devices/_Device-UUID_/data/Containers/Data/Application/_App-UUID_/Library/Application Support`
/// (`/var/mobile/Containers/...` on real devices) (`~/Library/Developer/Xcode/UserData/Previews/Simulator Devices/...` in previews) (Device-UUID and App-UUID gotten from `xcrun simctl get_app_container booted BUNDLE-ID data`)
struct CoreDataManager {
    static let shared = CoreDataManager()
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? Constants.appName, category: "CoreDataManager")
    
    /// Initialize Core Data in-memory for SwiftUI previews & unit tests
    static let preview: CoreDataManager = {
        let manager = CoreDataManager(inMemory: true)
        let viewContext = manager.container.viewContext
        
        // Populate Core Data with mock recipes
        _ = RecentRecipe(recipe: Constants.Mocks.blueberryYogurt, insertInto: viewContext)
        _ = RecentRecipe(recipe: Constants.Mocks.chocolateCupcake, insertInto: viewContext)
        _ = RecentRecipe(recipe: Constants.Mocks.thaiBasilChicken, insertInto: viewContext)
        
        do {
            try viewContext.save()
        } catch {
            logger.warning("Couldn't save mock recipes in Core Data :: error: \(error.localizedDescription)")
            viewContext.rollback()
        }
        
        return manager
    }()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: Constants.appName)
        
        if inMemory, let storeDescription = container.persistentStoreDescriptions.first {
            // Black hole method preferred over an in-memory store for speed & compatibility
            storeDescription.url = URL(filePath: "/dev/null")
            //storeDescription.type = NSInMemoryStoreType
            //storeDescription.url = nil
        }
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                CoreDataManager.logger.warning("Couldn't load persistent stores from Core Data :: error: \(error), \(error.userInfo)")
            } else {
                CoreDataManager.logger.debug("Core Data loaded successfully! :: store description: \(storeDescription)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    /// Save a recipe to the recents store in Core Data.
    ///
    /// If the recipe already exists, its timestamp will be updated to the current time. If the number of recipes exceeds the max, the oldest recipe will be removed.
    /// - Note: This executes in the background and will log if an error occurred.
    /// - Parameter recipe: the recipe to store in Core Data
    func saveRecentRecipe(_ recipe: Recipe) {
        guard let entityName = RecentRecipe.entity().name else { return }
        let viewContext = container.viewContext
        
        // If the recipe already exists in the store, replace the timestamp with the current time
        let existingRecipeFetchRequest = NSFetchRequest<RecentRecipe>(entityName: entityName)
        existingRecipeFetchRequest.predicate = NSPredicate(format: "%K == %i", #keyPath(RecentRecipe.id), recipe.id)
        existingRecipeFetchRequest.fetchLimit = 1
        
        do {
            let existingRecipes = try viewContext.fetch(existingRecipeFetchRequest)
            
            if existingRecipes.count == 1 {
                existingRecipes[0].timestamp = Date()
                try viewContext.save()
                return
            }
            
            // If there are too many recipes, delete the oldest recipe
            let allRecipesFetchRequest = NSFetchRequest<RecentRecipe>(entityName: entityName)
            let timestampSortDescriptor = NSSortDescriptor(key: #keyPath(RecentRecipe.timestamp), ascending: true)
            allRecipesFetchRequest.sortDescriptors = [timestampSortDescriptor]
            let allRecipes = try viewContext.fetch(allRecipesFetchRequest)
            
            if allRecipes.count >= Constants.HomeView.maxRecentRecipes {
                let oldestRecipe = allRecipes[0]
                viewContext.delete(oldestRecipe)
            }
            
            _ = RecentRecipe(recipe: recipe, insertInto: viewContext)
            try viewContext.save()
        } catch {
            CoreDataManager.logger.warning("Failed to save recent recipe with ID \(recipe.id) :: error: \(error.localizedDescription)")
            viewContext.rollback()
        }
    }
}
