//
//  HomeViewModelTests.swift
//  EZ RecipesTests
//
//  Created by Abhishek Chaudhuri on 10/30/22.
//

import Testing
import CoreData
@testable import EZ_Recipes

private extension HomeViewModel {
    convenience init(_ coreData: CoreDataManager, isSuccess: Bool = true) {
        var mockRepo = NetworkManagerMock.shared
        mockRepo.isSuccess = isSuccess
        
        self.init(repository: mockRepo, coreData: coreData)
    }
}

@MainActor
@Suite struct HomeViewModelTests {
    private let mockRepo = NetworkManagerMock.shared
    private let coreData = CoreDataManager.preview
    
    private func testRecipeExistsInCoreData(_ recipe: Recipe?) {
        // Check that the recipe is saved to the recents store
        guard let recipe else {
            Issue.record("Recipe can't be nil in Core Data")
            return
        }
        let viewContext = coreData.container.viewContext
        guard let entityName = RecentRecipe.entity().name else {
            Issue.record("Couldn't get the entity name for RecentRecipe")
            return
        }
        
        let fetchRequest = NSFetchRequest<RecentRecipe>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "%K == %i", #keyPath(RecentRecipe.id), recipe.id)
        
        do {
            let recipeMatches = try viewContext.count(for: fetchRequest)
            #expect(recipeMatches == 1) // no duplicates allowed
        } catch {
            Issue.record("Couldn't fetch recipe from Core Data :: error: \(error.localizedDescription)")
        }
    }
    
    @Test func setRecipe() {
        // Given a recipe
        let recipe = Constants.Mocks.thaiBasilChicken
        
        // When setRecipe() is called
        let viewModel = HomeViewModel(repository: mockRepo, coreData: coreData)
        viewModel.setRecipe(recipe)
        
        // Then the recipe property should match the given recipe
        #expect(viewModel.recipe == recipe)
        #expect(viewModel.isRecipeLoaded)
        testRecipeExistsInCoreData(viewModel.recipe)
    }
    
    @Test func getRandomRecipeSuccess() async {
        // Given a ViewModel
        let viewModel = HomeViewModel(coreData)
        
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
        let viewModel = HomeViewModel(coreData, isSuccess: false)
        
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
        let viewModel = HomeViewModel(coreData)
        
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
        let viewModel = HomeViewModel(coreData, isSuccess: false)
        
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
        let viewModel = HomeViewModel(coreData)
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
        let viewModel = HomeViewModel(coreData)
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
        let viewModel = HomeViewModel(coreData)
        await viewModel.handleRecipeLink(recipeUrl)
        
        // Then the getRecipe(byId:) method shouldn't be called
        #expect(viewModel.recipe == nil)
    }
}
