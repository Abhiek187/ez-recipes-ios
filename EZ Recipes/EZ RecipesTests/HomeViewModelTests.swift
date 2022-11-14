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
    let mockRepo = NetworkManagerMock.shared
    var viewModel: HomeViewModel!
    private var cancellable = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        viewModel = HomeViewModel(repository: mockRepo)
    }
    
    @MainActor func testGetRandomRecipe() {
        // Given a ViewModel
        // When the getRandomRecipe() method is called
        // Then the recipe property should be updated
        let expectation = XCTestExpectation(description: "Fetch a random recipe")
        
        // Observe when the recipe property changes and fulfill the expectation if it's set to the mock recipe
        viewModel.$recipe.sink { recipe in
            if recipe == Constants.mockRecipe {
                expectation.fulfill()
            }
        }
        .store(in: &cancellable) // automatically deallocate the subscription once the sink finishes
        
        viewModel.getRandomRecipe()
        wait(for: [expectation], timeout: 1)
    }
    
    @MainActor func testGetRecipeById() {
        // Given a ViewModel
        // When the getRecipe(byId:) method is called
        // Then the recipe property should be updated
        let expectation = XCTestExpectation(description: "Fetch a recipe by its ID")
        
        viewModel.$recipe.sink { recipe in
            if recipe == Constants.mockRecipe {
                expectation.fulfill()
            }
        }
        .store(in: &cancellable)
        
        viewModel.getRecipe(byId: "1")
        wait(for: [expectation], timeout: 1)
    }
}
