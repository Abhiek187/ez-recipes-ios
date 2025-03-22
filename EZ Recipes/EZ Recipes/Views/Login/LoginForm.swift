//
//  LoginForm.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 3/22/25.
//

import SwiftUI

struct LoginForm: View {
    @State private var username = ""
    @State private var password = ""
    
    var body: some View {
        VStack {
            Text(Constants.ProfileView.signInHeader)
                .font(.headline)
            HStack {
                Text(Constants.ProfileView.signInSubHeader)
                NavigationLink(Constants.ProfileView.signUpHeader, value: LoginRoute.signUp)
            }
            
            TextField(Constants.ProfileView.usernameField, text: $username)
                .textContentType(.username)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .textFieldStyle(.roundedBorder)
            TextField(Constants.ProfileView.passwordField, text: $password)
                .textContentType(.password)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .textFieldStyle(.roundedBorder)
            
            NavigationLink(Constants.ProfileView.passwordForget, value: LoginRoute.forgotPassword)
            HStack {
                Spacer()
                ProgressView()
                    .opacity(1)
                Button {
                    print("Login")
                } label: {
                    Text(Constants.ProfileView.login)
                }
            }
        }
    }
}

#Preview {
    LoginForm()
}
