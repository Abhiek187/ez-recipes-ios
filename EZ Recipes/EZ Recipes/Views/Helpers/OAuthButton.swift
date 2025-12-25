//
//  OAuthButton.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 12/20/25.
//

import SwiftUI
import AuthenticationServices

// Inspired by: https://github.com/firebase/FirebaseUI-iOS/blob/main/FirebaseSwiftUI/FirebaseAuthUIComponents/Sources/Components/AuthProviderButton.swift
struct OAuthButton: View {
    let provider: Provider
    var authUrl: URL?
    
    @Environment(\.webAuthenticationSession) private var webAuthenticationSession
    @Environment(ProfileViewModel.self) private var viewModel
    
    var body: some View {
        Button {
            guard let authUrl else { return }
            let redirectUrlComponents = URLComponents(string: Constants.redirectUrl)
            guard let host = redirectUrlComponents?.host, let path = redirectUrlComponents?.path else { return }
            
            Task {
                do {
                    // Start the authorization code flow
                    // Ephemeral = don't save cookies
                    let responseUrl = try await webAuthenticationSession.authenticate(using: authUrl, callback: .https(host: host, path: path), preferredBrowserSession: .ephemeral, additionalHeaderFields: [:])
                    
                    // Extract the authorization code from the redirect and then exchange it for an ID token
                    let queryItems = URLComponents(string: responseUrl.absoluteString)?.queryItems
                    let authCode = queryItems?.filter { $0.name == "code" }.first?.value
                    guard let authCode else {
                        throw NSError(domain: "No auth code received", code: 0, userInfo: nil)
                    }
                    
                    await viewModel.loginWithOAuth(code: authCode, provider: provider)
                } catch {
                    // Don't show an alert if the user closed the auth session
                    if let webError = error as? ASWebAuthenticationSessionError, webError.code == .canceledLogin && webError.userInfo.isEmpty { return }
                    
                    viewModel.recipeError = RecipeError(error: error.localizedDescription)
                    viewModel.showAlert = true
                }
            }
        } label: {
            HStack(spacing: 12) {
                Image(decorative: provider.style.label)
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                Text(provider.style.label)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .foregroundStyle(provider.style.contentColor)
            }
            .padding(.horizontal, 8)
        }
        .buttonStyle(.borderedProminent)
        .tint(provider.style.backgroundColor)
        .shadow(color: .black.opacity(0.12), radius: 2, x: 0, y: 1)
        .disabled(authUrl == nil)
    }
}

#Preview {
    let mockRepo = NetworkManagerMock.shared
    let viewModel = ProfileViewModel(repository: mockRepo)
    
    VStack(spacing: 16) {
        OAuthButton(provider: .google, authUrl: URL(string: Constants.Mocks.authUrls[0].authUrl))
        OAuthButton(provider: .facebook, authUrl: URL(string: Constants.Mocks.authUrls[1].authUrl))
        OAuthButton(provider: .github, authUrl: URL(string: Constants.Mocks.authUrls[2].authUrl))
        OAuthButton(provider: .google) // disabled
    }
    .environment(viewModel)
}
