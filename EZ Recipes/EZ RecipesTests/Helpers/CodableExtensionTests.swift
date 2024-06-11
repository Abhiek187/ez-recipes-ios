//
//  CodableExtensionTests.swift
//  EZ RecipesTests
//
//  Created by Abhishek Chaudhuri on 6/9/24.
//

import XCTest
@testable import EZ_Recipes

final class CodableExtensionTests: XCTestCase {
    func testEncodableRecipe() {
        // Given a recipe
        for mockRecipe in [Constants.Mocks.blueberryYogurt, Constants.Mocks.chocolateCupcake, Constants.Mocks.thaiBasilChicken] {
            // When converted into a dictionary
            let mockRecipeDictionary = mockRecipe.dictionary
            
            // Then it should be decoded to the same recipe
            let decodedMockRecipe: Recipe? = mockRecipeDictionary.decode()
            XCTAssertEqual(mockRecipe, decodedMockRecipe)
        }
    }
}
