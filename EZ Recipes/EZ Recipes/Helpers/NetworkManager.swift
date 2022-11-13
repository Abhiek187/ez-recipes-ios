//
//  NetworkManager.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 10/22/22.
//

import Alamofire

struct NetworkManager: RecipeRepository {
    static let shared = NetworkManager()
    private let session = Session(eventMonitors: [AFLogger()])
    
    func getRandomRecipe() async -> Result<Recipe, Error> {
        let request = session.request("\(Constants.recipeBaseUrl)/random")
        
        do {
            let recipe = try await request.serializingDecodable(Recipe.self).value
            return .success(recipe)
        } catch {
            print("getRandomRecipe :: error: \(error.localizedDescription)")
            return .failure(error)
        }
    }
    
    func getRecipe(byId id: String) async -> Result<Recipe, Error> {
        let request = session.request("\(Constants.recipeBaseUrl)/\(id)")
        
        do {
            let recipe = try await request.serializingDecodable(Recipe.self).value
            return .success(recipe)
        } catch {
            print("getRecipe(byId:) :: error: \(error.localizedDescription)")
            return .failure(error)
        }
    }
}
