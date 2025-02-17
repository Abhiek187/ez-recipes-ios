//
//  KeychainManagerTests.swift
//  EZ RecipesTests
//
//  Created by Abhishek Chaudhuri on 12/13/24.
//

import XCTest
@testable import EZ_Recipes

final class KeychainManagerTests: XCTestCase {
    let key = "token"
    let token = "mockJwt"
    
    override func setUp() async throws {
        // Clear the Keychain before each test (but don't throw errSecItemNotFound)
        try? KeychainManager.delete(forKey: key)
    }
    
    func testSaveToken() throws {
        XCTAssertThrowsError(try KeychainManager.retrieve(forKey: key))
        try KeychainManager.save(entry: token, forKey: key)
        XCTAssertEqual(try KeychainManager.retrieve(forKey: key), token)
        try KeychainManager.delete(forKey: key)
        XCTAssertThrowsError(try KeychainManager.retrieve(forKey: key))
    }
}
