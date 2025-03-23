//
//  LoginSheet.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 3/22/25.
//

import SwiftUI

struct LoginSheet: View {
    @Bindable var router = LoginRouter()
    
    var body: some View {
        NavigationStack(path: $router.path) {
            Text("Login Sheet")
                .navigationDestination(for: LoginRoute.self) { route in
                    switch route {
                    case .forgotPassword:
                        ForgotPasswordForm()
                    case .login:
                        LoginForm()
                            .navigationTitle(Constants.ProfileView.signInHeader)
                            .navigationBarTitleDisplayMode(.inline)
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
    LoginSheet()
}
