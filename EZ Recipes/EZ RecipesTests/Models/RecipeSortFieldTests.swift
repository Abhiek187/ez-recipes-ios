//
//  RecipeSortFieldTests.swift
//  EZ RecipesTests
//
//  Created by Abhishek Chaudhuri on 9/21/25.
//

import Testing
@testable import EZ_Recipes

@Suite struct RecipeSortFieldTests {
    @Test("Get label", arguments: [
        (RecipeSortField.calories, "Calories"),
        (.healthScore, "Health Score"),
        (.rating, "Rating"),
        (.views, "Views")
    ]) func testLabel(sortField: RecipeSortField, expectedLabel: String) {
        // Given enum values
        // When calling .label()
        let actualLabel = sortField.label()
        
        // Then it should be formatted for the UI
        #expect(actualLabel == expectedLabel)
    }
}
