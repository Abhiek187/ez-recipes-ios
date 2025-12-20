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
/// - 2xx = a Decodable object
/// - 4xx = a RecipeError object with a known error message (defined by the server)
/// - 5xx = a RecipeError object with an unknown error message (such as a network failure)
struct NetworkManager {
    static let shared = NetworkManager()
    // Default cache behavior: https://developer.apple.com/documentation/foundation/nsurlrequest/cachepolicy-swift.enum/useprotocolcachepolicy#HTTP-caching-behavior
    // Cache directory: /APP_PATH/Library/Caches/BUNDLE_ID
    private let session = Session(cachedResponseHandler: .cache, eventMonitors: [AFLogger()])
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? Constants.appName, category: "NetworkManager")
    private let jsonEncoder = JSONParameterEncoder.default
    
    private func parseResponse<T: Decodable>(fromRequest request: DataRequest, method: String) async -> Result<T, RecipeError> {
        do {
            let responseData = try await request.serializingData().value
            
            if T.self == Empty.self && responseData.isEmpty {
                // Special check since empty responses can't be decoded
                return .success(Empty.value as! T)
            } else if let decodableResponse = try? JSONDecoder().decode(T.self, from: responseData) {
                // If successful, the request can be decoded like normal
                return .success(decodableResponse)
            } else if let errorResponse = try? JSONDecoder().decode(RecipeError.self, from: responseData) {
                // If this is a client error, the request can be decoded directly as a RecipeError object
                return .failure(errorResponse)
            }
            
            // Create a RecipeError object with the raw error response
            let rawResponse = String(data: responseData, encoding: .utf8) ?? Constants.unknownError
            return .failure(RecipeError(error: rawResponse))
        } catch {
            logger.error("\(method) :: error: \(error.localizedDescription)")
            return .failure(RecipeError(error: error.localizedDescription))
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
        let request = session.request("\(Constants.baseRecipesPath)/\(id)", method: .patch, parameters: fields, encoder: jsonEncoder) { urlRequest in
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
        let request = session.request(Constants.baseChefsPath, method: .post, parameters: credentials, encoder: jsonEncoder)
        return await parseResponse(fromRequest: request, method: #function)
    }
    
    func updateChef(fields: ChefUpdate, token: String? = nil) async -> Result<ChefEmailResponse, RecipeError> {
        let request = session.request(Constants.baseChefsPath, method: .patch, parameters: fields, encoder: jsonEncoder) { urlRequest in
            if let token {
                urlRequest.addValue(token, forHTTPHeaderField: "Authorization")
            }
        }
        
        return await parseResponse(fromRequest: request, method: #function)
    }
    
    func deleteChef(token: String) async -> Result<Empty, RecipeError> {
        let request = session.request(Constants.baseChefsPath, method: .delete, headers: [.authorization(bearerToken: token)])
        return await parseResponse(fromRequest: request, method: #function)
    }
    
    func verifyEmail(token: String) async -> Result<ChefEmailResponse, RecipeError> {
        let request = session.request("\(Constants.baseChefsPath)/verify", method: .post, headers: [.authorization(bearerToken: token)])
        return await parseResponse(fromRequest: request, method: #function)
    }
    
    func login(credentials: LoginCredentials) async -> Result<LoginResponse, RecipeError> {
        let request = session.request("\(Constants.baseChefsPath)/login", method: .post, parameters: credentials, encoder: jsonEncoder)
        return await parseResponse(fromRequest: request, method: #function)
    }
    
    func logout(token: String) async -> Result<Empty, RecipeError> {
        let request = session.request("\(Constants.baseChefsPath)/logout", method: .post, headers: [.authorization(bearerToken: token)])
        return await parseResponse(fromRequest: request, method: #function)
    }
    
    func getAuthUrls(redirectUrl: String) async -> Result<[AuthUrl], RecipeError> {
        let request = session.request("\(Constants.baseChefsPath)/oauth", parameters: ["redirectUrl": redirectUrl])
        return await parseResponse(fromRequest: request, method: #function)
    }
    
    func loginWithOAuth(oAuthRequest: OAuthRequest, token: String?) async -> Result<LoginResponse, RecipeError> {
        let request = session.request("\(Constants.baseChefsPath)/oauth", method: .post, parameters: oAuthRequest, encoder: jsonEncoder) { urlRequest in
            if let token {
                urlRequest.addValue(token, forHTTPHeaderField: "Authorization")
            }
        }
        
        return await parseResponse(fromRequest: request, method: #function)
    }
    
    func unlinkOAuthProvider(providerId: Provider, token: String) async -> Result<Token, RecipeError> {
        let request = session.request("\(Constants.baseChefsPath)/oauth", method: .delete, parameters: ["providerId": providerId], headers: [.authorization(bearerToken: token)])
        return await parseResponse(fromRequest: request, method: #function)
    }
}
