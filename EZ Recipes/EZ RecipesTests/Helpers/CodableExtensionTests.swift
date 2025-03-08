//
//  CodableExtensionTests.swift
//  EZ RecipesTests
//
//  Created by Abhishek Chaudhuri on 6/9/24.
//

import Testing
@testable import EZ_Recipes

@Suite struct CodableExtensionTests {
    @Test("Encode recipe", arguments: [
        Constants.Mocks.blueberryYogurt,
        Constants.Mocks.chocolateCupcake,
        Constants.Mocks.thaiBasilChicken
    ]) func encodableRecipe(mockRecipe: Recipe) {
        // Given a recipe
        // When converted into a dictionary
        let mockRecipeDictionary = mockRecipe.dictionary
        
        // Then it should be decoded to the same recipe
        let decodedMockRecipe: Recipe? = mockRecipeDictionary.decode()
        #expect(mockRecipe == decodedMockRecipe)
    }
}
