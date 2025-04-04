//
//  UpdatePasswordForm.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 3/30/25.
//

import SwiftUI

struct UpdatePasswordForm: View {
    private enum Field: CaseIterable {
        case password
        case passwordConfirm
    }
    
    @Environment(ProfileViewModel.self) private var viewModel
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: Field?
    
    @State private var password = ""
    @State private var passwordConfirm = ""
    
    @State private var passwordTouched = false
    @State private var passwordConfirmTouched = false
    
    @State private var passwordEmpty = true
    @State private var passwordTooShort = true
    @State private var passwordsDoNotMatch = false
    
    var body: some View {
        VStack(spacing: 16) {
            SecureTextField(label: Constants.ProfileView.changePasswordField, text: $password, isNewPassword: true)
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
                        await viewModel.updatePassword(newPassword: password)
                    }
                } label: {
                    Text(Constants.ProfileView.submitButton)
                }
                .font(.title3)
                .disabled(passwordEmpty || passwordTooShort || passwordsDoNotMatch || viewModel.isLoading)
            }
        }
        .padding()
        .keyboardNavigation(focusedField: $focusedField)
        .onChange(of: focusedField) {
            withAnimation {
                if focusedField == .password {
                    passwordTouched = true
                } else if focusedField == .passwordConfirm {
                    passwordConfirmTouched = true
                }
            }
        }
        .onChange(of: viewModel.passwordUpdated) {
            if viewModel.passwordUpdated {
                dismiss()
            }
        }
    }
}

#Preview("No Loading") {
    let mockRepo = NetworkManagerMock.shared
    let viewModel = ProfileViewModel(repository: mockRepo)
    
    UpdatePasswordForm()
        .environment(viewModel)
}

#Preview("Loading") {
    let mockRepo = NetworkManagerMock.shared
    let viewModel = ProfileViewModel(repository: mockRepo)
    viewModel.isLoading = true
    
    return UpdatePasswordForm()
        .environment(viewModel)
}
