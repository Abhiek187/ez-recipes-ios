//
//  SecureStoreError.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 12/11/24.
//

import Foundation
import Security

enum SecureStoreError: Error {
    case invalidContent
    case failure(error: NSError)
}

/// Helper methods for the Keychain
///
/// - Note: Keychain stored at `~/Library/Developer/CoreSimulator/Devices/_Device-UUID_/data/Library/Keychains`
/// (`/var/Keychains` on real devices) (`~/Library/Developer/Xcode/UserData/Previews/Simulator Devices/...` in previews) (Device-UUID and App-UUID gotten from `xcrun simctl get_app_container booted BUNDLE-ID data`)
class KeychainManager {
    static let shared = KeychainManager()
    
    private func setupQueryDictionary(forKey key: String) throws -> [CFString: Any] {
        guard let keyData = key.data(using: .utf8) else {
            print("Error! Could not convert the key to the expected format.")
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
            print("Error! Could not create access control flags :: Error: \(String(describing: error))")
            throw SecureStoreError.invalidContent
        }
        
        // kSecClass defines the class of the keychain item
        // We store user credentials in the keychain, so I use kSecClassGenericPassword for the value
        // The kSecAttrAccount - keyData pair uniquely identify the account who will be accessing the keychain
        return [
            kSecClass: kSecClassGenericPassword, // genp table
            kSecAttrAccount: keyData, // account == key
//            kSecAttrAccessible: kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly,
            kSecAttrAccessControl: accessControl
        ]
    }
    
    func save(entry: String, forKey key: String) throws {
        guard !entry.isEmpty && !key.isEmpty else {
            print("Can't add an empty string to the keychain")
            throw SecureStoreError.invalidContent
        }
        // remove old value if any
//        try delete(forKey: key)
        
        var queryDictionary = try setupQueryDictionary(forKey: key)
        
        // add the value
        queryDictionary[kSecValueData] = entry.data(using: .utf8)
        
        let status = SecItemAdd(queryDictionary as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw SecureStoreError.failure(error: status.error)
        }
    }
    
    func retrieve(forKey key: String) throws -> String? {
        guard !key.isEmpty else {
            throw SecureStoreError.invalidContent
        }
        
        var queryDictionary = try setupQueryDictionary(forKey: key)
        // Set additional query attributes
        queryDictionary[kSecReturnData] = kCFBooleanTrue // expecting result of type Data
        queryDictionary[kSecMatchLimit] = kSecMatchLimitOne // limit the number of search results to one
        
        var data: AnyObject?
        
        // Returns one or more keychain items that match a search query, or copies attributes of specific keychain items
        let status = SecItemCopyMatching(queryDictionary as CFDictionary, &data) // search query
        guard status == errSecSuccess else {
            throw SecureStoreError.failure(error: status.error)
        }
        
        guard let itemData = data as? Data,
            let result = String(data: itemData, encoding: .utf8) else {
            return nil
        }
        
        return result
    }
    
    func delete(forKey key: String) throws {
        guard !key.isEmpty else {
            print("Key must be valid")
            throw SecureStoreError.invalidContent
        }
        
        let queryDictionary = try setupQueryDictionary(forKey: key)
        
        let status = SecItemDelete(queryDictionary as CFDictionary)
        guard status == errSecSuccess else {
            throw SecureStoreError.failure(error: status.error)
        }
    }
}
