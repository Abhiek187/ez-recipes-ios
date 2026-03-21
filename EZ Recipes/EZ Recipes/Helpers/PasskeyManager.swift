//
//  PasskeyManager.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 3/14/26.
//

import AuthenticationServices
import OSLog
import SwiftUI

enum PasskeyError: Error {
    case invalidRequest
    case missingAttestation(id: Data, rpId: String)
    case unknownPasskeyResponse(result: ASAuthorizationResult)
    case cancelled
    case loginFailure(error: any Error)
    case createFailure(error: any Error)
}

extension PasskeyError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidRequest:
            return "The passkey server options couldn't be converted into Data"
        case .missingAttestation:
            return "Failed to get attestation data for the passkey. Unable to validate it against the server."
        case .unknownPasskeyResponse(result: let result):
            return "Unknown passkey response received: \(result)"
        case .cancelled:
            return "The passkey request was cancelled"
        case .loginFailure(let error):
            return "Failed to login with a passkey :: error: \(error.localizedDescription)"
        case .createFailure(let error):
            return "Failed to create a new passkey :: error: \(error.localizedDescription)"
        }
    }
}

/// Helper methods for passkeys
struct PasskeyManager {
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? Constants.appName, category: "PasskeyManager")
    
    static func deletePasskeyFromAuthenticators(withId id: Data, rpId: String = Constants.recipeWebHost) async {
        do {
            if #available(iOS 26.2, *) {
                try await ASCredentialDataManager().reportUnknownPublicKeyCredential(relyingPartyIdentifier: rpId, credentialID: id)
            } else if #available(iOS 26.0, *) {
                try await ASCredentialUpdater().reportUnknownPublicKeyCredential(relyingPartyIdentifier: rpId, credentialID: id)
            } else {
                logger.warning("The Signal API isn't supported on this device. Please delete the passkey manually from all authenticators.")
            }
        } catch {
            logger.warning("Failed to delete the passkey from all authenticators (ID: \(id.base64URLEncodedString), RP ID: \(rpId)). Please delete them manually. :: error: \(error.localizedDescription)")
        }
    }
    
    static func deletePasskeyFromAuthenticators(withId id: String, rpId: String = Constants.recipeWebHost) async {
        guard let credentialId = id.base64UrlData else { return }
        await deletePasskeyFromAuthenticators(withId: credentialId, rpId: rpId)
    }
}
