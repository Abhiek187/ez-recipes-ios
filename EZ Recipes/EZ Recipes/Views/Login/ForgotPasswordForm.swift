//
//  ForgotPasswordForm.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 3/22/25.
//

import SwiftUI

struct ForgotPasswordForm: View {
    @Environment(ProfileViewModel.self) private var viewModel
    
    @State private var email = ""
    
    @State private var emailTouched = false
    
    @State private var emailEmpty = true
    @State private var emailInvalid = true
    
    var body: some View {
        @Bindable var viewModel = viewModel
        
        VStack(spacing: 16) {
            if !viewModel.emailSent {
                Text(Constants.ProfileView.forgetPasswordHeader)
                    .font(.title3)
                
                TextField(Constants.ProfileView.emailField, text: $email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .textFieldStyle(.roundedBorder)
                    .onChange(of: email) {
                        withAnimation {
                            emailTouched = true
                            emailEmpty = email.isEmpty
                            emailInvalid = email.wholeMatch(of: Constants.emailRegex) == nil
                        }
                    }
                FormError(on: emailTouched && emailEmpty, message: Constants.ProfileView.fieldRequired("Email"))
                FormError(on: emailTouched && emailInvalid, message: Constants.ProfileView.emailInvalid)
                
                HStack {
                    Spacer()
                    ProgressView()
                        .opacity(viewModel.isLoading ? 1 : 0)
                    Button {
                        Task {
                            await viewModel.resetPassword(email: email)
                        }
                    } label: {
                        Text(Constants.ProfileView.submitButton)
                    }
                    .font(.title3)
                    .disabled(emailEmpty || emailInvalid || viewModel.isLoading)
                }
            } else {
                Text(Constants.ProfileView.forgetPasswordConfirm(email))
            }
        }
        .padding()
        .errorAlert(isPresented: $viewModel.showAlert, message: viewModel.recipeError?.error)
        .onAppear {
            viewModel.emailSent = false
        }
    }
}

#Preview("No Loading") {
    let mockRepo = NetworkManagerMock.shared
    let viewModel = ProfileViewModel(repository: mockRepo)
    
    ForgotPasswordForm()
        .environment(viewModel)
}

#Preview("Loading") {
    let mockRepo = NetworkManagerMock.shared
    let viewModel = ProfileViewModel(repository: mockRepo)
    viewModel.isLoading = true
    
    return ForgotPasswordForm()
        .environment(viewModel)
}

#Preview("Alert") {
    let mockRepo = NetworkManagerMock.shared
    let viewModel = ProfileViewModel(repository: mockRepo)
    viewModel.showAlert = true
    
    return ForgotPasswordForm()
        .environment(viewModel)
}
