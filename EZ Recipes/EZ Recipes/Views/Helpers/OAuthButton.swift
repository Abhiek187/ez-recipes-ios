//
//  OAuthButton.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 12/20/25.
//

import SwiftUI

// Inspired by: https://github.com/firebase/FirebaseUI-iOS/blob/main/FirebaseSwiftUI/FirebaseAuthUIComponents/Sources/Components/AuthProviderButton.swift
struct OAuthButton: View {
    let provider: Provider
    var authUrl: URL?
    
    var body: some View {
        Button {
            // Start the authorization code flow
            guard let authUrl else { return }
            
            print("Login to \(provider) at \(authUrl)")
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
    VStack(spacing: 16) {
        OAuthButton(provider: .google, authUrl: URL(string: Constants.Mocks.authUrls[0].authUrl))
        OAuthButton(provider: .facebook, authUrl: URL(string: Constants.Mocks.authUrls[1].authUrl))
        OAuthButton(provider: .github, authUrl: URL(string: Constants.Mocks.authUrls[2].authUrl))
        OAuthButton(provider: .google) // disabled
    }
}
