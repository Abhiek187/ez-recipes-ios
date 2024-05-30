//
//  UserDefaultsManagerTests.swift
//  EZ RecipesTests
//
//  Created by Abhishek Chaudhuri on 5/30/24.
//

import XCTest
@testable import EZ_Recipes

final class UserDefaultsManagerTests: XCTestCase {
    func testSaveTerms() {
        // Given terms
        let mockTerms = Constants.Mocks.terms.sorted { $0._id < $1._id }
        
        // When saved to UserDefaults
        UserDefaultsManager.saveTerms(terms: mockTerms)
        
        // Then they should be able to be retrieved
        let storedTerms = UserDefaultsManager.getTerms()?.sorted { $0._id < $1._id }
        XCTAssertNotNil(storedTerms)
        XCTAssert(storedTerms!.elementsEqual(mockTerms) {
            $0._id == $1._id && $0.word == $1.word && $0.definition == $1.definition
        })
    }
}
