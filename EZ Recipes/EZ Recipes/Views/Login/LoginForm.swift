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
    
    @State private var username = ""
    @State private var password = ""
    @State private var isLoading = false
    @FocusState private var focusedField: Field?
    
    // Form errors
    @State private var usernameEmpty = false
    @State private var passwordEmpty = false
    
    var body: some View {
        VStack(spacing: 16) {
            Text(Constants.ProfileView.signInHeader)
                .font(.title)
            HStack {
                Text(Constants.ProfileView.signInSubHeader)
                NavigationLink(Constants.ProfileView.signUpHeader, value: LoginRoute.signUp)
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
            
            NavigationLink(Constants.ProfileView.passwordForget, value: LoginRoute.forgotPassword)
                .font(.title3)
            HStack {
                Spacer()
                ProgressView()
                    .opacity(isLoading ? 1 : 0)
                Button {
                    print("Login")
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
    NavigationStack {
        LoginForm()
    }
}
