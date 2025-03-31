//
//  NetworkManager.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 10/22/22.
//

import Alamofire
import OSLog

/// Repository for making requests to the ez-recipes-server API using Alamofire
///
/// Each request will respond with one of the following status codes:
/// - 2xx = a Recipe object
/// - 4xx = a RecipeError object with a known error message (defined by the server)
/// - 5xx = a RecipeError object with an unknown error message (such as a network failure)
struct NetworkManager {
    static let shared = NetworkManager()
    private let session = Session(eventMonitors: [AFLogger()])
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? Constants.appName, category: "NetworkManager")
    
    private func parseResponse<T: Decodable & Sendable>(fromRequest request: DataRequest, method: String) async -> Result<T, RecipeError> {
        do {
            // If successful, the request can be decoded as a Recipe object
            let response = try await request.serializingDecodable(T.self).value
            return .success(response)
        } catch {
            logger.error("\(method) :: error: \(error.localizedDescription)")
            
            do {
                // If this is a client error, the request can be decoded directly as a RecipeError object
                let recipeError = try await request.serializingDecodable(RecipeError.self).value
                return .failure(recipeError)
            } catch {
                // Create a RecipeError object with the raw error response
                let errorResponse = try? await request.serializingString().value
                return .failure(RecipeError(error: errorResponse ?? Constants.unknownError))
            }
        }
    }
    
    // 2nd method since Void isn't Decodable
    private func parseResponse(fromRequest request: DataRequest, method: String) async -> Result<Void, RecipeError> {
        do {
            _ = try await request.serializingString().value
            return .success(())
        } catch {
            logger.error("\(method) :: error: \(error.localizedDescription)")
            
            do {
                let recipeError = try await request.serializingDecodable(RecipeError.self).value
                return .failure(recipeError)
            } catch {
                return .failure(RecipeError(error: error.localizedDescription))
            }
        }
    }
}

// MARK: RecipeRepository
extension NetworkManager: RecipeRepository {
    func getRecipes(withFilter filter: RecipeFilter) async -> Result<[Recipe], RecipeError> {
        let baseEncoder = URLEncodedFormParameterEncoder(encoder: URLEncodedFormEncoder(
            // Don't add brackets to array parameters
            arrayEncoding: .noBrackets,
            // Convert camelCase to kebab-case (using dashes)
            keyEncoding: .convertToKebabCase
        ))
        let encoder = RecipeFilterEncoder(baseEncoder: baseEncoder)
        let request = session.request(Constants.baseRecipesPath, parameters: filter, encoder: encoder)
        return await parseResponse(fromRequest: request, method: #function)
    }
    
    func getRandomRecipe() async -> Result<Recipe, RecipeError> {
        let request = session.request("\(Constants.baseRecipesPath)/random")
        return await parseResponse(fromRequest: request, method: #function)
    }
    
    func getRecipe(byId id: Int) async -> Result<Recipe, RecipeError> {
        let request = session.request("\(Constants.baseRecipesPath)/\(id)")
        return await parseResponse(fromRequest: request, method: #function)
    }
    
    func updateRecipe(withId id: Int, fields: RecipeUpdate, token: String? = nil) async -> Result<Token, RecipeError> {
        let request = session.request("\(Constants.baseRecipesPath)/\(id)", method: .patch, parameters: fields, encoder: JSONParameterEncoder.default) { urlRequest in
            if let token {
                urlRequest.addValue(token, forHTTPHeaderField: "Authorization")
            }
        }
        
        return await parseResponse(fromRequest: request, method: #function)
    }
}

// MARK: TermRepository
extension NetworkManager: TermRepository {
    func getTerms() async -> Result<[Term], RecipeError> {
        let request = session.request(Constants.baseTermsPath)
        return await parseResponse(fromRequest: request, method: #function)
    }
}

// MARK: ChefRepository
extension NetworkManager: ChefRepository {
    func getChef(token: String) async -> Result<Chef, RecipeError> {
        let request = session.request(Constants.baseChefsPath, headers: [.authorization(bearerToken: token)])
        return await parseResponse(fromRequest: request, method: #function)
    }
    
    func createChef(credentials: LoginCredentials) async -> Result<LoginResponse, RecipeError> {
        let request = session.request(Constants.baseChefsPath, method: .post, parameters: credentials, encoder: JSONParameterEncoder.default)
        return await parseResponse(fromRequest: request, method: #function)
    }
    
    func updateChef(fields: ChefUpdate, token: String? = nil) async -> Result<ChefEmailResponse, RecipeError> {
        let request = session.request(Constants.baseChefsPath, method: .patch, parameters: fields, encoder: JSONParameterEncoder.default) { urlRequest in
            if let token {
                urlRequest.addValue(token, forHTTPHeaderField: "Authorization")
            }
        }
        
        return await parseResponse(fromRequest: request, method: #function)
    }
    
    func deleteChef(token: String) async -> Result<Void, RecipeError> {
        let request = session.request(Constants.baseChefsPath, method: .delete, headers: [.authorization(bearerToken: token)])
        return await parseResponse(fromRequest: request, method: #function)
    }
    
    func verifyEmail(token: String) async -> Result<ChefEmailResponse, RecipeError> {
        let request = session.request("\(Constants.baseChefsPath)/verify", method: .post, headers: [.authorization(bearerToken: token)])
        return await parseResponse(fromRequest: request, method: #function)
    }
    
    func login(credentials: LoginCredentials) async -> Result<LoginResponse, RecipeError> {
        let request = session.request("\(Constants.baseChefsPath)/login", method: .post, parameters: credentials, encoder: JSONParameterEncoder.default)
        return await parseResponse(fromRequest: request, method: #function)
    }
    
    func logout(token: String) async -> Result<Void, RecipeError> {
        let request = session.request("\(Constants.baseChefsPath)/logout", method: .post, headers: [.authorization(bearerToken: token)])
        return await parseResponse(fromRequest: request, method: #function)
    }
}
