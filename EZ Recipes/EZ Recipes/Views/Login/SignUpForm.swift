//
//  SignUpForm.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 3/22/25.
//

import SwiftUI

struct SignUpForm: View {
    private enum Field: CaseIterable {
        case email
        case password
        case passwordConfirm
    }
    
    @State private var email = ""
    @State private var password = ""
    @State private var passwordConfirm = ""
    @State private var isLoading = false
    @FocusState private var focusedField: Field?
    
    @State private var emailEmpty = false
    @State private var emailInvalid = false
    @State private var passwordEmpty = false
    @State private var passwordTooShort = false
    @State private var passwordsDoNotMatch = false
    
    var body: some View {
        VStack(spacing: 16) {
            Text(Constants.ProfileView.signUpHeader)
                .font(.title)
            HStack {
                Text(Constants.ProfileView.signUpSubHeader)
                NavigationLink(Constants.ProfileView.signInHeader, value: LoginRoute.login)
            }
            .font(.title2)
            
            TextField(Constants.ProfileView.emailField, text: $email)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .textFieldStyle(.roundedBorder)
                .focused($focusedField, equals: .email)
                .onChange(of: email) {
                    withAnimation {
                        emailEmpty = email.isEmpty
                        emailInvalid = email.wholeMatch(of: Constants.emailRegex) == nil
                    }
                }
            FormError(on: emailEmpty, message: Constants.ProfileView.fieldRequired("Email"))
            FormError(on: emailInvalid, message: Constants.ProfileView.emailInvalid)
            
            SecureTextField(label: Constants.ProfileView.passwordField, text: $password, isNewPassword: true)
                .focused($focusedField, equals: .password)
                .onChange(of: password) {
                    withAnimation {
                        passwordEmpty = password.isEmpty
                        passwordTooShort = password.count < Constants.passwordMinLength
                    }
                }
            FormError(on: passwordEmpty, message: Constants.ProfileView.fieldRequired("Password"))
            FormError(on: passwordTooShort, message: Constants.ProfileView.passwordMinLengthError)
            
            SecureTextField(label: Constants.ProfileView.passwordConfirmField, text: $passwordConfirm, isNewPassword: true)
                .focused($focusedField, equals: .passwordConfirm)
                .onChange(of: passwordConfirm) {
                    withAnimation {
                        passwordsDoNotMatch = password != passwordConfirm
                    }
                }
            // Supporting text
            if !passwordsDoNotMatch {
                Text(Constants.ProfileView.passwordMinLengthInfo)
                    .font(.subheadline)
            }
            FormError(on: passwordsDoNotMatch, message: Constants.ProfileView.passwordMatch)
            
            HStack {
                Spacer()
                ProgressView()
                    .opacity(isLoading ? 1 : 0)
                Button {
                    print("Sign Up")
                } label: {
                    Text(Constants.ProfileView.signUpHeader)
                }
                .font(.title3)
                .disabled(emailEmpty || emailInvalid || passwordEmpty || passwordTooShort || passwordsDoNotMatch || isLoading)
            }
        }
        .padding()
        .keyboardNavigation(focusedField: $focusedField)
    }
}

#Preview {
    NavigationStack {
        SignUpForm()
    }
}
