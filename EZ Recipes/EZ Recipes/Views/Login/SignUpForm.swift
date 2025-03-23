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
        SecureTextField(label: Constants.ProfileView.passwordField, text: $password, isNewPassword: true)
        SecureTextField(label: Constants.ProfileView.passwordConfirmField, text: $passwordConfirm, isNewPassword: true)
        
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
    NavigationStack {
        SignUpForm()
    }
}
