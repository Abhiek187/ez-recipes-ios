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
/// - Note: Core Data stored at ~/Library/Developer/CoreSimulator/Devices/_Device-UUID_/data/Containers/Data/Application/_App-UUID_/Library/Application Support
/// (Device-UUID and App-UUID gotten from `xcrun simctl get_app_container booted BUNDLE-ID data`)
struct CoreDataManager {
    static let shared = CoreDataManager()
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? Constants.appName, category: "CoreDataManager")
    
    /// Initialize Core Data in-memory for SwiftUI previews
    static var preview: CoreDataManager = {
        let manager = CoreDataManager(inMemory: false)
        let viewContext = manager.container.viewContext
        
        // Populate Core Data with mock recipes
        _ = RecentRecipe(recipe: Constants.Mocks.blueberryYogurt, insertInto: viewContext)
        _ = RecentRecipe(recipe: Constants.Mocks.chocolateCupcake, insertInto: viewContext)
        _ = RecentRecipe(recipe: Constants.Mocks.thaiBasilChicken, insertInto: viewContext)
        
        do {
            try viewContext.save()
        } catch {
            logger.warning("Couldn't save mock recipes in Core Data :: error: \(error.localizedDescription)")
        }
        
        return manager
    }()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: Constants.appName)
        
        if inMemory, let storeDescription = container.persistentStoreDescriptions.first {
            storeDescription.url = URL(fileURLWithPath: "/dev/null")
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
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
