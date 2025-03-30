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
    
    var chef: Chef
    @Bindable var viewModel: ProfileViewModel
    
    @State private var formToShow: ProfileForm? = nil
    
    var body: some View {
        VStack {
            Text(Constants.ProfileView.profileHeader(chef.email))
                .font(.title)
            
            HStack {
                Text(Constants.ProfileView.favorites(chef.favoriteRecipes.count))
                Divider()
                Text(Constants.ProfileView.recipesViewed(chef.recentRecipes.count))
                Divider()
                Text(Constants.RecipeView.totalRatings(chef.ratings.count))
            }
            .fixedSize() // prevent the dividers from taking up the full height
            
            List {
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
                .clipShape(Capsule())
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
                Button {
                    formToShow = .deleteAccount
                } label: {
                    Text(Constants.ProfileView.deleteAccount)
                        .font(.title3)
                        .tint(.red)
                }
            }
        }
        .alert(Constants.errorTitle, isPresented: $viewModel.showAlert) {
            Button(Constants.okButton, role: .cancel) {}
        } message: {
            Text(viewModel.recipeError?.error ?? Constants.unknownError)
        }
        .sheet(isPresented: .constant(formToShow != nil), onDismiss: {
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
    }
}

#Preview("No Loading") {
    let mockRepo = NetworkManagerMock.shared
    let viewModel = ProfileViewModel(repository: mockRepo)
    
    ProfileLoggedIn(chef: mockRepo.mockChef, viewModel: viewModel)
}

#Preview("Loading") {
    let mockRepo = NetworkManagerMock.shared
    let viewModel = ProfileViewModel(repository: mockRepo)
    viewModel.isLoading = true
    
    return ProfileLoggedIn(chef: mockRepo.mockChef, viewModel: viewModel)
}
