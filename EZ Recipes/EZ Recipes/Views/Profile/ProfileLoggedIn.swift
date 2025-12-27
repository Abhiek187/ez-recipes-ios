//
//  ProfileLoggedIn.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 3/16/25.
//

import SwiftUI
import OrderedCollections
import AlertToast

struct ProfileLoggedIn: View {
    private enum ProfileForm {
        case updateEmail, updatePassword, deleteAccount
    }
    
    @State var chef: Chef
    @Environment(ProfileViewModel.self) private var viewModel
    
    @State private var formToShow: ProfileForm? = nil
    @State private var linkedAccounts: OrderedDictionary<Provider, [String]> = [:]
    @State private var selectedProvider: Provider = .google
    @State private var showUnlinkConfirmation = false
    
    private func buildLinkedAccounts(from providerData: [ProviderData]) -> OrderedDictionary<Provider, [String]> {
        // Start with all the supported providers
        let initialResult = OrderedDictionary<Provider, [String]>(
            uniqueKeysWithValues: Provider.allCases.map { ($0, []) }
        )
        // A chef can link 0 or more emails with a provider
        return providerData.reduce(into: initialResult) { result, providerData in
            if let providerId = Provider(rawValue: providerData.providerId) {
                result[providerId]?.append(providerData.email)
            }
        }
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
            
            Section(header: Text(Constants.ProfileView.linkedAccounts)
                .font(.title2)
            ) {
                ForEach(linkedAccounts.elements, id: \.key) { provider, emails in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            OAuthButton(provider: provider, authUrl: viewModel.authUrls[provider]?.flatMap { $0 })
                            Button(role: .destructive) {
                                // Confirm before unlinking
                                selectedProvider = provider
                                showUnlinkConfirmation = true
                            } label: {
                                Text(Constants.ProfileView.unlink)
                            }
                            .disabled(emails.isEmpty || viewModel.isLoading)
                            ProgressView()
                                .opacity(viewModel.isLoading ? 1 : 0)
                        }
                        if !emails.isEmpty {
                            HStack {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.green)
                                Text(emails.joined(separator: ", "))
                                    .font(.subheadline)
                            }
                        }
                    }
                }
            }
        }
        .listStyle(.insetGrouped) // group sections with padding
        .scrollContentBackground(.hidden) // hide section backgrounds in light mode
        .task {
            await viewModel.getAuthUrls()
        }
        .onChange(of: viewModel.chef) { _, newChef in
            if let newChef {
                chef = newChef
            }
        }
        .onChange(of: chef.providerData, initial: true) { _, newProviderData in
            linkedAccounts = buildLinkedAccounts(from: newProviderData)
        }
        .errorAlert(isPresented: .constant(viewModel.showAlert && !viewModel.loginAgain && !showUnlinkConfirmation), message: viewModel.recipeError?.error)
        .alert(Constants.ProfileView.unlinkConfirmation(selectedProvider), isPresented: $showUnlinkConfirmation) {
            HStack {
                Button(Constants.yesButton, role: .destructive) {
                    Task {
                        await viewModel.unlinkOAuthProvider(provider: selectedProvider)
                    }
                }
                Button(Constants.noButton, role: .cancel) {
                    viewModel.showAlert = false
                }
            }
        }
        .toast(isPresenting: $viewModel.accountLinked) {
            AlertToast(displayMode: .banner(.pop), type: .regular, title: Constants.ProfileView.linkSuccess(selectedProvider))
        }
        .toast(isPresenting: $viewModel.accountUnlinked) {
            AlertToast(displayMode: .banner(.pop), type: .regular, title: Constants.ProfileView.unlinkSuccess(selectedProvider))
        }
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
