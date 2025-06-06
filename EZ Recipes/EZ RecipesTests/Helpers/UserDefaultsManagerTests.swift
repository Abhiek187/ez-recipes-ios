//
//  UserDefaultsManagerTests.swift
//  EZ RecipesTests
//
//  Created by Abhishek Chaudhuri on 5/30/24.
//

import Testing
@testable import EZ_Recipes

@Suite struct UserDefaultsManagerTests {
    @Test func saveTerms() throws {
        // Given terms
        let mockTerms = Constants.Mocks.terms.sorted { $0._id < $1._id }
        
        // When saved to UserDefaults
        UserDefaultsManager.saveTerms(terms: mockTerms)
        
        // Then they should be retrievable
        let storedTerms = try #require(UserDefaultsManager.getTerms()?.sorted { $0._id < $1._id })
        #expect(storedTerms.elementsEqual(mockTerms) {
            $0._id == $1._id && $0.word == $1.word && $0.definition == $1.definition
        })
    }
}
