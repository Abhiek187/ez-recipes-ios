//
//  HomeViewModelTests.swift
//  EZ RecipesTests
//
//  Created by Abhishek Chaudhuri on 10/30/22.
//

import Testing
import Foundation
@testable import EZ_Recipes

private extension HomeViewModel {
    convenience init(_ swiftData: SwiftDataManager, isSuccess: Bool = true) {
        var mockRepo = NetworkManagerMock.shared
        mockRepo.isSuccess = isSuccess
        
        self.init(repository: mockRepo, swiftData: swiftData)
    }
}

@MainActor
@Suite struct HomeViewModelTests {
    private let mockRepo = NetworkManagerMock.shared
    private let swiftData = SwiftDataManager.preview
    
    @Test func setRecipe() {
        // Given a recipe
        let recipe = Constants.Mocks.thaiBasilChicken
        
        // When setRecipe() is called
        let viewModel = HomeViewModel(repository: mockRepo, swiftData: swiftData)
        viewModel.setRecipe(recipe)
        
        // Then the recipe property should match the given recipe
        #expect(viewModel.recipe == recipe)
        #expect(viewModel.isRecipeLoaded)
        
        let recentRecipes = viewModel.getAllRecentRecipes()
        #expect(recentRecipes.map(\.id).contains(recipe.id))
    }
    
    @Test func getRandomRecipeSuccess() async {
        // Given a ViewModel
        let viewModel = HomeViewModel(swiftData)
        
        // When the getRandomRecipe() method is called
        await viewModel.getRandomRecipe()
        
        // Then the recipe property should match the mock recipe
        #expect(viewModel.recipe == mockRepo.mockRecipes[1])
        #expect(viewModel.recipeError == nil)
        #expect(viewModel.isRecipeLoaded)
        #expect(!viewModel.recipeFailedToLoad)
    }
    
    @Test func getRandomRecipeFail() async {
        // Given a ViewModel where API requests fail
        let viewModel = HomeViewModel(swiftData, isSuccess: false)
        
        // When the getRandomRecipe() method is called
        await viewModel.getRandomRecipe()
        
        // Then the recipeError property should match the mock recipe error and recipe should be nil
        #expect(viewModel.recipe == nil)
        #expect(viewModel.recipeError == Constants.Mocks.recipeError)
        #expect(!viewModel.isRecipeLoaded)
        #expect(viewModel.recipeFailedToLoad)
    }
    
    @Test func getRecipeByIdSuccess() async {
        // Given a ViewModel
        let viewModel = HomeViewModel(swiftData)
        
        // When the getRecipe(byId:) method is called
        await viewModel.getRecipe(byId: 1)
        
        // Then the recipe property should match the mock recipe and recipeError should be nil
        #expect(viewModel.recipe == mockRepo.mockRecipes[1])
        #expect(viewModel.recipeError == nil)
        #expect(viewModel.isRecipeLoaded)
        #expect(!viewModel.recipeFailedToLoad)
    }
    
    @Test func getRecipeByIdFail() async {
        // Given a ViewModel where API requests fail
        let viewModel = HomeViewModel(swiftData, isSuccess: false)
        
        // When the getRecipe(byId:) method is called
        await viewModel.getRecipe(byId: 1)
        
        // Then the recipeError property should match the mock recipe error and recipe should be nil
        #expect(viewModel.recipe == nil)
        #expect(viewModel.recipeError == Constants.Mocks.recipeError)
        #expect(!viewModel.isRecipeLoaded)
        #expect(viewModel.recipeFailedToLoad)
    }
    
    @Test func handleRecipeLinkSuccess() async {
        // Given a universal link from the web app
        let recipeId = 644783
        guard let recipeUrl = URL(string: "https://ez-recipes-web.onrender.com/recipe/\(recipeId)") else {
            Issue.record("The test URL is invalid")
            return
        }
        
        // When handling the URL
        let viewModel = HomeViewModel(swiftData)
        await viewModel.handleRecipeLink(recipeUrl)
        
        // Then the getRecipe(byId:) method should be called with the recipe ID in the URL
        #expect(viewModel.recipe?.id == recipeId)
        #expect(viewModel.recipeError == nil)
        #expect(viewModel.isRecipeLoaded)
        #expect(!viewModel.recipeFailedToLoad)
    }
    
    @Test func handleRecipeLinkFailEmptyPath() async {
        // Given a universal link from the web app with an empty path
        guard let recipeUrl = URL(string: "https://ez-recipes-web.onrender.com") else {
            Issue.record("The test URL is invalid")
            return
        }
        
        // When handling the URL
        let viewModel = HomeViewModel(swiftData)
        await viewModel.handleRecipeLink(recipeUrl)
        
        // Then the getRecipe(byId:) method shouldn't be called
        #expect(viewModel.recipe == nil)
    }
    
    @Test func handleRecipeLinkFailInvalidRecipePath() async {
        // Given a universal link from the web app with an invalid recipe path
        guard let recipeUrl = URL(string: "https://ez-recipes-web.onrender.com/recipe/-1") else {
            Issue.record("The test URL is invalid")
            return
        }
        
        // When handling the URL
        let viewModel = HomeViewModel(swiftData)
        await viewModel.handleRecipeLink(recipeUrl)
        
        // Then the getRecipe(byId:) method shouldn't be called
        #expect(viewModel.recipe == nil)
    }
}
