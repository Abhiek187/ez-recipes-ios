//
//  HomeViewModel.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 10/30/22.
//

import Foundation

// MainActor ensures UI changes happen on the main thread
@MainActor
class HomeViewModel: ViewModel, ObservableObject {
    // Don't allow the View to make changes to the ViewModel, except for bindings
    @Published var isLoading = false
    @Published var isRecipeLoaded = false
    @Published private(set) var recipe: Recipe? {
        didSet {
            isRecipeLoaded = recipe != nil
        }
    }
    @Published var recipeFailedToLoad = false
    @Published var recipeError: RecipeError? {
        didSet {
            recipeFailedToLoad = recipeError != nil
        }
    }
    
    private var repository: RecipeRepository
    
    // Utilize dependency injection for happy little tests
    // The initializer isn't isolated since the protocol doesn't require it to be in a main actor
    nonisolated required init(repository: RecipeRepository) {
        self.repository = repository
    }
    
    func getRandomRecipe() {
        Task {
            isLoading = true
            let result = await repository.getRandomRecipe()
            isLoading = false
            
            switch result {
            case .success(let recipe):
                self.recipe = recipe
                self.recipeError = nil
            case .failure(let recipeError):
                self.recipe = nil
                self.recipeError = recipeError
            }
        }
    }
    
    func getRecipe(byId id: String) {
        Task {
            isLoading = true
            let result = await repository.getRecipe(byId: id)
            isLoading = false
            
            switch result {
            case .success(let recipe):
                self.recipe = recipe
                self.recipeError = nil
            case .failure(let recipeError):
                self.recipe = nil
                self.recipeError = recipeError
            }
        }
    }
}
