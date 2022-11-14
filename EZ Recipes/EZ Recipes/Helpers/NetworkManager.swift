//
//  NetworkManager.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 10/22/22.
//

import Alamofire

/// Repository for making requests to the ez-recipes-server API using Alamofire
///
/// Each request will respond with one of the following status codes:
/// - 2xx = a Recipe object
/// - 4xx = a RecipeError object with a known error message (defined by the server)
/// - 5xx = a RecipeError object with an unknown error message (such as a network failure)
struct NetworkManager: RecipeRepository {
    static let shared = NetworkManager()
    private let session = Session(eventMonitors: [AFLogger()])
    
    private func parseResponse(fromRequest request: DataRequest, method: String) async -> Result<Recipe, RecipeError> {
        do {
            // If successful, the request can be decoded as a Recipe object
            let recipe = try await request.serializingDecodable(Recipe.self).value
            return .success(recipe)
        } catch {
            print("\(method) :: error: \(error.localizedDescription)")
            
            do {
                // If this is a client error, the request can be decoded directly as a RecipeError object
                let recipeError = try await request.serializingDecodable(RecipeError.self).value
                return .failure(recipeError)
            } catch {
                // Create a RecipeError object with the raw error response
                return .failure(RecipeError(error: error.localizedDescription))
            }
        }
    }
    
    func getRandomRecipe() async -> Result<Recipe, RecipeError> {
        let request = session.request("\(Constants.recipeBaseUrl)/random")
        return await parseResponse(fromRequest: request, method: #function)
    }
    
    func getRecipe(byId id: String) async -> Result<Recipe, RecipeError> {
        let request = session.request("\(Constants.recipeBaseUrl)/\(id)")
        return await parseResponse(fromRequest: request, method: #function)
    }
}
