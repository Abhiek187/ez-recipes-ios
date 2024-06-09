//
//  UserDefaultsManager.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 5/30/24.
//

import Foundation
import OSLog

/// Helper methods for UserDefaults
///
/// - Note: UserDefaults stored at ~/Library/Developer/CoreSimulator/Devices/_Device-UUID_/data/Containers/Data/Application/_App-UUID_/Library/Preferences
/// (Device-UUID and App-UUID gotten from `xcrun simctl get_app_container booted BUNDLE-ID data`)
struct UserDefaultsManager {
    private static let userDefaults = UserDefaults.standard
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? Constants.appName, category: "UserDefaultsManager")
    private struct Keys {
        static let terms = "terms"
    }
    
    static func getTerms() -> [Term]? {
        guard let termStorePlist = userDefaults.value(forKey: Keys.terms) as? Data else { return nil }
        guard let termStore = try? PropertyListDecoder().decode(TermStore.self, from: termStorePlist) else {
            logger.warning("Stored terms are corrupted, deleting them and retrieving a new set of terms...")
            userDefaults.removeObject(forKey: Keys.terms)
            return nil
        }
        
        // Replace the terms if they're expired
        if Date().timeIntervalSince1970 >= termStore.expireAt {
            logger.debug("Cached terms have expired, retrieving a new set of terms...")
            return nil
        }
        
        return termStore.terms
    }
    
    static func saveTerms(terms: [Term]) {
        guard let oneWeek = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: Date()) else {
            logger.warning("Failed to add 1 week to the current date")
            return
        }
        
        let termStore = TermStore(terms: terms, expireAt: oneWeek.timeIntervalSince1970)
        guard let termStorePlist = try? PropertyListEncoder().encode(termStore) else {
            logger.warning("Couldn't encode termStore to a property list: \(String(describing: termStore))")
            return
        }
        userDefaults.set(termStorePlist, forKey: Keys.terms)
        logger.debug("Saved terms to UserDefaults!")
    }
}
