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
    }
}

#Preview {
    let mockRepo = NetworkManagerMock.shared
    let viewModel = ProfileViewModel(repository: mockRepo)
    
    LoginSheet()
        .environment(viewModel)
}
