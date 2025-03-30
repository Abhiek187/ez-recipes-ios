//
//  ProfileViewModel.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 3/29/25.
//

import Foundation
import OSLog

@MainActor
@Observable class ProfileViewModel: ViewModel {
    var isLoading = false
    var authState: AuthState = .loading
    var chef: Chef?
    var openLoginSheet = false
    var emailSent = false
    var passwordUpdated = false
    var accountDeleted = false
    
    private(set) var recipeError: RecipeError?
    var showAlert = false
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? Constants.appName, category: "ProfileViewModel")
    private var repository: ChefRepository & RecipeRepository
    
    required init(repository: ChefRepository & RecipeRepository) {
        self.repository = repository
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
        let result: Result<Void, RecipeError> = if let token {
            await repository.logout(token: token)
        } else {
            // Assume the user should be signed out since there's no auth token
            .success(())
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
            self.recipeError = recipeError
            showAlert = token != nil
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
        let result: Result<Void, RecipeError> = if let token {
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
}
