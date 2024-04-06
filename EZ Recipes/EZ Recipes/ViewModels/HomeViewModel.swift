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
    @Published private(set) var task: Task<(), Never>? = nil
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
            // Don't show an alert if the request was intentionally cancelled
            recipeFailedToLoad = recipeError != nil && task?.isCancelled == false
        }
    }
    
    private var repository: RecipeRepository
    
    // Utilize dependency injection for happy little tests
    required init(repository: RecipeRepository) {
        self.repository = repository
    }
    
    func setRecipe(_ recipe: Recipe) {
        self.recipe = recipe
    }
    
    private func updateRecipeProps(from result: Result<Recipe, RecipeError>) {
        // Set the recipe and recipeError properties based on whether the result was successful
        switch result {
        case .success(let recipe):
            self.recipe = recipe
            self.recipeError = nil
        case .failure(let recipeError):
            self.recipe = nil
            self.recipeError = recipeError
        }
    }
    
    func getRandomRecipe() {
        task = Task {
            isLoading = true
            let result = await repository.getRandomRecipe()
            isLoading = false
            
            updateRecipeProps(from: result)
        }
    }
    
    func getRecipe(byId id: Int) {
        task = Task {
            isLoading = true
            let result = await repository.getRecipe(byId: id)
            isLoading = false
            
            updateRecipeProps(from: result)
        }
    }
    
    func handleRecipeLink(_ url: URL) {
        // Check if the universal link is in the format: /recipe/RECIPE_ID
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return }
        
        let path = components.path
        let recipeUrlRegex = /\/recipe\/\d+/
        guard path.contains(recipeUrlRegex) else { return }
        
        let recipeIdString = path.components(separatedBy: "/")[2]
        guard let recipeId = Int(recipeIdString) else { return }
        
        // Open RecipeView with the specified recipe ID
        getRecipe(byId: recipeId)
    }
}
