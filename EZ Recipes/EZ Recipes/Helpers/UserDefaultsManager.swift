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
/// - Note: UserDefaults stored at `~/Library/Developer/CoreSimulator/Devices/_Device-UUID_/data/Containers/Data/Application/_App-UUID_/Library/Preferences`
/// (`/var/mobile/Containers/...` on real devices) (`~/Library/Developer/Xcode/UserData/Previews/Simulator Devices/...` in previews) (Device-UUID and App-UUID gotten from `xcrun simctl get_app_container booted BUNDLE-ID data`) (view plist file by running `/usr/libexec/PlistBuddy -c print PLIST-FILE`)
struct UserDefaultsManager {
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? Constants.appName, category: "UserDefaultsManager")
    struct Keys {
        static let terms = "terms"
        static let recipesViewed = "recipesViewed"
        static let lastVersionPromptedForReview = "lastVersionPromptedForReview"
        static let rememberMe = "rememberMe"
    }
    
    static func getTerms() -> [Term]? {
        guard let termStorePlist = UserDefaults.standard.value(forKey: Keys.terms) as? Data else { return nil }
        guard let termStore = try? PropertyListDecoder().decode(TermStore.self, from: termStorePlist) else {
            logger.warning("Stored terms are corrupted, deleting them and retrieving a new set of terms...")
            UserDefaults.standard.removeObject(forKey: Keys.terms)
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
        UserDefaults.standard.set(termStorePlist, forKey: Keys.terms)
        logger.debug("Saved terms to UserDefaults!")
    }
    
    static func incrementRecipesViewed() {
        let recipesViewed = UserDefaults.standard.integer(forKey: Keys.recipesViewed)
        UserDefaults.standard.set(recipesViewed + 1, forKey: Keys.recipesViewed)
    }
    
    static func getUsername() -> String? {
        // Don't autofill the username during UI tests
        if Constants.isUITest { return nil }
        guard let rememberMePlist = UserDefaults.standard.value(forKey: Keys.rememberMe) as? Data else { return nil }
        guard let rememberMe = try? PropertyListDecoder().decode(RememberMe.self, from: rememberMePlist) else {
            logger.warning("Remember Me is corrupted, clearing the entry...")
            UserDefaults.standard.removeObject(forKey: Keys.rememberMe)
            return nil
        }
        
        // Delete the username if it's expired
        if Date().timeIntervalSince1970 >= rememberMe.expireAt {
            logger.debug("Remembered username has expired")
            return nil
        }
        
        return rememberMe.username
    }
    
    static func saveUsername(_ username: String? = nil) {
        guard let oneMonth = Calendar.current.date(byAdding: .month, value: 1, to: Date()) else {
            logger.warning("Failed to add 1 month to the current date")
            return
        }
        let newUsername: String
        
        if let username {
            newUsername = username
        } else {
            // If no username is provided, use the existing username saved
            guard let existingUsername = getUsername() else {
                // If no username is saved, don't do anything
                logger.warning("No username provided and no username saved, returning early")
                return
            }
            
            newUsername = existingUsername
        }
        
        let rememberMe = RememberMe(username: newUsername, expireAt: oneMonth.timeIntervalSince1970)
        guard let rememberMePlist = try? PropertyListEncoder().encode(rememberMe) else {
            logger.warning("Couldn't encode Remember Me to a property list: \(String(describing: rememberMe))")
            return
        }
        UserDefaults.standard.set(rememberMePlist, forKey: Keys.rememberMe)
        logger.debug("Saved username \(newUsername) to UserDefaults!")
    }
    
    static func clearUsername() {
        // Mainly useful for testing
        UserDefaults.standard.removeObject(forKey: Keys.rememberMe)
    }
}
