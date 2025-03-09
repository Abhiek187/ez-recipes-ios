//
//  SwiftDataManagerTests.swift
//  EZ RecipesTests
//
//  Created by Abhishek Chaudhuri on 6/9/24.
//

import Testing
@testable import EZ_Recipes

@MainActor
@Suite(.serialized) struct SwiftDataManagerTests {
    let swiftData = SwiftDataManager.preview
    var existingRecipes: [RecentRecipe]
    
    init() {
        existingRecipes = swiftData.getAllRecentRecipes()
    }
    
    private func createMockRecipe(withId id: Int) -> Recipe {
        return Recipe(_id: nil, id: id, name: "", url: nil, image: "", credit: "", sourceUrl: "", healthScore: 0, time: 0, servings: 0, summary: "", types: [], spiceLevel: .none, isVegetarian: false, isVegan: false, isGlutenFree: false, isHealthy: false, isCheap: false, isSustainable: false, culture: [], nutrients: [], ingredients: [], instructions: [])
    }
    
    @Test func addRecentRecipe() {
        // Given a new recipe
        let mockRecipe = createMockRecipe(withId: 0)
        
        // When added to the recents store
        swiftData.saveRecentRecipe(mockRecipe)
        let newRecipes = swiftData.getAllRecentRecipes()
        
        // Then a new entry is saved to the store
        #expect(newRecipes.count > existingRecipes.count)
        #expect(newRecipes.first { $0.id == mockRecipe.id } != nil)
    }
    
    @Test func timestampUpdateWithExistingRecipe() throws {
        // Given a recipe that already exists in SwiftData
        let mockRecipe = Constants.Mocks.blueberryYogurt
        let oldTimestamp = try #require(existingRecipes.first { $0.id == mockRecipe.id }?.timestamp)
        
        // When added to the recents store
        swiftData.saveRecentRecipe(mockRecipe)
        let newRecipes = swiftData.getAllRecentRecipes()
        
        // Then only the timestamp is updated
        #expect(newRecipes.count == existingRecipes.count)
        let newTimestamp = try #require(newRecipes.first { $0.id == mockRecipe.id }?.timestamp)
        #expect(newTimestamp > oldTimestamp)
    }
    
    @Test func recentRecipesDoNotExceedMax() {
        // Given a recents store with the max number of recipes
        let maxRemainingRecipes = Constants.HomeView.maxRecentRecipes - existingRecipes.count
        for id in 0..<maxRemainingRecipes {
            let mockRecipe = createMockRecipe(withId: id)
            swiftData.saveRecentRecipe(mockRecipe)
        }
        
        // When a new recipe is added to the store
        let mockRecipe = createMockRecipe(withId: maxRemainingRecipes)
        swiftData.saveRecentRecipe(mockRecipe)
        let newRecipes = swiftData.getAllRecentRecipes()
        
        // Then the oldest recipe is deleted
        #expect(newRecipes.count == Constants.HomeView.maxRecentRecipes)
        #expect(newRecipes.first { $0.id == mockRecipe.id } != nil)
    }
}
