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
    
    private func parseResponse<T: Decodable>(fromRequest request: DataRequest, method: String) async -> Result<T, RecipeError> {
        do {
            // If successful, the request can be decoded as a Recipe object
            let response = try await request.serializingDecodable(T.self).value
            return .success(response)
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
    
    func getRecipes(withFilter filter: RecipeFilter) async -> Result<[Recipe], RecipeError> {
        let baseEncoder = URLEncodedFormParameterEncoder(encoder: URLEncodedFormEncoder(
            // Don't add brackets to array parameters
            arrayEncoding: .noBrackets,
            // Convert bool parameters to true/false so they can be processed later
            boolEncoding: .literal,
            // Convert camelCase to kebab-case (using dashes)
            keyEncoding: .convertToKebabCase
        ))
        let encoder = RecipeFilterEncoder(baseEncoder: baseEncoder)
        let request = session.request("\(Constants.serverBaseUrl)\(Constants.recipesPath)", parameters: filter, encoder: encoder)
        return await parseResponse(fromRequest: request, method: #function)
    }
    
    func getRandomRecipe() async -> Result<Recipe, RecipeError> {
        let request = session.request("\(Constants.serverBaseUrl)\(Constants.recipesPath)/random")
        return await parseResponse(fromRequest: request, method: #function)
    }
    
    func getRecipe(byId id: Int) async -> Result<Recipe, RecipeError> {
        let request = session.request("\(Constants.serverBaseUrl)\(Constants.recipesPath)/\(id)")
        return await parseResponse(fromRequest: request, method: #function)
    }
    
    func getTerms() async -> Result<[Term], RecipeError> {
        let request = session.request("\(Constants.serverBaseUrl)\(Constants.termsPath)")
        return await parseResponse(fromRequest: request, method: #function)
    }
}
