//
//  ProfileViewModel.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 3/29/25.
//

import Foundation
import OSLog
import Alamofire

@MainActor
@Observable class ProfileViewModel: ViewModel {
    var isLoading = false
    var authState: AuthState = .loading
    var chef: Chef?
    var openLoginSheet = false
    var emailSent = false
    var passwordUpdated = false
    var accountDeleted = false
    var loginAgain = false
    private(set) var authUrls: [Provider: URL?] = [:]
    
    var favoriteRecipes: [Recipe?] = []
    var recentRecipes: [Recipe?] = []
    var ratedRecipes: [Recipe?] = []
    
    var recipeError: RecipeError?
    var showAlert = false
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? Constants.appName, category: "ProfileViewModel")
    private var repository: ChefRepository & RecipeRepository
    private var swiftData = SwiftDataManager.shared
    
    required init(repository: ChefRepository & RecipeRepository) {
        self.repository = repository
    }
    
    convenience init(repository: ChefRepository & RecipeRepository, swiftData: SwiftDataManager) {
        self.init(repository: repository)
        self.swiftData = swiftData
    }
    
    private func saveToken(_ token: String) {
        do {
            try KeychainManager.save(entry: token, forKey: .token)
        } catch {
            logger.error("Error saving token: \(error)")
        }
    }
    
    private func getToken() -> String? {
        do {
            let token = try KeychainManager.retrieve(forKey: .token)
            logger.debug("Retrieved ID token from the Keychain")
            return token
        } catch {
            logger.error("Error getting token: \(error)")
            return nil
        }
    }
    
    private func clearToken() {
        do {
            try KeychainManager.delete(key: .token)
        } catch {
            logger.error("Error clearing token: \(error)")
        }
    }
    
    func createAccount(username: String, password: String) async {
        let loginCredentials = LoginCredentials(email: username, password: password)
        
        isLoading = true
        let result = await repository.createChef(credentials: loginCredentials)
        isLoading = false
        
        switch result {
        case .success(let loginResponse):
            recipeError = nil
            showAlert = false
            
            saveToken(loginResponse.token)
            chef = Chef(uid: loginResponse.uid, email: username, emailVerified: loginResponse.emailVerified, ratings: [:], recentRecipes: [:], favoriteRecipes: [], token: loginResponse.token)
        case .failure(let recipeError):
            self.recipeError = recipeError
            showAlert = true
        }
    }
    
    func sendVerificationEmail() async {
        isLoading = true
        let token = getToken()
        let result: Result<ChefEmailResponse, RecipeError> = if let token {
            await repository.verifyEmail(token: token)
        } else {
            .failure(RecipeError(error: Constants.noTokenFound))
        }
        isLoading = false
        
        switch result {
        case .success(let emailResponse):
            recipeError = nil
            showAlert = false
            
            // Don't update the chef's verified status until they click the deep link
            if let newToken = emailResponse.token {
                saveToken(newToken)
            }
        case .failure(let recipeError):
            self.recipeError = recipeError
            // Don't show an alert if the user isn't authenticated
            showAlert = token != nil
        }
    }
    
    func resetPassword(email: String) async {
        let fields = ChefUpdate(type: .password, email: email)
        isLoading = true
        let result = await repository.updateChef(fields: fields)
        isLoading = false
        
        switch result {
        case .success:
            // The response isn't needed
            emailSent = true
            recipeError = nil
            showAlert = false
        case .failure(let recipeError):
            self.recipeError = recipeError
            showAlert = true
        }
    }
    
    func getChef() async {
        isLoading = true
        let token = getToken()
        let result: Result<Chef, RecipeError> = if let token {
            await repository.getChef(token: token)
        } else {
            .failure(RecipeError(error: Constants.noTokenFound))
        }
        isLoading = false
        
        switch result {
        case .success(let chefResponse):
            chef = chefResponse
            recipeError = nil
            showAlert = false
            
            saveToken(chefResponse.token)
            authState = chefResponse.emailVerified ? .authenticated : .unauthenticated
        case .failure(let recipeError):
            self.recipeError = recipeError
            showAlert = token != nil
            
            clearToken()
            authState = .unauthenticated
        }
    }
    
    func login(username: String, password: String) async {
        let loginCredentials = LoginCredentials(email: username, password: password)
        
        isLoading = true
        let loginResult = await repository.login(credentials: loginCredentials)
        
        switch loginResult {
        case .success(let loginResponse):
            recipeError = nil
            showAlert = false
            
            saveToken(loginResponse.token)
            chef = Chef(uid: loginResponse.uid, email: username, emailVerified: loginResponse.emailVerified, ratings: [:], recentRecipes: [:], favoriteRecipes: [], token: loginResponse.token)
            
            // Fetch the rest of the chef's profile
            let chefResult = await repository.getChef(token: loginResponse.token)
            isLoading = false
            
            switch chefResult {
            case .success(let chefResponse):
                chef = chefResponse
            case .failure(let recipeError):
                self.recipeError = recipeError
                showAlert = true
            }
            
            if loginResponse.emailVerified {
                authState = .authenticated
                openLoginSheet = false
            }
        case .failure(let recipeError):
            isLoading = false
            self.recipeError = recipeError
            showAlert = true
        }
    }
    
    func logout() async {
        isLoading = true
        let token = getToken()
        let result: Result<Empty, RecipeError> = if let token {
            await repository.logout(token: token)
        } else {
            // Assume the user should be signed out since there's no auth token
            .success(.value)
        }
        isLoading = false
        
        switch result {
        case .success:
            recipeError = nil
            showAlert = false
            
            clearToken()
            chef = nil
            authState = .unauthenticated
            openLoginSheet = false
        case .failure(let recipeError):
            self.recipeError = recipeError
            showAlert = true
        }
    }
    
    func getAuthUrls() async {
        let result = await repository.getAuthUrls(redirectUrl: Constants.redirectUrl)
        
        switch result {
        case .success(let authUrls):
            recipeError = nil
            showAlert = false
            
            self.authUrls = Dictionary(uniqueKeysWithValues: authUrls.map { ($0.providerId, URL(string: $0.authUrl)) })
        case .failure(let recipeError):
            self.recipeError = recipeError
            showAlert = true
            
            authUrls = [:]
        }
    }
    
    func loginWithOAuth(code: String, provider: Provider) async {
        let oAuthRequest = OAuthRequest(code: code, providerId: provider, redirectUrl: Constants.redirectUrl)
        let token = getToken()
        
        isLoading = true
        let result = await repository.loginWithOAuth(oAuthRequest: oAuthRequest, token: token)
        
        switch result {
        case .success(let loginResponse):
            recipeError = nil
            showAlert = false
            
            saveToken(loginResponse.token)
            // The email will be gotten from the GET chef response
            chef = Chef(uid: loginResponse.uid, email: "", emailVerified: loginResponse.emailVerified, ratings: [:], recentRecipes: [:], favoriteRecipes: [], token: loginResponse.token)
            
            // Fetch the rest of the chef's profile
            let chefResult = await repository.getChef(token: loginResponse.token)
            isLoading = false
            
            switch chefResult {
            case .success(let chefResponse):
                chef = chefResponse
            case .failure(let recipeError):
                self.recipeError = recipeError
                showAlert = true
            }
            
            if loginResponse.emailVerified {
                authState = .authenticated
                openLoginSheet = false
            }
        case .failure(let recipeError):
            isLoading = false
            self.recipeError = recipeError
            showAlert = true
        }
    }
    
    func unlinkOAuthProvider(provider: Provider) async {
        isLoading = true
        let token = getToken()
        let result: Result<Token, RecipeError> = if let token {
            await repository.unlinkOAuthProvider(providerId: provider, token: token)
        } else {
            .failure(RecipeError(error: Constants.noTokenFound))
        }
        isLoading = false
        
        switch result {
        case .success(let tokenResponse):
            recipeError = nil
            showAlert = false
            
            if let newToken = tokenResponse.token {
                saveToken(newToken)
            }
        case .failure(let recipeError):
            self.recipeError = recipeError
            showAlert = true
        }
    }
    
    func updateEmail(newEmail: String) async {
        let fields = ChefUpdate(type: .email, email: newEmail)
        
        isLoading = true
        let token = getToken()
        let result: Result<ChefEmailResponse, RecipeError> = if let token {
            await repository.updateChef(fields: fields, token: token)
        } else {
            .failure(RecipeError(error: Constants.noTokenFound))
        }
        isLoading = false
        
        switch result {
        case .success(let updateResponse):
            emailSent = true
            recipeError = nil
            showAlert = false
            
            if let newToken = updateResponse.token {
                saveToken(newToken)
            }
        case .failure(let recipeError):
            if recipeError.error.contains(Constants.credentialTooOldError) {
                // Prompt the user to sign in again
                self.recipeError = nil
                showAlert = false
                loginAgain = true
            } else {
                self.recipeError = recipeError
                showAlert = token != nil
            }
        }
    }
    
    func updatePassword(newPassword: String) async {
        let fields = ChefUpdate(type: .password, email: chef?.email ?? "", password: newPassword)
        
        isLoading = true
        let token = getToken()
        let result: Result<ChefEmailResponse, RecipeError> = if let token {
            await repository.updateChef(fields: fields, token: token)
        } else {
            .failure(RecipeError(error: Constants.noTokenFound))
        }
        isLoading = false
        
        switch result {
        case .success:
            // The response isn't needed
            passwordUpdated = true
            recipeError = nil
            showAlert = false
            
            // The token will be revoked, so sign out the user
            clearToken()
            authState = .unauthenticated
        case .failure(let recipeError):
            self.recipeError = recipeError
            showAlert = token != nil
        }
    }
    
    func deleteAccount() async {
        isLoading = true
        let token = getToken()
        let result: Result<Empty, RecipeError> = if let token {
            await repository.deleteChef(token: token)
        } else {
            .failure(RecipeError(error: Constants.noTokenFound))
        }
        isLoading = false
        
        switch result {
        case .success:
            recipeError = nil
            showAlert = false
            
            clearToken()
            chef = nil
            authState = .unauthenticated
            accountDeleted = true
        case .failure(let recipeError):
            self.recipeError = recipeError
            showAlert = token != nil
        }
    }
    
    private typealias TaskGroupResult = (Result<Recipe, RecipeError>, Range<Array<Int>.Index>.Element, Int)
    
    func getAllFavoriteRecipes() async {
        guard let chef else { return }
        
        let recipeIds = chef.favoriteRecipes.compactMap { Int($0) } // compactMap == non-nil values
        favoriteRecipes = recipeIds.map { _ in nil } // nil == loading
        
        // Fetch all recipes in parallel
        await withTaskGroup(of: TaskGroupResult.self) { group in
            // zip is preferred over enumerated for guaranteed 0-based indexing: https://stackoverflow.com/a/63145650
            for (index, recipeId) in zip(recipeIds.indices, recipeIds) {
                group.addTask {
                    let result = await self.repository.getRecipe(byId: recipeId)
                    return (result, index, recipeId)
                }
            }
            
            for await (result, index, recipeId) in group {
                switch result {
                case .success(let recipeResponse):
                    // Update the state for this specific recipe
                    favoriteRecipes[index] = recipeResponse
                case .failure(let recipeError):
                    logger.warning("Failed to get recipe \(recipeId) :: error: \(recipeError.error)")
                }
            }
        }
        
        // Remove all recipes that failed to load
        favoriteRecipes.removeAll { $0 == nil }
    }
    
    func getAllRecentRecipes() async {
        guard let chef else { return }
        
        // Sort the recipe IDs by most recent timestamp
        let recipeIds = chef.recentRecipes
            .compactMap { (id, timestamp) in (Int(id), timestamp) }
            .sorted { $0.1 > $1.1 }
            .compactMap { $0.0 }
        recentRecipes = recipeIds.map { _ in nil }
        
        await withTaskGroup(of: TaskGroupResult.self) { group in
            for (index, recipeId) in zip(recipeIds.indices, recipeIds) {
                group.addTask {
                    let result = await self.repository.getRecipe(byId: recipeId)
                    return (result, index, recipeId)
                }
            }
            
            for await (result, index, recipeId) in group {
                switch result {
                case .success(let recipeResponse):
                    recentRecipes[index] = recipeResponse
                case .failure(let recipeError):
                    logger.warning("Failed to get recipe \(recipeId) :: error: \(recipeError.error)")
                }
            }
        }
        
        recentRecipes.removeAll { $0 == nil }
    }
    
    func getAllRatedRecipes() async {
        guard let chef else { return }
        
        let recipeIds = chef.ratings.compactMap { (id, _) in Int(id) }
        ratedRecipes = recipeIds.map { _ in nil }
        
        await withTaskGroup(of: TaskGroupResult.self) { group in
            for (index, recipeId) in zip(recipeIds.indices, recipeIds) {
                group.addTask {
                    let result = await self.repository.getRecipe(byId: recipeId)
                    return (result, index, recipeId)
                }
            }
            
            for await (result, index, recipeId) in group {
                switch result {
                case .success(let recipeResponse):
                    ratedRecipes[index] = recipeResponse
                case .failure(let recipeError):
                    logger.warning("Failed to get recipe \(recipeId) :: error: \(recipeError.error)")
                }
            }
        }
        
        ratedRecipes.removeAll { $0 == nil }
    }
    
    func updateViews(forRecipe recipe: Recipe) async {
        // Recipe view updates can occur in the background without impacting the UX
        let recipeUpdate = RecipeUpdate(view: true)
        let token = getToken()
        let result = await repository.updateRecipe(withId: recipe.id, fields: recipeUpdate, token: token)
        
        switch result {
        case .success(let tokenResponse):
            logger.debug("Recipe view count updated successfully")
            let currentDate = Date.now.formatted(Date.ISO8601FormatStyle(includingFractionalSeconds: true))
            chef = chef?.copy(
                recentRecipes: chef?.recentRecipes.merging([String(recipe.id): String(currentDate)]) { $1 } // overwrite the recipe's timestamp if it's already in the dictionary
            )
            
            if let newToken = tokenResponse.token {
                saveToken(newToken)
            }
        case .failure(let recipeError):
            logger.warning("Failed to update the recipe view count :: error: \(recipeError.error)")
        }
    }
    
    func toggleFavoriteRecipe(recipeId: Int, isFavorite: Bool) async {
        isLoading = true
        let recipeUpdate = RecipeUpdate(isFavorite: isFavorite)
        let token = getToken()
        let result = await repository.updateRecipe(withId: recipeId, fields: recipeUpdate, token: token)
        isLoading = false
        
        switch result {
        case .success(let tokenResponse):
            if let chef {
                self.chef = chef.copy(
                    favoriteRecipes: isFavorite ? chef.favoriteRecipes + [String(recipeId)] : chef.favoriteRecipes.filter { $0 != String(recipeId) }
                )
            }
            swiftData.toggleFavoriteRecentRecipe(forId: recipeId)
            
            if let newToken = tokenResponse.token {
                saveToken(newToken)
            }
        case .failure(let recipeError):
            logger.warning("Failed to update the recipe favorite status :: error: \(recipeError.error)")
        }
    }
    
    func rateRecipe(recipeId: Int, rating: Int) async {
        isLoading = true
        let recipeUpdate = RecipeUpdate(rating: rating)
        let token = getToken()
        let result = await repository.updateRecipe(withId: recipeId, fields: recipeUpdate, token: token)
        isLoading = false
        
        switch result {
        case .success(let tokenResponse):
            self.chef = chef?.copy(
                ratings: chef?.ratings.merging([String(recipeId): rating]) { $1 }
            )
            
            if let newToken = tokenResponse.token {
                saveToken(newToken)
            }
        case .failure(let recipeError):
            logger.warning("Failed to rate the recipe :: error: \(recipeError.error)")
        }
    }
}
