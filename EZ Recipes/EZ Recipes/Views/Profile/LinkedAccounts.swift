//
//  LinkedAccounts.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 3/15/26.
//

import SwiftUI
import OrderedCollections

struct LinkedAccounts: View {
    var chef: Chef
    @Binding var selectedProvider: Provider
    @Binding var showUnlinkConfirmation: Bool
    @Environment(ProfileViewModel.self) private var viewModel
    
    @State private var linkedAccounts: OrderedDictionary<Provider, [String]> = [:]
    
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
        .onChange(of: chef.providerData, initial: true) { _, newProviderData in
            linkedAccounts = buildLinkedAccounts(from: newProviderData)
        }
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
    }
}

#Preview {
    @Previewable @State var selectedProvider: Provider = .google
    @Previewable @State var showUnlinkConfirmation = false
    
    let mockRepo = NetworkManagerMock.shared
    let viewModel = ProfileViewModel(repository: mockRepo)
    viewModel.chef = mockRepo.mockChef
    
    return LinkedAccounts(chef: mockRepo.mockChef, selectedProvider: $selectedProvider, showUnlinkConfirmation: $showUnlinkConfirmation)
        .environment(viewModel)
}
