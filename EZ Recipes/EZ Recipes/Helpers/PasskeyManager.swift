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
    
    /// Signals all authenticators to delete the passkey specified
    /// - Parameters:
    ///   - id: the passkey ID to delete as Data
    ///   - rpId: the RP ID, defaults to the prod server
    static func deletePasskeyFromAuthenticators(withId id: Data, rpId: String = Constants.recipeWebHost) async {
        do {
            if #available(iOS 26.2, *) {
                try await ASCredentialDataManager().reportUnknownPublicKeyCredential(relyingPartyIdentifier: rpId, credentialID: id)
                logger.debug("Signaled all authenticators to delete passkey \(id.base64URLEncodedString) with RP ID \(rpId)")
            } else if #available(iOS 26.0, *) {
                try await ASCredentialUpdater().reportUnknownPublicKeyCredential(relyingPartyIdentifier: rpId, credentialID: id)
                logger.debug("Signaled all authenticators to delete passkey \(id.base64URLEncodedString) with RP ID \(rpId)")
            } else {
                logger.warning("The Signal API isn't supported on this device. Please delete the passkey manually from all authenticators.")
            }
        } catch {
            logger.warning("Failed to delete the passkey from all authenticators (ID: \(id.base64URLEncodedString), RP ID: \(rpId)). Please delete them manually. :: error: \(error.localizedDescription)")
        }
    }
    
    /// Signals all authenticators to delete the passkey specified
    /// - Parameters:
    ///   - id: the passkey ID to delete as a base64 URL-encoded String
    ///   - rpId: the RP ID, defaults to the prod server
    static func deletePasskeyFromAuthenticators(withId id: String, rpId: String = Constants.recipeWebHost) async {
        guard let credentialId = id.base64UrlData else { return }
        await deletePasskeyFromAuthenticators(withId: credentialId, rpId: rpId)
    }
    
    /// Signals all authenticators to only keep the passkeys specified
    /// - Parameters:
    ///   - ids: a list of passkey IDs to keep as Data
    ///   - rpId: the RP ID, defaults to the prod server
    ///   - userId: the logged in user ID as Data
    static func syncPasskeysWithServer(withIds ids: [Data], rpId: String = Constants.recipeWebHost, userId: Data) async {
        do {
            if #available(iOS 26.2, *) {
                try await ASCredentialDataManager().reportAllAcceptedPublicKeyCredentials(relyingPartyIdentifier: rpId, userHandle: userId, acceptedCredentialIDs: ids)
                logger.debug("Signaled all authenticators to sync \(ids.count) \(ids.count == 1 ? "passkey" : "passkeys") for user \(userId.string) and RP ID \(rpId): [\(ids.map(\.base64URLEncodedString).joined(separator: ", "))]")
            } else if #available(iOS 26.0, *) {
                try await ASCredentialUpdater().reportAllAcceptedPublicKeyCredentials(relyingPartyIdentifier: rpId, userHandle: userId, acceptedCredentialIDs: ids)
                logger.debug("Signaled all authenticators to sync \(ids.count) \(ids.count == 1 ? "passkey" : "passkeys") for user \(userId.string) and RP ID [\(rpId): \(ids.map(\.base64URLEncodedString).joined(separator: ", "))]")
            } else {
                logger.warning("The Signal API isn't supported on this device. Please delete any outdated passkeys manually from all authenticators.")
            }
        } catch {
            logger.warning("Failed to sync all passkeys with all authenticators (User ID: \(userId.string), RP ID: \(rpId)). Please delete the rest manually. :: error: \(error.localizedDescription)")
        }
    }
    
    /// Signals all authenticators to only keep the passkeys specified
    /// - Parameters:
    ///   - ids: a list of passkey IDs to keep as base64 URL-encoded strings
    ///   - rpId: the RP ID, defaults to the prod server
    ///   - userId: the logged in user ID as a String
    static func syncPasskeysWithServer(withIds ids: [String], rpId: String = Constants.recipeWebHost, userId: String) async {
        await syncPasskeysWithServer(withIds: ids.compactMap(\.base64UrlData), rpId: rpId, userId: userId.data)
    }
    
    /// Signals all authenticators to update the username for the provided user
    /// - Parameters:
    ///   - username: the new username
    ///   - rpId: the RP ID, defaults to the prod server
    ///   - userId: the logged in user ID as Data
    static func updateUsername(_ username: String, rpId: String = Constants.recipeWebHost, userId: Data) async {
        do {
            if #available(iOS 26.2, *) {
                try await ASCredentialDataManager().reportPublicKeyCredentialUpdate(relyingPartyIdentifier: rpId, userHandle: userId, newName: username)
                logger.debug("Signaled all authenticators to set the username for user ID \(userId.string) and RP ID \(rpId) to \(username)")
            } else if #available(iOS 26.0, *) {
                try await ASCredentialUpdater().reportPublicKeyCredentialUpdate(relyingPartyIdentifier: rpId, userHandle: userId, newName: username)
                logger.debug("Signaled all authenticators to set the username for user ID \(userId.string) and RP ID \(rpId) to \(username)")
            } else {
                logger.warning("The Signal API isn't supported on this device. Please update the username manually from all authenticators.")
            }
        } catch {
            logger.warning("Failed to update the username to \(username) for all authenticators (User ID: \(userId.string), RP ID: \(rpId)). Please update manually. :: error: \(error.localizedDescription)")
        }
    }
    
    /// Signals all authenticators to update the username for the provided user
    /// - Parameters:
    ///   - username: the new username
    ///   - rpId: the RP ID, defaults to the prod server
    ///   - userId: the logged in user ID as a String
    static func updateUsername(_ username: String, rpId: String = Constants.recipeWebHost, userId: String) async {
        await updateUsername(username, rpId: rpId, userId: userId.data)
    }
}
