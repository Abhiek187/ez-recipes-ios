//
//  Passkeys.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 3/15/26.
//

import SwiftUI
import AlertToast
import SVGView
import AuthenticationServices

struct Passkeys: View {
    @State var chef: Chef
    @Environment(ProfileViewModel.self) private var viewModel
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.authorizationController) private var authorizationController
    
    @State private var selectedPasskey: Passkey? = nil
    @State private var showPasskeyDeleteConfirmation = false
    
    var body: some View {
        @Bindable var viewModel = viewModel
        
        Section(header: Text(Constants.ProfileView.passkeyTitle)
            .font(.title2)
        ) {
            ForEach(chef.passkeys, id: \.id) { passkey in
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        let passkeyIcon = colorScheme == .light ? passkey.iconLight : passkey.iconDark
                        if let passkeyIcon, let passkeyIconData = passkeyIcon.base64ImageData {
                            SVGView(data: passkeyIconData)
                                .frame(width: 24, height: 24)
                        }
                        Text(passkey.name)
                            .font(.title3)
                        Button(role: .destructive) {
                            selectedPasskey = passkey
                            showPasskeyDeleteConfirmation = true
                        } label: {
                            Image(systemName: "trash.fill")
                        }
                        .accessibilityLabel(Constants.ProfileView.passkeyDelete)
                    }
                    if let lastUsed = passkey.lastUsed.date {
                        Text(Constants.ProfileView.lastUsed(lastUsed.formatted(date: .long, time: .shortened)))
                    }
                }
            }
            
            PasskeyButton(text: Constants.ProfileView.passkeyCreate) {
                Task {
                    await viewModel.createNewPasskey { serverPasskeyOptions in
                        let provider = ASAuthorizationPlatformPublicKeyCredentialProvider(relyingPartyIdentifier: serverPasskeyOptions.rp.id)
                        let request = provider.createCredentialRegistrationRequest(challenge: serverPasskeyOptions.challenge.data, name: serverPasskeyOptions.user.name, userID: serverPasskeyOptions.user.id.data)
                        request.displayName = serverPasskeyOptions.user.displayName
                        request.attestationPreference = .init(serverPasskeyOptions.attestation)
                        request.excludedCredentials = serverPasskeyOptions.excludeCredentials.map {
                            ASAuthorizationPlatformPublicKeyCredentialDescriptor(credentialID: $0.id.data)
                        }
                        request.userVerificationPreference = .init(serverPasskeyOptions.authenticatorSelection.userVerification)
                        
                        do {
                            let result = try await authorizationController.performRequest(request)
                            print(result)
                            
                            if case .passkeyRegistration(let account) = result {
                                return NewPasskeyClientResponse(authenticatorAttachment: account.attachment == .platform ? "platform" : "cross-platform", id: account.credentialID.string, rawId: account.credentialID.string, response: .init(attestationObject: account.rawAttestationObject?.string ?? "", authenticatorData: "", clientDataJSON: account.rawClientDataJSON.string, publicKey: "", publicKeyAlgorithm: ASCOSEAlgorithmIdentifier.ES256.rawValue, transports: []), type: "public-key")
                            } else {
                                throw NSError(domain: "Error", code: 0, userInfo: nil)
                            }
                        } catch ASAuthorizationError.canceled {
                            print("Authorization was cancelled")
                            throw NSError(domain: "Error", code: 0, userInfo: nil)
                        } catch {
                            print(error)
                
                            // Revoking a passkey
                            if #available(iOS 26.2, *) {
                                try await ASCredentialDataManager().reportUnknownPublicKeyCredential(relyingPartyIdentifier: serverPasskeyOptions.rp.id, credentialID: Data())
                            } else if #available(iOS 26.0, *) {
                                try await ASCredentialUpdater().reportUnknownPublicKeyCredential(relyingPartyIdentifier: serverPasskeyOptions.rp.id, credentialID: Data())
                            }
                            
                            throw NSError(domain: "Error", code: 0, userInfo: nil)
                        }
                    }
                }
            }
        }
        .alert(Constants.ProfileView.passkeyDeleteConfirmation(selectedPasskey?.name ?? ""), isPresented: $showPasskeyDeleteConfirmation) {
            HStack {
                Button(Constants.yesButton, role: .destructive) {
                    guard let selectedPasskey else { return }
                    Task {
                        await viewModel.deletePasskey(id: selectedPasskey.id)
                    }
                }
                Button(Constants.noButton, role: .cancel) {
                    viewModel.showAlert = false
                }
            }
        }
        .toast(isPresenting: $viewModel.passkeyCreated) {
            AlertToast(displayMode: .banner(.pop), type: .regular, title: Constants.ProfileView.passkeyCreated)
        }
        .toast(isPresenting: $viewModel.passkeyDeleted) {
            AlertToast(displayMode: .banner(.pop), type: .regular, title: Constants.ProfileView.passkeyDeleted)
        }
    }
}

#Preview {
    let mockRepo = NetworkManagerMock.shared
    let viewModel = ProfileViewModel(repository: mockRepo)
    viewModel.chef = mockRepo.mockChef
    
    return Passkeys(chef: mockRepo.mockChef)
        .environment(viewModel)
}
