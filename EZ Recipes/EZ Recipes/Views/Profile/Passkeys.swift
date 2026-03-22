//
//  Passkeys.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 3/15/26.
//

import SwiftUI
import AlertToast
import AuthenticationServices

struct Passkeys: View {
    @State var chef: Chef
    @Environment(ProfileViewModel.self) private var viewModel
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.authorizationController) private var authorizationController
    @ScaledMetric private var scale = 1
    
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
                        if let passkeyIcon {
                            SVGWebView(src: passkeyIcon)
                                .frame(width: 24 * scale, height: 24 * scale)
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
                        // Convert the standard WebAuthn options to an ASAuthorization request
                        guard let challenge = serverPasskeyOptions.challenge.base64UrlData, let userID = serverPasskeyOptions.user.id.base64UrlData else {
                            throw PasskeyError.invalidRequest
                        }
                        let rpId = serverPasskeyOptions.rp.id
                        let passkeyId: Data
                        
                        let provider = ASAuthorizationPlatformPublicKeyCredentialProvider(relyingPartyIdentifier: rpId)
                        let request = provider.createCredentialRegistrationRequest(challenge: challenge, name: serverPasskeyOptions.user.name, userID: userID)
                        request.displayName = serverPasskeyOptions.user.displayName
                        request.attestationPreference = .init(serverPasskeyOptions.attestation)
                        request.excludedCredentials = serverPasskeyOptions.excludeCredentials.compactMap {
                            $0.id.base64UrlData
                        }.map(ASAuthorizationPlatformPublicKeyCredentialDescriptor.init(credentialID:))
                        request.userVerificationPreference = .init(serverPasskeyOptions.authenticatorSelection.userVerification)
                        
                        do {
                            // Triggers the device to prompt for a passkey
                            let result = try await authorizationController.performRequest(request)
                            
                            // Convert the ASAuthorization response to a standard WebAuthn response
                            if case .passkeyRegistration(let account) = result {
                                passkeyId = account.credentialID
                                guard let attestationObject = account.rawAttestationObject?.base64URLEncodedString else {
                                    throw PasskeyError.missingAttestation(id: passkeyId, rpId: rpId)
                                }
                                
                                return NewPasskeyClientResponse(authenticatorAttachment: account.attachment == .platform ? "platform" : "cross-platform", id: account.credentialID.base64URLEncodedString, rawId: account.credentialID.base64URLEncodedString, response: .init(attestationObject: attestationObject, authenticatorData: nil, clientDataJSON: account.rawClientDataJSON.base64URLEncodedString, publicKey: nil, publicKeyAlgorithm: ASCOSEAlgorithmIdentifier.ES256.rawValue, transports: []), type: "public-key")
                            } else {
                                throw PasskeyError.unknownPasskeyResponse(result: result)
                            }
                        } catch ASAuthorizationError.canceled {
                            throw PasskeyError.cancelled
                        } catch {
                            throw PasskeyError.createFailure(error: error)
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
