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
    
    @Environment(LoginRouter.self) private var router
    @Environment(ProfileViewModel.self) private var viewModel
    @FocusState private var focusedField: Field?
    
    @State private var email = ""
    @State private var password = ""
    @State private var passwordConfirm = ""
    
    @State private var emailTouched = false
    @State private var passwordTouched = false
    @State private var passwordConfirmTouched = false
    
    @State private var emailEmpty = true
    @State private var emailInvalid = true
    @State private var passwordEmpty = true
    @State private var passwordTooShort = true
    @State private var passwordsDoNotMatch = false
    
    var body: some View {
        @Bindable var viewModel = viewModel
        
        VStack(spacing: 16) {
            HStack {
                Text(Constants.ProfileView.signUpSubHeader)
                Button {
                    router.goBack()
                } label: {
                    Text(Constants.ProfileView.signInHeader)
                }
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
            FormError(on: emailTouched && emailEmpty, message: Constants.ProfileView.fieldRequired("Email"))
            FormError(on: emailTouched && emailInvalid, message: Constants.ProfileView.emailInvalid)
            
            SecureTextField(label: Constants.ProfileView.passwordField, text: $password, isNewPassword: true)
                .focused($focusedField, equals: .password)
                .onChange(of: password) {
                    withAnimation {
                        passwordEmpty = password.isEmpty
                        passwordTooShort = password.count < Constants.passwordMinLength
                    }
                }
                .onChange(of: [password, passwordConfirm]) {
                    withAnimation {
                        passwordsDoNotMatch = password != passwordConfirm
                    }
                }
            FormError(on: passwordTouched && passwordEmpty, message: Constants.ProfileView.fieldRequired("Password"))
            FormError(on: passwordTouched && passwordTooShort, message: Constants.ProfileView.passwordMinLengthError)
            
            SecureTextField(label: Constants.ProfileView.passwordConfirmField, text: $passwordConfirm, isNewPassword: true)
                .focused($focusedField, equals: .passwordConfirm)
            // Supporting text
            if !passwordsDoNotMatch {
                Text(Constants.ProfileView.passwordMinLengthInfo)
                    .font(.subheadline)
            }
            FormError(on: passwordConfirmTouched && passwordsDoNotMatch, message: Constants.ProfileView.passwordMatch)
            
            HStack {
                Spacer()
                ProgressView()
                    .opacity(viewModel.isLoading ? 1 : 0)
                Button {
                    Task {
                        await viewModel.createAccount(username: email, password: password)
                    }
                } label: {
                    Text(Constants.ProfileView.signUpHeader)
                }
                .font(.title3)
                .disabled(emailEmpty || emailInvalid || passwordEmpty || passwordTooShort || passwordsDoNotMatch || viewModel.isLoading)
            }
        }
        .padding()
        .keyboardNavigation(focusedField: $focusedField)
        .errorAlert(isPresented: $viewModel.showAlert, message: viewModel.recipeError?.error)
        .onChange(of: focusedField) {
            withAnimation {
                if focusedField == .email {
                    emailTouched = true
                } else if focusedField == .password {
                    passwordTouched = true
                } else if focusedField == .passwordConfirm {
                    passwordConfirmTouched = true
                }
            }
        }
        .task(id: viewModel.chef) {
            if let chef = viewModel.chef, !chef.emailVerified {
                await viewModel.sendVerificationEmail()
                router.navigate(to: .verifyEmail(email: chef.email))
            }
        }
    }
}

#Preview("No Loading") {
    let mockRepo = NetworkManagerMock.shared
    let viewModel = ProfileViewModel(repository: mockRepo)
    
    SignUpForm()
        .environment(LoginRouter())
        .environment(viewModel)
}

#Preview("Loading") {
    let mockRepo = NetworkManagerMock.shared
    let viewModel = ProfileViewModel(repository: mockRepo)
    viewModel.isLoading = true
    
    return SignUpForm()
        .environment(LoginRouter())
        .environment(viewModel)
}

#Preview("Alert") {
    let mockRepo = NetworkManagerMock.shared
    let viewModel = ProfileViewModel(repository: mockRepo)
    viewModel.showAlert = true
    
    return SignUpForm()
        .environment(LoginRouter())
        .environment(viewModel)
}
