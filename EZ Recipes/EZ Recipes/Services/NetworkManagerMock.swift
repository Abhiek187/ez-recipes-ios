//
//  NetworkManagerMock.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 11/13/22.
//

import Alamofire

// Mock the network calls to fetch a hardcoded recipe
struct NetworkManagerMock: RecipeRepository, TermRepository, ChefRepository {
    static let shared = NetworkManagerMock()
    var isSuccess = true // controls whether the mock API calls succeed or fail
    var noResults = false
    var isEmailVerified = true
    
    let mockRecipes = [Constants.Mocks.blueberryYogurt, Constants.Mocks.chocolateCupcake, Constants.Mocks.thaiBasilChicken]
    let mockChef = Constants.Mocks.chef
    
    let mockToken: Token
    let mockLoginResponse: LoginResponse
    let mockChefEmailResponse: ChefEmailResponse
    
    init() {
        mockToken = Token(token: mockChef.token)
        mockLoginResponse = LoginResponse(uid: mockChef.uid, token: mockChef.token, emailVerified: isEmailVerified)
        mockChefEmailResponse = ChefEmailResponse(kind: "identitytoolkit#GetOobConfirmationCodeResponse", email: mockChef.email, token: mockChef.token)
    }
    
    // MARK: RecipeRepository
    func getRecipes(withFilter filter: RecipeFilter) async -> Result<[Recipe], RecipeError> {
        return isSuccess ? .success(noResults ? [] : mockRecipes) : .failure(Constants.Mocks.recipeError)
    }
    
    func getRandomRecipe() async -> Result<Recipe, RecipeError> {
        return isSuccess ? .success(mockRecipes[1]) : .failure(Constants.Mocks.recipeError)
    }
    
    func getRecipe(byId id: Int) async -> Result<Recipe, RecipeError> {
        return isSuccess ? .success(mockRecipes[1]) : .failure(Constants.Mocks.recipeError)
    }
    
    func updateRecipe(withId id: Int, fields: RecipeUpdate, token: String?) async -> Result<Token, RecipeError> {
        return isSuccess ? .success(mockToken) : .failure(Constants.Mocks.recipeError)
    }
    
    // MARK: TermRepository
    func getTerms() async -> Result<[Term], RecipeError> {
        return isSuccess ? .success(Constants.Mocks.terms) : .failure(Constants.Mocks.recipeError)
    }
    
    // MARK: ChefRepository
    func getChef(token: String) async -> Result<Chef, RecipeError> {
        return isSuccess ? .success(mockChef.copy(emailVerified: isEmailVerified)) : .failure(Constants.Mocks.tokenError)
    }
    
    func createChef(credentials: LoginCredentials) async -> Result<LoginResponse, RecipeError> {
        return isSuccess ? .success(mockLoginResponse.copy(emailVerified: isEmailVerified)) : .failure(Constants.Mocks.tokenError)
    }
    
    func updateChef(fields: ChefUpdate, token: String?) async -> Result<ChefEmailResponse, RecipeError> {
        return isSuccess ? .success(mockChefEmailResponse) : .failure(Constants.Mocks.tokenError)
    }
    
    func deleteChef(token: String) async -> Result<Empty, RecipeError> {
        // () == Void
        return isSuccess ? .success(.value) : .failure(Constants.Mocks.tokenError)
    }
    
    func verifyEmail(token: String) async -> Result<ChefEmailResponse, RecipeError> {
        return isSuccess ? .success(mockChefEmailResponse) : .failure(Constants.Mocks.tokenError)
    }
    
    func login(credentials: LoginCredentials) async -> Result<LoginResponse, RecipeError> {
        return isSuccess ? .success(mockLoginResponse.copy(emailVerified: isEmailVerified)) : .failure(Constants.Mocks.tokenError)
    }
    
    func logout(token: String) async -> Result<Empty, RecipeError> {
        return isSuccess ? .success(.value) : .failure(Constants.Mocks.tokenError)
    }
    
    func getAuthUrls(redirectUrl: String) async -> Result<[AuthUrl], RecipeError> {
        return isSuccess ? .success(Constants.Mocks.authUrls) : .failure(Constants.Mocks.recipeError)
    }
    
    func loginWithOAuth(oAuthRequest: OAuthRequest, token: String?) async -> Result<LoginResponse, RecipeError> {
        return isSuccess ? .success(mockLoginResponse) : .failure(Constants.Mocks.tokenError)
    }
    
    func unlinkOAuthProvider(providerId: Provider, token: String) async -> Result<Token, RecipeError> {
        return isSuccess ? .success(mockToken) : .failure(Constants.Mocks.tokenError)
    }
}
