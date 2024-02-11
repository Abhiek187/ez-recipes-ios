//
//  SearchViewModel.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 2/9/24.
//

import Foundation

@MainActor
class SearchViewModel: ViewModel, ObservableObject {
    @Published private(set) var isLoading = false
    @Published var recipeFilter = RecipeFilter()
    @Published private(set) var recipes: [Recipe] = []
    @Published private(set) var recipeError: RecipeError? = nil
    
    private var repository: RecipeRepository
    
    nonisolated required init(repository: RecipeRepository) {
        self.repository = repository
    }
    
    func searchRecipes() {
        Task {
            isLoading = true
            let result = await repository.getRecipes(withFilter: recipeFilter)
            isLoading = false
            
            switch result {
            case .success(let recipes):
                self.recipes = recipes
                self.recipeError = nil
            case .failure(let recipeError):
                self.recipes = []
                self.recipeError = recipeError
            }
        }
    }
}
