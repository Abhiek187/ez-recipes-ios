//
//  NetworkManagerMock.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 11/13/22.
//

// Mock the network calls to fetch a hardcoded recipe
struct NetworkManagerMock: RecipeRepository {
    static let shared = NetworkManagerMock()
    var isSuccess = true // controls whether the mock API calls succeed or fail
    var noResults = false
    
    let mockRecipes = [Constants.Mocks.blueberryYogurt, Constants.Mocks.chocolateCupcake, Constants.Mocks.thaiBasilChicken]
    
    func getRecipes(withFilter filter: RecipeFilter) async -> Result<[Recipe], RecipeError> {
        return isSuccess ? .success(noResults ? [] : mockRecipes) : .failure(Constants.Mocks.recipeError)
    }
    
    func getRandomRecipe() async -> Result<Recipe, RecipeError> {
        return isSuccess ? .success(mockRecipes[1]) : .failure(Constants.Mocks.recipeError)
    }
    
    func getRecipe(byId id: Int) async -> Result<Recipe, RecipeError> {
        return isSuccess ? .success(mockRecipes[1]) : .failure(Constants.Mocks.recipeError)
    }
    
    func getTerms() async -> Result<[Term], RecipeError> {
        return isSuccess ? .success(Constants.Mocks.terms) : .failure(Constants.Mocks.recipeError)
    }
}
