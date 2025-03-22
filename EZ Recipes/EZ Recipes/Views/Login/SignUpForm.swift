//
//  SignUpForm.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 3/22/25.
//

import SwiftUI

struct SignUpForm: View {
    @State private var email = ""
    @State private var password = ""
    @State private var passwordConfirm = ""
    
    var body: some View {
        Text(Constants.ProfileView.signUpHeader)
            .font(.headline)
        HStack {
            Text(Constants.ProfileView.signUpSubHeader)
            NavigationLink(Constants.ProfileView.signInHeader, value: LoginRoute.login)
        }
        
        TextField(Constants.ProfileView.emailField, text: $email)
            .textContentType(.emailAddress)
            .keyboardType(.emailAddress)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .textFieldStyle(.roundedBorder)
        TextField(Constants.ProfileView.passwordField, text: $password)
            .textContentType(.newPassword)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .textFieldStyle(.roundedBorder)
        TextField(Constants.ProfileView.passwordConfirmField, text: $passwordConfirm)
            .textContentType(.newPassword)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .textFieldStyle(.roundedBorder)
        
        HStack {
            Spacer()
            ProgressView()
                .opacity(1)
            Button {
                print("Sign Up")
            } label: {
                Text(Constants.ProfileView.signUpHeader)
            }
        }
    }
}

#Preview {
    SignUpForm()
}
