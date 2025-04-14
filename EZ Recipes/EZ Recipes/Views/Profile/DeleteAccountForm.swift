//
//  DeleteAccountForm.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 3/30/25.
//

import SwiftUI

struct DeleteAccountForm: View {
    @Environment(ProfileViewModel.self) private var viewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var username = ""
    @State private var usernameMatches = false
    
    var body: some View {
        VStack(spacing: 16) {
            Text(Constants.ProfileView.deleteAccountHeader)
                .font(.title2)
            Text(Constants.ProfileView.deleteAccountSubHeader)
                .font(.title3)
            
            TextField(Constants.ProfileView.usernameField, text: $username)
                .textContentType(.username)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .textFieldStyle(.roundedBorder)
                .onChange(of: username) {
                    withAnimation {
                        usernameMatches = username == viewModel.chef?.email
                    }
                }
            
            HStack {
                Spacer()
                ProgressView()
                    .opacity(viewModel.isLoading ? 1 : 0)
                Button(role: .destructive) {
                    Task {
                        await viewModel.deleteAccount()
                    }
                } label: {
                    Text(Constants.ProfileView.deleteAccount)
                }
                .font(.title3)
                .disabled(!usernameMatches || viewModel.isLoading)
            }
        }
        .padding()
        .onChange(of: viewModel.authState) {
            if viewModel.authState == .unauthenticated {
                dismiss()
            }
        }
    }
}

#Preview("No Loading") {
    let mockRepo = NetworkManagerMock.shared
    let viewModel = ProfileViewModel(repository: mockRepo)
    viewModel.chef = mockRepo.mockChef
    
    return DeleteAccountForm()
        .environment(viewModel)
}

#Preview("Loading") {
    let mockRepo = NetworkManagerMock.shared
    let viewModel = ProfileViewModel(repository: mockRepo)
    viewModel.chef = mockRepo.mockChef
    viewModel.isLoading = true
    
    return DeleteAccountForm()
        .environment(viewModel)
}
