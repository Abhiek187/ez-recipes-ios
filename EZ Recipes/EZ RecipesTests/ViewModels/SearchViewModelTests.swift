//
//  SearchViewModelTests.swift
//  EZ RecipesTests
//
//  Created by Abhishek Chaudhuri on 2/23/24.
//

import Testing
@testable import EZ_Recipes

private extension SearchViewModel {
    convenience init(isSuccess: Bool = true, noResults: Bool = false) {
        var mockRepo = NetworkManagerMock.shared
        mockRepo.isSuccess = isSuccess
        mockRepo.noResults = noResults
        
        self.init(repository: mockRepo)
    }
}

@MainActor
@Suite struct SearchViewModelTests {
    private let mockRepo = NetworkManagerMock.shared
    
    @Test func searchRecipesSuccess() async {
        // Given a ViewModel
        let viewModel = SearchViewModel()
        
        // When searchRecipes() is called
        await viewModel.searchRecipes()
        
        // Then the recipes property should match the mock response
        #expect(viewModel.recipes == mockRepo.mockRecipes)
        #expect(viewModel.recipeError == nil)
        #expect(viewModel.isRecipeLoaded)
        #expect(!viewModel.noRecipesFound)
    }
    
    @Test func searchRecipesWithPagination() async {
        // Given a ViewModel
        let viewModel = SearchViewModel()
        
        // When searchRecipes() is called with pagination
        await viewModel.searchRecipes()
        await viewModel.searchRecipes(withPagination: true)
        
        // Then the recipes property should be appended to
        #expect(viewModel.recipes == mockRepo.mockRecipes + mockRepo.mockRecipes)
        #expect(viewModel.recipeError == nil)
        #expect(viewModel.isRecipeLoaded)
        #expect(!viewModel.noRecipesFound)
    }
    
    @Test func searchRecipesNoResults() async {
        // Given a ViewModel
        let viewModel = SearchViewModel(noResults: true)
        
        // When searchRecipes() is called with an empty response
        await viewModel.searchRecipes()
        
        // Then the recipes property should be empty
        #expect(viewModel.recipes.isEmpty)
        #expect(viewModel.recipeError == nil)
        #expect(!viewModel.isRecipeLoaded)
        #expect(viewModel.noRecipesFound)
    }
    
    @Test func searchRecipesFail() async {
        // Given a ViewModel where API requests fail
        let viewModel = SearchViewModel(isSuccess: false)
        
        // When searchRecipes() is called
        await viewModel.searchRecipes()
        
        // Then the recipeError property should match the mock recipe error
        #expect(viewModel.recipes.isEmpty)
        #expect(viewModel.recipeError == Constants.Mocks.recipeError)
        #expect(!viewModel.isRecipeLoaded)
        #expect(viewModel.noRecipesFound)
    }
}
