//
//  SecureStoreError.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 12/11/24.
//

import Foundation
import OSLog
import Security

enum SecureStoreError: Error {
    case invalidContent
    case failure(error: NSError)
}

extension SecureStoreError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidContent:
            return "The data provided is invalid."
        case .failure(let error):
            return error.localizedDescription // converts Error.localizedDescription to NSError.localizedDescription
        }
    }
}

/// Helper methods for the Keychain
///
/// - Note: Keychain stored at `~/Library/Developer/CoreSimulator/Devices/_Device-UUID_/data/Library/Keychains`
/// (`/var/Keychains` on real devices) (`~/Library/Developer/Xcode/UserData/Previews/Simulator Devices/...` in previews) (Device-UUID and App-UUID gotten from `xcrun simctl get_app_container booted BUNDLE-ID data`)
struct KeychainManager {
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? Constants.appName, category: "KeychainManager")
    enum Key: String {
        case token
        case mockToken // for tests only
    }
    
    private static func setupQueryDictionary(forKey key: Key) throws -> [CFString: Any] {
        guard let keyData = key.rawValue.data(using: .utf8) else {
            logger.error("Could not convert the key \"\(key.rawValue)\" to Data")
            throw SecureStoreError.invalidContent
        }
        
        var error: Unmanaged<CFError>?
        guard let accessControl = SecAccessControlCreateWithFlags(
            kCFAllocatorDefault,
            // Make the Keychain accessible only if the device has a passcode and is unlocked
            kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly,
            // Require biometrics or a passcode to access
            .userPresence,
            &error
        ) else {
            logger.error("Could not create access control flags :: Error: \(String(describing: error))")
            throw SecureStoreError.invalidContent
        }
        
        return [
            kSecClass: kSecClassGenericPassword, // genp table
            kSecAttrAccount: keyData, // account == key
            kSecAttrAccessControl: accessControl
        ]
    }
    
    static func save(entry: String, forKey key: Key) throws {
        // Remove any existing entries for key to avoid errSecDuplicateItem
        try? delete(key: key)
        
        var queryDictionary = try setupQueryDictionary(forKey: key)
        queryDictionary[kSecValueData] = entry.data(using: .utf8)
        
        let status = SecItemAdd(queryDictionary as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw SecureStoreError.failure(error: status.error)
        }
        
        logger.debug("Successfully added entry for key \"\(key.rawValue)\" to the Keychain")
    }
    
    static func retrieve(forKey key: Key) throws -> String? {
        var queryDictionary = try setupQueryDictionary(forKey: key)
        queryDictionary[kSecReturnData] = kCFBooleanTrue // expecting result of type Data
        queryDictionary[kSecMatchLimit] = kSecMatchLimitOne // limit the number of search results to one
        
        var data: AnyObject?
        
        // Returns one or more keychain items that match a search query, or copies attributes of specific keychain items
        let status = SecItemCopyMatching(queryDictionary as CFDictionary, &data)
        guard status == errSecSuccess else {
            throw SecureStoreError.failure(error: status.error)
        }
        
        guard let itemData = data as? Data,
            let result = String(data: itemData, encoding: .utf8) else {
            logger.error("Could not convert the value of key \"\(key.rawValue)\" to a String")
            return nil
        }
        
        return result
    }
    
    static func delete(key: Key) throws {
        let queryDictionary = try setupQueryDictionary(forKey: key)
        
        let status = SecItemDelete(queryDictionary as CFDictionary)
        guard status == errSecSuccess else {
            throw SecureStoreError.failure(error: status.error)
        }
        
        logger.debug("Successfully deleted key \"\(key.rawValue)\" from the Keychain")
    }
}
