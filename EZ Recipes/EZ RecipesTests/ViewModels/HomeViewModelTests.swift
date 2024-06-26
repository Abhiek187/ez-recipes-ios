//
//  HomeViewModelTests.swift
//  EZ RecipesTests
//
//  Created by Abhishek Chaudhuri on 10/30/22.
//

import XCTest
import Combine
import CoreData
@testable import EZ_Recipes

final class HomeViewModelTests: XCTestCase {
    var mockRepo = NetworkManagerMock.shared
    var viewModel: HomeViewModel!
    private var cancellable = Set<AnyCancellable>()
    private let coreData = CoreDataManager.preview
    
    private func testRecipeExistsInCoreData(_ recipe: Recipe?) {
        // Check that the recipe is saved to the recents store
        guard let recipe else {
            XCTFail("Recipe can't be nil in Core Data")
            return
        }
        let viewContext = coreData.container.viewContext
        guard let entityName = RecentRecipe.entity().name else {
            XCTFail("Couldn't get the entity name for RecentRecipe")
            return
        }
        
        let fetchRequest = NSFetchRequest<RecentRecipe>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "%K == %i", #keyPath(RecentRecipe.id), recipe.id)
        
        do {
            let recipeMatches = try viewContext.count(for: fetchRequest)
            XCTAssert(recipeMatches == 1) // no duplicates allowed
        } catch {
            XCTFail("Couldn't fetch recipe from Core Data :: error: \(error.localizedDescription)")
        }
    }
    
    @MainActor func testSetRecipe() {
        // Given a recipe
        let recipe = Constants.Mocks.thaiBasilChicken
        
        // When setRecipe() is called
        viewModel = HomeViewModel(repository: mockRepo, coreData: coreData)
        viewModel.setRecipe(recipe)
        
        // Then the recipe property should match the given recipe
        XCTAssertEqual(viewModel.recipe, recipe)
        XCTAssertEqual(viewModel.isRecipeLoaded, true)
        testRecipeExistsInCoreData(viewModel.recipe)
    }
    
    @MainActor func testGetRandomRecipeSuccess() {
        // Given a ViewModel
        viewModel = HomeViewModel(repository: mockRepo, coreData: coreData)
        
        // When the getRandomRecipe() method is called
        // Then the recipe property should match the mock recipe
        let expectation = XCTestExpectation(description: "Fetch a random recipe")
        
        // Observe when the recipe property changes and fulfill the expectation if it's set to the mock recipe
        viewModel.$recipe.sink { recipe in
            if recipe == Constants.Mocks.chocolateCupcake {
                self.testRecipeExistsInCoreData(recipe)
                expectation.fulfill()
            }
        }
        .store(in: &cancellable) // automatically deallocate the subscription once the sink finishes
        
        viewModel.getRandomRecipe()
        wait(for: [expectation], timeout: 1)
    }
    
    @MainActor func testGetRandomRecipeFail() {
        // Given a ViewModel where API requests fail
        mockRepo.isSuccess = false
        viewModel = HomeViewModel(repository: mockRepo, coreData: coreData)
        
        // When the getRandomRecipe() method is called
        // Then the recipeError property should match the mock recipe error and recipe should be nil
        let expectation = XCTestExpectation(description: "Fetch a random recipe")
        
        viewModel.$recipeError.sink { recipeError in
            if recipeError == Constants.Mocks.recipeError {
                expectation.fulfill()
            }
        }
        .store(in: &cancellable) // automatically deallocate the subscription once the sink finishes
        
        viewModel.getRandomRecipe()
        wait(for: [expectation], timeout: 1)
    }
    
    @MainActor func testGetRecipeByIdSuccess() {
        // Given a ViewModel
        viewModel = HomeViewModel(repository: mockRepo, coreData: coreData)
        
        // When the getRecipe(byId:) method is called
        // Then the recipe property should match the mock recipe and recipeError should be nil
        let expectation = XCTestExpectation(description: "Fetch a recipe by its ID")
        
        viewModel.$recipe.sink { recipe in
            if recipe == Constants.Mocks.chocolateCupcake {
                self.testRecipeExistsInCoreData(recipe)
                expectation.fulfill()
            }
        }
        .store(in: &cancellable)
        
        viewModel.getRecipe(byId: 1)
        wait(for: [expectation], timeout: 1)
    }
    
    @MainActor func testGetRecipeByIdFail() {
        // Given a ViewModel where API requests fail
        mockRepo.isSuccess = false
        viewModel = HomeViewModel(repository: mockRepo, coreData: coreData)
        
        // When the getRecipe(byId:) method is called
        // Then the recipeError property should match the mock recipe error and recipe should be nil
        let expectation = XCTestExpectation(description: "Fetch a recipe by its ID")
        
        viewModel.$recipeError.sink { recipeError in
            if recipeError == Constants.Mocks.recipeError {
                expectation.fulfill()
            }
        }
        .store(in: &cancellable) // automatically deallocate the subscription once the sink finishes
        
        viewModel.getRecipe(byId: 1)
        wait(for: [expectation], timeout: 1)
    }
    
    @MainActor func testHandleRecipeLinkSuccess() {
        // Given a universal link from the web app
        let recipeId = 644783
        guard let recipeUrl = URL(string: "https://ez-recipes-web.onrender.com/recipe/\(recipeId)") else {
            XCTFail("The test URL is invalid")
            return
        }
        
        // When handling the URL
        viewModel = HomeViewModel(repository: mockRepo, coreData: coreData)
        // Then the getRecipe(byId:) method should be called with the recipe ID in the URL
        let expectation = XCTestExpectation(description: "Fetch a recipe by its ID")
        
        viewModel.$recipe.sink { recipe in
            if recipe?.id == recipeId {
                self.testRecipeExistsInCoreData(recipe)
                expectation.fulfill()
            }
        }
        .store(in: &cancellable)
        
        viewModel.handleRecipeLink(recipeUrl)
        wait(for: [expectation], timeout: 1)
    }
    
    @MainActor func testHandleRecipeLinkFailEmptyPath() {
        // Given a universal link from the web app with an empty path
        guard let recipeUrl = URL(string: "https://ez-recipes-web.onrender.com") else {
            XCTFail("The test URL is invalid")
            return
        }
        
        // When handling the URL
        viewModel = HomeViewModel(repository: mockRepo, coreData: coreData)
        // Then the getRecipe(byId:) method shouldn't be called
        let expectation = XCTestExpectation(description: "Fetch a recipe by its ID")
        
        viewModel.$recipe.sink { recipe in
            if recipe == nil {
                expectation.fulfill()
            }
        }
        .store(in: &cancellable)
        
        viewModel.handleRecipeLink(recipeUrl)
        wait(for: [expectation], timeout: 1)
    }
    
    @MainActor func testHandleRecipeLinkFailInvalidRecipePath() {
        // Given a universal link from the web app with an invalid recipe path
        guard let recipeUrl = URL(string: "https://ez-recipes-web.onrender.com/recipe/-1") else {
            XCTFail("The test URL is invalid")
            return
        }
        
        // When handling the URL
        viewModel = HomeViewModel(repository: mockRepo, coreData: coreData)
        // Then the getRecipe(byId:) method shouldn't be called
        let expectation = XCTestExpectation(description: "Fetch a recipe by its ID")
        
        viewModel.$recipe.sink { recipe in
            if recipe == nil {
                expectation.fulfill()
            }
        }
        .store(in: &cancellable)
        
        viewModel.handleRecipeLink(recipeUrl)
        wait(for: [expectation], timeout: 1)
    }
}
