//
//  SearchRecipeIntentTests.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 9/20/26.
//

#if canImport(AppIntentsTesting)

import AppIntents
import AppIntentsTesting
import XCTest

@available(iOS 27, *)
@MainActor
class SearchRecipeIntentTests: XCTestCase {
    private let app = XCUIApplication()
    private let definitions = IntentDefinitions(bundleIdentifier: "com.abhiek.EZ-Recipes")
    private let SEARCH_INTENT = "SearchRecipeIntent"
    private let OPEN_INTENT = "GetRecipeIntent"
    private let SPICE_LEVEL_ENUM = "SpiceLevel"
    private let MEAL_TYPE_ENUM = "MealType"
    private let CUISINE_ENUM = "Cuisine"
    
    override func setUp() async throws {
        app.launch()
    }
    
    func testIntent() async throws {
        // Adding all the filters should produce 0 results
        let searchCriteria = StringSearchCriteria(term: "pizza")
        let spiceLevelDefinition = definitions.enums[SPICE_LEVEL_ENUM]
        let spiceLevels = [spiceLevelDefinition.makeCase("mild"), spiceLevelDefinition.makeCase("spicy")]
        let mealTypeDefinition = definitions.enums[MEAL_TYPE_ENUM]
        let mealTypes = [mealTypeDefinition.makeCase("lunch"), mealTypeDefinition.makeCase("dinner")]
        let cuisineDefinition = definitions.enums[CUISINE_ENUM]
        let cuisines = [cuisineDefinition.makeCase("Indian")]
        
        do {
            _ = try await definitions.intents[SEARCH_INTENT].makeIntent(criteria: searchCriteria, minCals: 500, maxCals: 800, vegetarian: true, vegan: false, glutenFree: true, healthy: false, cheap: false, sustainable: false, rating: 4, spiceLevel: spiceLevels, type: mealTypes, culture: cuisines).run()
            XCTFail("Expected 0 results, but got some results instead")
        } catch let error as NSError {
            XCTAssertEqual(error.underlyingErrors.first?.localizedDescription, "Error: No recipes found. Please try again with different filters.")
        }
    }
    
    func testSearchAndOpenRecipe() async throws {}
}

#endif // canImport(AppIntentsTesting)
