//
//  HomeViewModelTests.swift
//  EZ RecipesTests
//
//  Created by Abhishek Chaudhuri on 10/30/22.
//

import XCTest
import Combine
@testable import EZ_Recipes

final class HomeViewModelTests: XCTestCase {
    var mockRepo = NetworkManagerMock.shared
    var viewModel: HomeViewModel!
    private var cancellable = Set<AnyCancellable>()
    
    @MainActor func testGetRandomRecipeSuccess() {
        // Given a ViewModel
        viewModel = HomeViewModel(repository: mockRepo)
        
        // When the getRandomRecipe() method is called
        // Then the recipe property should match the mock recipe
        let expectation = XCTestExpectation(description: "Fetch a random recipe")
        
        // Observe when the recipe property changes and fulfill the expectation if it's set to the mock recipe
        viewModel.$recipe.sink { recipe in
            if recipe == Constants.Mocks.blueberryYogurt {
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
        viewModel = HomeViewModel(repository: mockRepo)
        
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
        viewModel = HomeViewModel(repository: mockRepo)
        
        // When the getRecipe(byId:) method is called
        // Then the recipe property should match the mock recipe and recipeError should be nil
        let expectation = XCTestExpectation(description: "Fetch a recipe by its ID")
        
        viewModel.$recipe.sink { recipe in
            if recipe == Constants.Mocks.blueberryYogurt {
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
        viewModel = HomeViewModel(repository: mockRepo)
        
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
}
