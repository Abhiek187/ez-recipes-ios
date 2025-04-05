//
//  LoginSheet.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 3/22/25.
//

import SwiftUI

struct LoginSheet: View {
    @Bindable var router = LoginRouter()
    @Environment(ProfileViewModel.self) private var viewModel
    
    var body: some View {
        @Bindable var viewModel = viewModel
        
        NavigationStack(path: $router.path) {
            LoginForm()
                .navigationTitle(Constants.ProfileView.signInHeader)
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(for: LoginRoute.self) { route in
                    switch route {
                    case .forgotPassword:
                        ForgotPasswordForm()
                    case .signUp:
                        SignUpForm()
                            .navigationTitle(Constants.ProfileView.signUpHeader)
                            .navigationBarTitleDisplayMode(.inline)
                    case .verifyEmail(let email):
                        VerifyEmail(email: email)
                    }
                }
        }
        .environment(router)
        .errorAlert(isPresented: $viewModel.showAlert, message: viewModel.recipeError?.error)
    }
}

#Preview("No Alert") {
    let mockRepo = NetworkManagerMock.shared
    let viewModel = ProfileViewModel(repository: mockRepo)
    
    LoginSheet()
        .environment(viewModel)
}

#Preview("Alert") {
    let mockRepo = NetworkManagerMock.shared
    let viewModel = ProfileViewModel(repository: mockRepo)
    viewModel.showAlert = true
    
    return LoginSheet()
        .environment(viewModel)
}
