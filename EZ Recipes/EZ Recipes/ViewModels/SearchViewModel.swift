//
//  SearchViewModel.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 2/9/24.
//

import Foundation

@MainActor
class SearchViewModel: ViewModel, ObservableObject {
    @Published private(set) var task: Task<(), Never>? = nil
    @Published var isLoading = false
    @Published var recipeFilter = RecipeFilter()
    
    @Published var isRecipeLoaded = false
    @Published var noRecipesFound = false
    @Published private(set) var recipes: [Recipe] = [] {
        didSet {
            isRecipeLoaded = !recipes.isEmpty
            noRecipesFound = recipes.isEmpty
        }
    }
    
    @Published var recipeFailedToLoad = false
    @Published private(set) var recipeError: RecipeError? {
        didSet {
            recipeFailedToLoad = recipeError != nil && task?.isCancelled == false
        }
    }
    
    private var repository: RecipeRepository
    
    nonisolated required init(repository: RecipeRepository) {
        self.repository = repository
    }
    
    func searchRecipes() {
        task = Task {
            noRecipesFound = false
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
