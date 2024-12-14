//
//  KeychainManagerTests.swift
//  EZ RecipesTests
//
//  Created by Abhishek Chaudhuri on 12/13/24.
//

import XCTest
@testable import EZ_Recipes

final class KeychainManagerTests: XCTestCase {
    let keychain = KeychainManager.shared
    let key = "token"
    let token = "mockJwt"
    
    func testSaveToken() throws {
        XCTAssertThrowsError(try keychain.retrieve(forKey: key))
        try keychain.save(entry: token, forKey: key)
        XCTAssertEqual(try keychain.retrieve(forKey: key), token)
        try keychain.delete(forKey: key)
        XCTAssertThrowsError(try keychain.retrieve(forKey: key))
    }
}
