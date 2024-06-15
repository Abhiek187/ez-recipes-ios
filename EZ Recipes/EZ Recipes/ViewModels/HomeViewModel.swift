//
//  HomeViewModel.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 10/30/22.
//

import Foundation
import OSLog

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
            saveRecentRecipe()
        }
    }
    
    @Published var recipeFailedToLoad = false
    @Published var recipeError: RecipeError? {
        didSet {
            // Don't show an alert if the request was intentionally cancelled
            recipeFailedToLoad = recipeError != nil && task?.isCancelled == false
        }
    }
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? Constants.appName, category: "HomeViewModel")
    private var repository: RecipeRepository
    private var coreData = CoreDataManager.shared
    
    // Utilize dependency injection for happy little tests
    required init(repository: RecipeRepository) {
        self.repository = repository
    }
    
    convenience init(repository: RecipeRepository, coreData: CoreDataManager) {
        self.init(repository: repository)
        self.coreData = coreData
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
    
    func checkCachedTerms() {
        // Check if terms need to be cached
        if UserDefaultsManager.getTerms() != nil { return }
        
        // The API can continue running in the background
        Task {
            let result = await repository.getTerms()
            
            switch result {
            case .success(let terms):
                UserDefaultsManager.saveTerms(terms: terms)
            case .failure(let recipeError):
                logger.warning("Failed to get terms :: error: \(recipeError.localizedDescription)")
            }
        }
    }
    
    private func saveRecentRecipe() {
        if let recipe {
            coreData.saveRecentRecipe(recipe)
        }
    }
}
