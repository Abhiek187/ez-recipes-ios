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
    
    func getRandomRecipe() async -> Result<Recipe, RecipeError> {
        return isSuccess ? .success(Constants.mockRecipe) : .failure(Constants.mockRecipeError)
    }
    
    func getRecipe(byId id: String) async -> Result<Recipe, RecipeError> {
        return isSuccess ? .success(Constants.mockRecipe) : .failure(Constants.mockRecipeError)
    }
}
