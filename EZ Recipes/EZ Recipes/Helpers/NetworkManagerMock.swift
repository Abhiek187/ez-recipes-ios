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
        return isSuccess ? .success(Constants.Mocks.chocolateCupcake) : .failure(Constants.Mocks.recipeError)
    }
    
    func getRecipe(byId id: Int) async -> Result<Recipe, RecipeError> {
        return isSuccess ? .success(Constants.Mocks.chocolateCupcake) : .failure(Constants.Mocks.recipeError)
    }
}
