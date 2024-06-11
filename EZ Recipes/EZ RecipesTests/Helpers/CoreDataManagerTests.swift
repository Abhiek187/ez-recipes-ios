//
//  CoreDataManagerTests.swift
//  EZ RecipesTests
//
//  Created by Abhishek Chaudhuri on 6/9/24.
//

import XCTest
import CoreData
@testable import EZ_Recipes

final class CoreDataManagerTests: XCTestCase {
    let coreData = CoreDataManager.preview
    var existingRecipes: [RecentRecipe]!
    
    override func setUp() {
        existingRecipes = getAllRecentRecipes()
    }
    
    private func getAllRecentRecipes() -> [RecentRecipe] {
        // Get all the recipes that are currently stored in Core Data
        guard let entityName = RecentRecipe.entity().name else {
            XCTFail("Couldn't get the entity name for RecentRecipe")
            return []
        }
        let viewContext = coreData.container.viewContext
        let fetchRequest = NSFetchRequest<RecentRecipe>(entityName: entityName)
        
        do {
            return try viewContext.fetch(fetchRequest)
        } catch {
            XCTFail("Couldn't fetch recipe from Core Data :: error: \(error.localizedDescription)")
            return []
        }
    }
    
    private func createMockRecipe(withId id: Int) -> Recipe {
        return Recipe(_id: nil, id: id, name: "", url: nil, image: "", credit: "", sourceUrl: "", healthScore: 0, time: 0, servings: 0, summary: "", types: [], spiceLevel: .none, isVegetarian: false, isVegan: false, isGlutenFree: false, isHealthy: false, isCheap: false, isSustainable: false, culture: [], nutrients: [], ingredients: [], instructions: [])
    }
    
    func testAddRecentRecipe() {
        // Given a new recipe
        let mockRecipe = createMockRecipe(withId: 0)
        
        // When added to the recents store
        coreData.saveRecentRecipe(mockRecipe)
        let newRecipes = getAllRecentRecipes()
        
        // Then a new entry is saved to the store
        XCTAssertGreaterThan(newRecipes.count, existingRecipes.count)
        XCTAssertNotNil(newRecipes.first { $0.id == mockRecipe.id })
    }
    
    func testTimestampUpdateWithExistingRecipe() {
        // Given a recipe that already exists in Core Data
        let mockRecipe = Constants.Mocks.blueberryYogurt
        let oldTimestamp = existingRecipes.first { $0.id == mockRecipe.id }?.timestamp
        
        // When added to the recents store
        coreData.saveRecentRecipe(mockRecipe)
        let newRecipes = getAllRecentRecipes()
        
        // Then only the timestamp is updated
        XCTAssertEqual(newRecipes.count, existingRecipes.count)
        let newTimestamp = newRecipes.first { $0.id == mockRecipe.id }?.timestamp
        XCTAssertNotNil(oldTimestamp)
        XCTAssertNotNil(newTimestamp)
        XCTAssertGreaterThan(newTimestamp!, oldTimestamp!)
    }
    
    func testRecentRecipesDoNotExceedMax() {
        // Given a recents store with the max number of recipes
        let maxRemainingRecipes = Constants.HomeView.maxRecentRecipes - existingRecipes.count
        for id in 0..<maxRemainingRecipes {
            let mockRecipe = createMockRecipe(withId: id)
            coreData.saveRecentRecipe(mockRecipe)
        }
        
        // When a new recipe is added to the store
        let mockRecipe = createMockRecipe(withId: maxRemainingRecipes)
        coreData.saveRecentRecipe(mockRecipe)
        let newRecipes = getAllRecentRecipes()
        
        // Then the oldest recipe is deleted
        XCTAssertEqual(newRecipes.count, Constants.HomeView.maxRecentRecipes)
        XCTAssertNotNil(newRecipes.first { $0.id == mockRecipe.id })
    }
}
