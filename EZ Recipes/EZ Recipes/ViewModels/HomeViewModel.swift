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
@Observable class HomeViewModel: ViewModel {
    // Don't allow the View to make changes to the ViewModel, except for bindings
    var isLoading = false
    var isFirstPrompt = true
    
    var isRecipeLoaded = false
    private(set) var recipe: Recipe? {
        didSet {
            isRecipeLoaded = recipe != nil
            saveRecentRecipe()
            
            if recipe != nil {
                UserDefaultsManager.incrementRecipesViewed()
            }
        }
    }
    var recentRecipes: [RecentRecipe] = []
    
    var recipeFailedToLoad = false
    var recipeError: RecipeError? {
        didSet {
            recipeFailedToLoad = recipeError != nil
        }
    }
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? Constants.appName, category: "HomeViewModel")
    private var repository: RecipeRepository & TermRepository
    private var swiftData = SwiftDataManager.shared
    
    // Utilize dependency injection for happy little tests
    required init(repository: RecipeRepository & TermRepository) {
        self.repository = repository
        self.recentRecipes = getAllRecentRecipes()
    }
    
    convenience init(repository: RecipeRepository & TermRepository, swiftData: SwiftDataManager) {
        self.init(repository: repository)
        self.swiftData = swiftData
        self.recentRecipes = getAllRecentRecipes()
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
    
    func getRandomRecipe() async {
        isLoading = true
        let result = await repository.getRandomRecipe()
        isLoading = false
        
        updateRecipeProps(from: result)
    }
    
    func getRecipe(byId id: Int) async {
        isLoading = true
        let result = await repository.getRecipe(byId: id)
        isLoading = false
        
        updateRecipeProps(from: result)
    }
    
    func handleRecipeLink(_ url: URL) async {
        // Check if the universal link is in the format: /recipe/RECIPE_ID
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return }
        
        let path = components.path
        let recipeUrlRegex = /\/recipe\/\d+/
        guard path.contains(recipeUrlRegex) else { return }
        
        let recipeIdString = path.components(separatedBy: "/")[2]
        guard let recipeId = Int(recipeIdString) else { return }
        
        // Open RecipeView with the specified recipe ID
        await getRecipe(byId: recipeId)
    }
    
    func checkCachedTerms() async {
        // Check if terms need to be cached
        if UserDefaultsManager.getTerms() != nil { return }
        
        // The API can continue running in the background
        let result = await repository.getTerms()
        
        switch result {
        case .success(let terms):
            UserDefaultsManager.saveTerms(terms: terms)
        case .failure(let recipeError):
            logger.warning("Failed to get terms :: error: \(recipeError.localizedDescription)")
        }
    }
    
    private func saveRecentRecipe() {
        if let recipe {
            swiftData.saveRecentRecipe(recipe)
            recentRecipes = getAllRecentRecipes()
        }
    }
    
    func getAllRecentRecipes() -> [RecentRecipe] {
        return swiftData.getAllRecentRecipes()
    }
}
