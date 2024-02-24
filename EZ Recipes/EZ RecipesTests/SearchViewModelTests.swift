//
//  SearchViewModelTests.swift
//  EZ RecipesTests
//
//  Created by Abhishek Chaudhuri on 2/23/24.
//

import XCTest
import Combine
@testable import EZ_Recipes

final class SearchViewModelTests: XCTestCase {
    var mockRepo = NetworkManagerMock.shared
    var viewModel: SearchViewModel!
    private var cancellable = Set<AnyCancellable>()
    
    @MainActor func testSearchRecipesSuccess() {
        // Given a ViewModel
        viewModel = SearchViewModel(repository: mockRepo)
        
        // When searchRecipes() is called
        // Then the recipes property should match the mock response
        let expectation = XCTestExpectation(description: "Search recipes")
        
        viewModel.$recipes.sink { recipes in
            if recipes == [Constants.Mocks.blueberryYogurt, Constants.Mocks.chocolateCupcake, Constants.Mocks.thaiBasilChicken] {
                expectation.fulfill()
            }
        }
        .store(in: &cancellable)
        
        viewModel.searchRecipes()
        wait(for: [expectation], timeout: 1)
    }
    
    @MainActor func testSearchRecipesFail() {
        // Given a ViewModel where API requests fail
        mockRepo.isSuccess = false
        viewModel = SearchViewModel(repository: mockRepo)
        
        // When searchRecipes() is called
        // Then the recipeError property should match the mock recipe error
        let expectation = XCTestExpectation(description: "Search recipes")
        
        viewModel.$recipeError.sink { recipeError in
            if recipeError == Constants.Mocks.recipeError {
                expectation.fulfill()
            }
        }
        .store(in: &cancellable)
        
        viewModel.searchRecipes()
        wait(for: [expectation], timeout: 1)
    }
}
