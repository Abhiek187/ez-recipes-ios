//
//  LoginSheet.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 3/22/25.
//

import SwiftUI

struct LoginSheet: View {
    @Bindable var router = LoginRouter()
    // Open the login form initially
    @State private var routes: [LoginRoute] = [.login]
    
    var body: some View {
        NavigationStack(path: $routes) {
            Text("Login Sheet")
                .navigationDestination(for: LoginRoute.self) { route in
                    switch route {
                    case .forgotPassword:
                        ForgotPasswordForm()
                    case .login:
                        LoginForm()
                    case .signUp:
                        SignUpForm()
                    case .verifyEmail(let email):
                        VerifyEmail(email: email)
                    }
                }
        }
    }
}

#Preview {
    LoginSheet()
}
