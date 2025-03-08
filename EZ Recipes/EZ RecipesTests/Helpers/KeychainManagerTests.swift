//
//  KeychainManagerTests.swift
//  EZ RecipesTests
//
//  Created by Abhishek Chaudhuri on 12/13/24.
//

import Testing
@testable import EZ_Recipes

@Suite struct KeychainManagerTests {
    let key: KeychainManager.Key = .token
    let token = "mockJwt"
    
    init() throws {
        // Clear the Keychain before each test (but don't throw errSecItemNotFound)
        try? KeychainManager.delete(key: key)
    }
    
    @Test func saveToken() throws {
        #expect(throws: (any Error).self) {
            try KeychainManager.retrieve(forKey: key)
        }
        
        try KeychainManager.save(entry: token, forKey: key)
        #expect(try KeychainManager.retrieve(forKey: key) == token)
        try KeychainManager.delete(key: key)
        
        #expect(throws: (any Error).self) {
            try KeychainManager.retrieve(forKey: key)
        }
    }
}
