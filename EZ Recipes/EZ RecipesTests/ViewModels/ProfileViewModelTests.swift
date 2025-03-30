//
//  ProfileViewModelTests.swift
//  EZ RecipesTests
//
//  Created by Abhishek Chaudhuri on 3/29/25.
//

import Testing
@testable import EZ_Recipes

private extension ProfileViewModel {
    convenience init(isSuccess: Bool = true, isEmailVerified: Bool = true) {
        var mockRepo = NetworkManagerMock.shared
        mockRepo.isSuccess = isSuccess
        mockRepo.isEmailVerified = isEmailVerified
        
        self.init(repository: mockRepo)
    }
}

@MainActor
@Suite struct ProfileViewModelTests {
    private let mockRepo = NetworkManagerMock.shared
    
    init() {
        // By default, add a token to the Keychain
        try? KeychainManager.save(entry: mockRepo.mockChef.token, forKey: .token)
    }
    
    private func clearToken() {
        try? KeychainManager.delete(key: .token)
    }
    
    @Test func createAccountSuccess() async throws {
        // Given the user's credentials
        let username = "test@example.com"
        let password = "test1234"

        // When creating an account
        let viewModel = ProfileViewModel()
        await viewModel.createAccount(username: username, password: password)

        // Then a new chef should be created
        #expect(viewModel.recipeError == nil)
        #expect(!viewModel.showAlert)
        #expect(viewModel.chef == Chef(uid: mockRepo.mockLoginResponse.uid, email: username, emailVerified: mockRepo.mockLoginResponse.emailVerified, ratings: [:], recentRecipes: [:], favoriteRecipes: [], token: mockRepo.mockLoginResponse.token))

        #expect(try KeychainManager.retrieve(forKey: .token) == mockRepo.mockLoginResponse.token)
    }

    @Test func createAccountError() async {
        // Given the user's credentials
        let username = "test@example.com"
        let password = "test1234"

        // When creating an account and an error occurs
        let viewModel = ProfileViewModel(isSuccess: false)
        await viewModel.createAccount(username: username, password: password)

        // Then an error is shown
        #expect(viewModel.chef == nil)
        #expect(viewModel.recipeError == Constants.Mocks.tokenError)
    }

    @Test func sendVerificationEmailSuccess() async throws {
        // Given a valid token
        // When sending a verification email
        let viewModel = ProfileViewModel()
        await viewModel.sendVerificationEmail()

        // Then the email should be sent
        #expect(viewModel.recipeError == nil)
        #expect(!viewModel.showAlert)
        
        #expect(try KeychainManager.retrieve(forKey: .token) == mockRepo.mockChefEmailResponse.token)
    }

    @Test func sendVerificationEmailError() async {
        // Given valid token
        // When sending a verification email and an error occurs
        let viewModel = ProfileViewModel(isSuccess: false)
        await viewModel.sendVerificationEmail()

        // Then an error is shown
        #expect(viewModel.recipeError == Constants.Mocks.tokenError)
    }

    @Test func sendVerificationEmailNoToken() async {
        // Given no token
        clearToken()
        
        // When sending a verification email
        let viewModel = ProfileViewModel()
        await viewModel.sendVerificationEmail()

        // Then an error alert isn't shown
        #expect(viewModel.recipeError == RecipeError(error: Constants.noTokenFound))
        #expect(!viewModel.showAlert)
    }

    @Test func resetPasswordSuccess() async {
        // Given an email
        let email = "test@example.com"

        // When resetting the password
        let viewModel = ProfileViewModel()
        await viewModel.resetPassword(email: email)

        // Then an email should be sent
        #expect(viewModel.emailSent)
        #expect(viewModel.recipeError == nil)
        #expect(!viewModel.showAlert)
    }

    @Test func resetPasswordError() async {
        // Given an email
        let email = "test@example.com"

        // When resetting the password and an error occurs
        let viewModel = ProfileViewModel(isSuccess: false)
        await viewModel.resetPassword(email: email)

        // Then an error is shown
        #expect(!viewModel.emailSent)
        #expect(viewModel.recipeError == Constants.Mocks.tokenError)
    }

    @Test func getChefSuccess() async throws {
        // Given a valid token
        // When getting the chef's profile
        let viewModel = ProfileViewModel()
        await viewModel.getChef()

        // Then the chef is saved and the user is authenticated
        #expect(viewModel.chef == mockRepo.mockChef)
        #expect(viewModel.recipeError == nil)
        #expect(!viewModel.showAlert)
        #expect(viewModel.authState == .authenticated)
        
        #expect(try KeychainManager.retrieve(forKey: .token) == mockRepo.mockChefEmailResponse.token)
    }

    @Test func getChefError() async {
        // Given a valid token
        // When getting the chef's profile and an error occurs
        let viewModel = ProfileViewModel(isSuccess: false)
        await viewModel.getChef()

        // Then the user is unauthenticated
        #expect(viewModel.chef == nil)
        #expect(viewModel.recipeError == Constants.Mocks.tokenError)
        #expect(viewModel.authState == .unauthenticated)

        #expect(throws: (any Error).self) {
            try KeychainManager.retrieve(forKey: .token)
        }
    }

    @Test func getChefNoToken() async {
        // Given no token
        clearToken()
        
        // When getting the chef's profile
        let viewModel = ProfileViewModel()
        await viewModel.getChef()

        // Then the user is unauthenticated
        #expect(viewModel.chef == nil)
        #expect(viewModel.recipeError == RecipeError(error: Constants.noTokenFound))
        #expect(!viewModel.showAlert)
        #expect(viewModel.authState == .unauthenticated)

        #expect(throws: (any Error).self) {
            try KeychainManager.retrieve(forKey: .token)
        }
    }

    @Test func loginSuccess() async throws {
        // Given the user's credentials
        let username = "test@example.com"
        let password = "test1234"

        // When logging in
        let viewModel = ProfileViewModel()
        await viewModel.login(username: username, password: password)

        // Then the user should be authenticated
        #expect(viewModel.recipeError == nil)
        #expect(!viewModel.showAlert)
        #expect(viewModel.chef == Chef(uid: mockRepo.mockLoginResponse.uid, email: mockRepo.mockChef.email, emailVerified: mockRepo.mockLoginResponse.emailVerified, ratings: mockRepo.mockChef.ratings, recentRecipes: mockRepo.mockChef.recentRecipes, favoriteRecipes: mockRepo.mockChef.favoriteRecipes, token: mockRepo.mockLoginResponse.token))
        #expect(viewModel.authState == .authenticated)
        #expect(!viewModel.openLoginSheet)

        #expect(try KeychainManager.retrieve(forKey: .token) == mockRepo.mockLoginResponse.token)
    }

    @Test func loginEmailNotVerified() async throws {
        // Given the user hasn't verified their email
        let username = "test@example.com"
        let password = "test1234"

        // When logging in
        let viewModel = ProfileViewModel(isEmailVerified: false)
        await viewModel.login(username: username, password: password)

        // Then a new chef should be created, but the user shouldn't be authenticated
        #expect(viewModel.recipeError == nil)
        #expect(!viewModel.showAlert)
        #expect(viewModel.chef == Chef(uid: mockRepo.mockLoginResponse.uid, email: mockRepo.mockChef.email, emailVerified: false, ratings: mockRepo.mockChef.ratings, recentRecipes: mockRepo.mockChef.recentRecipes, favoriteRecipes: mockRepo.mockChef.favoriteRecipes, token: mockRepo.mockLoginResponse.token))
        #expect(viewModel.authState != .authenticated)

        #expect(try KeychainManager.retrieve(forKey: .token) == mockRepo.mockLoginResponse.token)
    }

    @Test func loginError() async {
        // Given the user's credentials
        let username = "test@example.com"
        let password = "test1234"

        // When logging in and an error occurs
        let viewModel = ProfileViewModel(isSuccess: false)
        await viewModel.login(username: username, password: password)

        // Then an error is shown
        #expect(viewModel.chef == nil)
        #expect(viewModel.recipeError == Constants.Mocks.tokenError)
    }

    @Test func logoutSuccess() async {
        // Given a valid token
        // When logging out
        let viewModel = ProfileViewModel()
        await viewModel.logout()

        // Then the user is unauthenticated
        #expect(viewModel.recipeError == nil)
        #expect(!viewModel.showAlert)
        #expect(viewModel.chef == nil)
        #expect(viewModel.authState == .unauthenticated)
        #expect(!viewModel.openLoginSheet)

        #expect(throws: (any Error).self) {
            try KeychainManager.retrieve(forKey: .token)
        }
    }

    @Test func logoutError() async {
        // Given a valid token
        // When logging out and an error occurs
        let viewModel = ProfileViewModel(isSuccess: false)
        await viewModel.logout()

        // Then an error is shown
        #expect(viewModel.recipeError == Constants.Mocks.tokenError)
    }

    @Test func logoutNoToken() async {
        // Given no token
        clearToken()
        
        // When logging out
        let viewModel = ProfileViewModel()
        await viewModel.logout()

        // Then the user is unauthenticated
        #expect(viewModel.recipeError == nil)
        #expect(!viewModel.showAlert)
        #expect(viewModel.chef == nil)
        #expect(viewModel.authState == .unauthenticated)
        #expect(!viewModel.openLoginSheet)

        #expect(throws: (any Error).self) {
            try KeychainManager.retrieve(forKey: .token)
        }
    }

    @Test func updateEmailSuccess() async throws {
        // Given a valid token
        let newEmail = "mock@example.com"

        // When updating the chef's email
        let viewModel = ProfileViewModel()
        await viewModel.updateEmail(newEmail: newEmail)

        // Then an email should be sent
        #expect(viewModel.emailSent)
        #expect(viewModel.recipeError == nil)
        #expect(!viewModel.showAlert)

        #expect(try KeychainManager.retrieve(forKey: .token) == mockRepo.mockChefEmailResponse.token)
    }

    @Test func updateEmailError() async {
        // Given a valid token
        let newEmail = "mock@example.com"

        // When updating the chef's email and an error occurs
        let viewModel = ProfileViewModel(isSuccess: false)
        await viewModel.updateEmail(newEmail: newEmail)

        // Then an error is shown
        #expect(!viewModel.emailSent)
        #expect(viewModel.recipeError == Constants.Mocks.tokenError)
    }

    @Test func updateEmailNoToken() async {
        // Given no token
        clearToken()
        let newEmail = "mock@example.com"

        // When updating the chef's email
        let viewModel = ProfileViewModel()
        await viewModel.updateEmail(newEmail: newEmail)

        // Then an error alert isn't shown
        #expect(!viewModel.emailSent)
        #expect(viewModel.recipeError == RecipeError(error: Constants.noTokenFound))
        #expect(!viewModel.showAlert)
    }

    @Test func updatePasswordSuccess() async {
        // Given a valid token
        let newPassword = "mockPassword"

        // When updating the chef's password
        let viewModel = ProfileViewModel()
        await viewModel.updatePassword(newPassword: newPassword)

        // Then the password should be updated and the user should be signed out
        #expect(viewModel.passwordUpdated)
        #expect(viewModel.recipeError == nil)
        #expect(!viewModel.showAlert)
        #expect(viewModel.authState == .unauthenticated)

        #expect(throws: (any Error).self) {
            try KeychainManager.retrieve(forKey: .token)
        }
    }

    @Test func updatePasswordError() async {
        // Given a valid token
        let newPassword = "mockPassword"

        // When updating the chef's password and an error occurs
        let viewModel = ProfileViewModel(isSuccess: false)
        await viewModel.updatePassword(newPassword: newPassword)

        // Then an error is shown
        #expect(!viewModel.passwordUpdated)
        #expect(viewModel.recipeError == Constants.Mocks.tokenError)
    }

    @Test func updatePasswordNoToken() async {
        // Given no token
        clearToken()
        let newPassword = "mockPassword"
        
        // When updating the chef's password
        let viewModel = ProfileViewModel()
        await viewModel.updatePassword(newPassword: newPassword)

        // Then an error alert isn't shown
        #expect(!viewModel.passwordUpdated)
        #expect(viewModel.recipeError == RecipeError(error: Constants.noTokenFound))
        #expect(!viewModel.showAlert)
    }

    @Test func deleteAccountSuccess() async {
        // Given a valid token
        // When deleting the chef's account
        let viewModel = ProfileViewModel()
        await viewModel.deleteAccount()

        // Then the chef should be deleted and unauthenticated
        #expect(viewModel.chef == nil)
        #expect(viewModel.authState == .unauthenticated)
        #expect(viewModel.accountDeleted)
        #expect(viewModel.recipeError == nil)
        #expect(!viewModel.showAlert)

        #expect(throws: (any Error).self) {
            try KeychainManager.retrieve(forKey: .token)
        }
    }

    @Test func deleteAccountError() async {
        // Given a valid token
        // When deleting the chef's account and an error occurs
        let viewModel = ProfileViewModel(isSuccess: false)
        await viewModel.deleteAccount()

        // Then an error is shown
        #expect(!viewModel.accountDeleted)
        #expect(viewModel.recipeError == Constants.Mocks.tokenError)
    }

    @Test func deleteAccountNoToken() async {
        // Given no token
        clearToken()
        
        // When deleting the chef's account
        let viewModel = ProfileViewModel()
        await viewModel.deleteAccount()

        // Then an error alert isn't shown
        #expect(!viewModel.accountDeleted)
        #expect(viewModel.recipeError == RecipeError(error: Constants.noTokenFound))
        #expect(!viewModel.showAlert)
    }
}
