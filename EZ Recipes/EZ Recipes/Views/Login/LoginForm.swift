//
//  LoginForm.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 3/22/25.
//

import SwiftUI

struct LoginForm: View {
    private enum Field: CaseIterable {
        case username
        case password
    }
    
    @Environment(LoginRouter.self) private var router
    @FocusState private var focusedField: Field?
    
    @State private var username = ""
    @State private var password = ""
    @State private var isLoading = false
    
    // Form errors
    @State private var usernameEmpty = false
    @State private var passwordEmpty = false
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text(Constants.ProfileView.signInSubHeader)
                Button {
                    router.navigate(to: .signUp)
                } label: {
                    Text(Constants.ProfileView.signUpHeader)
                }
            }
            .font(.title2)
            
            TextField(Constants.ProfileView.usernameField, text: $username)
                .textContentType(.username)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .textFieldStyle(.roundedBorder)
                .focused($focusedField, equals: .username)
                .onChange(of: username) {
                    withAnimation {
                        usernameEmpty = username.isEmpty
                    }
                }
            FormError(on: usernameEmpty, message: Constants.ProfileView.fieldRequired("Username"))
            
            SecureTextField(label: Constants.ProfileView.passwordField, text: $password)
                .focused($focusedField, equals: .password)
                .onChange(of: password) {
                    withAnimation {
                        passwordEmpty = password.isEmpty
                    }
                }
            FormError(on: passwordEmpty, message: Constants.ProfileView.fieldRequired("Password"))
            
            Button {
                router.navigate(to: .forgotPassword)
            } label: {
                Text(Constants.ProfileView.passwordForget)
            }
            .font(.title3)
            HStack {
                Spacer()
                ProgressView()
                    .opacity(isLoading ? 1 : 0)
                Button {
                    router.navigate(to: .verifyEmail(email: username))
                } label: {
                    Text(Constants.ProfileView.login)
                }
                .font(.title3)
                .disabled(usernameEmpty || passwordEmpty || isLoading)
            }
        }
        .padding()
        .keyboardNavigation(focusedField: $focusedField)
    }
}

#Preview {
    LoginForm()
        .environment(LoginRouter())
}
