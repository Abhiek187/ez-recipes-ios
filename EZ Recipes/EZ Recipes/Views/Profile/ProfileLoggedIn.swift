//
//  ProfileLoggedIn.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 3/16/25.
//

import SwiftUI

struct ProfileLoggedIn: View {
    private enum ProfileForm {
        case updateEmail, updatePassword, deleteAccount
    }
    
    @State var chef: Chef
    @Environment(ProfileViewModel.self) private var viewModel
    
    @State private var formToShow: ProfileForm? = nil
    @State private var showUnlinkConfirmation = false
    @State private var showPasskeyDeleteConfirmation = false
    
    private var showErrorAlert: Binding<Bool> {
        Binding(
            get: { viewModel.showAlert && !viewModel.loginAgain && !showUnlinkConfirmation && !showPasskeyDeleteConfirmation },
            set: { newValue in
                if !newValue {
                    viewModel.showAlert = false
                }
            }
        )
    }
    
    var body: some View {
        @Bindable var viewModel = viewModel
        
        List {
            Section {
                VStack(spacing: 8) {
                    HStack {
                        Spacer()
                        Text(Constants.ProfileView.profileHeader(chef.email))
                            .font(.title)
                            .padding(.horizontal)
                        Spacer()
                    }

                    HStack {
                        Text(Constants.ProfileView.favorites(chef.favoriteRecipes.count))
                        Divider()
                        Text(Constants.ProfileView.recipesViewed(chef.recentRecipes.count))
                        Divider()
                        Text(Constants.RecipeView.totalRatings(chef.ratings.count))
                    }
                    .fixedSize(horizontal: false, vertical: true) // prevent the dividers from taking up the full height
                }
            }
            .listSectionSpacing(.compact)
            
            Section {
                Button {
                    Task {
                        await viewModel.logout()
                    }
                } label: {
                    HStack(spacing: 8) {
                        Text(Constants.ProfileView.logout)
                            .font(.title3)
                        
                        if viewModel.isLoading {
                            ProgressView()
                        }
                    }
                }
                .disabled(viewModel.isLoading)
                Button {
                    formToShow = .updateEmail
                } label: {
                    Text(Constants.ProfileView.changeEmail)
                        .font(.title3)
                }
                Button {
                    formToShow = .updatePassword
                } label: {
                    Text(Constants.ProfileView.changePassword)
                        .font(.title3)
                }
                Button(role: .destructive) {
                    formToShow = .deleteAccount
                } label: {
                    Text(Constants.ProfileView.deleteAccount)
                        .font(.title3)
                }
            }
            
            LinkedAccounts(chef: chef, showUnlinkConfirmation: $showUnlinkConfirmation)
            Passkeys(chef: chef, showPasskeyDeleteConfirmation: $showPasskeyDeleteConfirmation)
        }
        .listStyle(.insetGrouped) // group sections with padding
        .scrollContentBackground(.hidden) // hide section backgrounds in light mode
        .task {
            await viewModel.getAuthUrls()
            await PasskeyManager.syncPasskeysWithServer(withIds: chef.passkeys.map(\.id), userId: chef.uid)
            // In case the chef signed in after updating their email
            await PasskeyManager.updateUsername(chef.email, userId: chef.uid)
        }
        .onChange(of: viewModel.chef) { _, newChef in
            if let newChef {
                chef = newChef
            }
        }
        .errorAlert(isPresented: showErrorAlert, message: viewModel.recipeError?.error)
        .sheet(isPresented: .constant(formToShow != nil && !viewModel.loginAgain), onDismiss: {
            formToShow = nil
        }) {
            Group {
                if formToShow == .updateEmail {
                    UpdateEmailForm()
                } else if formToShow == .updatePassword {
                    UpdatePasswordForm()
                } else if formToShow == .deleteAccount {
                    DeleteAccountForm()
                }
            }
            .presentationDetents([.medium]) // half-screen modal
        }
        .sheet(isPresented: $viewModel.loginAgain) {
            LoginForm()
                .errorAlert(isPresented: $viewModel.showAlert, message: viewModel.recipeError?.error)
                .onChange(of: viewModel.chef) {
                    // After logging in, go back to the previous sheet
                    viewModel.loginAgain = false
                    formToShow = .updateEmail
                }
        }
    }
}

#Preview("No Loading") {
    let mockRepo = NetworkManagerMock.shared
    let viewModel = ProfileViewModel(repository: mockRepo)
    viewModel.chef = mockRepo.mockChef
    
    return ProfileLoggedIn(chef: mockRepo.mockChef)
        .environment(viewModel)
}

#Preview("Loading") {
    let mockRepo = NetworkManagerMock.shared
    let viewModel = ProfileViewModel(repository: mockRepo)
    viewModel.chef = mockRepo.mockChef
    viewModel.isLoading = true
    
    return ProfileLoggedIn(chef: mockRepo.mockChef)
        .environment(viewModel)
}

#Preview("Alert") {
    let mockRepo = NetworkManagerMock.shared
    let viewModel = ProfileViewModel(repository: mockRepo)
    viewModel.chef = mockRepo.mockChef
    viewModel.showAlert = true
    
    return ProfileLoggedIn(chef: mockRepo.mockChef)
        .environment(viewModel)
}

#Preview("Account Linked") {
    let mockRepo = NetworkManagerMock.shared
    let viewModel = ProfileViewModel(repository: mockRepo)
    viewModel.chef = mockRepo.mockChef
    viewModel.accountLinked = true
    
    return ProfileLoggedIn(chef: mockRepo.mockChef)
        .environment(viewModel)
}

#Preview("Account Unlinked") {
    let mockRepo = NetworkManagerMock.shared
    let viewModel = ProfileViewModel(repository: mockRepo)
    viewModel.chef = mockRepo.mockChef
    viewModel.accountUnlinked = true
    
    return ProfileLoggedIn(chef: mockRepo.mockChef)
        .environment(viewModel)
}

#Preview("Passkey Created") {
    let mockRepo = NetworkManagerMock.shared
    let viewModel = ProfileViewModel(repository: mockRepo)
    viewModel.chef = mockRepo.mockChef
    viewModel.passkeyCreated = true
    
    return ProfileLoggedIn(chef: mockRepo.mockChef)
        .environment(viewModel)
}

#Preview("Passkey Deleted") {
    let mockRepo = NetworkManagerMock.shared
    let viewModel = ProfileViewModel(repository: mockRepo)
    viewModel.chef = mockRepo.mockChef
    viewModel.passkeyDeleted = true
    
    return ProfileLoggedIn(chef: mockRepo.mockChef)
        .environment(viewModel)
}
