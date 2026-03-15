//
//  PasskeyManager.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 3/14/26.
//

import AuthenticationServices
import SwiftUI

//struct PasskeyManager {
//    @Environment(\.authorizationController) private var authorizationController
//    
//    static func getPasskey(serverPasskeyOptions: PasskeyRequestOptions) async throws -> ExistingPasskeyClientResponse {
//        let provider = ASAuthorizationPlatformPublicKeyCredentialProvider(relyingPartyIdentifier: serverPasskeyOptions.rpId)
//        let request = provider.createCredentialAssertionRequest(challenge: Data(serverPasskeyOptions.challenge.utf8))
//        request.allowedCredentials = serverPasskeyOptions.allowCredentials.map {
//            ASAuthorizationPlatformPublicKeyCredentialDescriptor(credentialID: Data($0.id.utf8))
//        }
//        
//        do {
//            let result = try await authorizationController.performRequest(request)
//            print(result)
//        } catch {
//            print(error)
//        }
//    }
//    
//    @available(iOS 26.0, *)
//    static func createPasskey(serverPasskeyOptions: PasskeyCreationOptions) async throws -> NewPasskeyClientResponse {
//        let provider = ASAuthorizationAccountCreationProvider()
//        let request = provider.createPlatformPublicKeyCredentialRegistrationRequest(acceptedContactIdentifiers: [.email], shouldRequestName: false, relyingPartyIdentifier: serverPasskeyOptions.rp.id, challenge: Data(serverPasskeyOptions.challenge.utf8), userID: Data(serverPasskeyOptions.user.id.utf8))
//        
//        do {
//            let result = try await authorizationController.performRequest(request)
//            if case .passkeyAccountCreation(let account) = result {
//                // Register new account on backend
//                print(account)
//            }
//        } catch ASAuthorizationError.deviceNotConfiguredForPasskeyCreation {
//            print("Device not configured for passkey creation")
//        } catch ASAuthorizationError.canceled {
//            print("Authorization was cancelled")
//        } catch ASAuthorizationError.preferSignInWithApple {
//            print("User prefers to sign in with Apple")
//        } catch {
//            print(error)
//            
//            // Revoking a passkey
//            try await ASCredentialUpdater().reportUnknownPublicKeyCredential(relyingPartyIdentifier: serverPasskeyOptions.rp.id, credentialID: Data())
//        }
//    }
//}
