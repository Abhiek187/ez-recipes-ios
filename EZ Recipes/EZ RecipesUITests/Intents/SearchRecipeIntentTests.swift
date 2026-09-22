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
    private var searchDefinition: AppIntentDefinition!
    private var openDefinition: AppIntentDefinition!
    private var spiceLevelDefinition: AppEnumDefinition!
    private var mealTypeDefinition: AppEnumDefinition!
    private var cuisineDefinition: AppEnumDefinition!
    
    private let blankCriteria = StringSearchCriteria(term: "")
    
    override func setUp() async throws {
        app.launch()
        
        searchDefinition = definitions.intents["SearchRecipeIntent"]
        openDefinition = definitions.intents["GetRecipeIntent"]
        spiceLevelDefinition = definitions.enums["SpiceLevel"]
        mealTypeDefinition = definitions.enums["MealType"]
        cuisineDefinition = definitions.enums["Cuisine"]
    }
    
    func testIntent() async throws {
        // Adding all the filters should produce 0 results
        let searchCriteria = StringSearchCriteria(term: "pizza")
        let spiceLevels = [spiceLevelDefinition.makeCase("mild"), spiceLevelDefinition.makeCase("spicy")]
        let mealTypes = [mealTypeDefinition.makeCase("lunch"), mealTypeDefinition.makeCase("dinner")]
        let cuisines = [cuisineDefinition.makeCase("Indian")]
        
        do {
            _ = try await searchDefinition.makeIntent(criteria: searchCriteria, minCals: 500, maxCals: 800, vegetarian: true, vegan: false, glutenFree: true, healthy: false, cheap: false, sustainable: false, rating: 4, spiceLevel: spiceLevels, type: mealTypes, culture: cuisines).run()
            XCTFail("Expected 0 results, but got some results instead")
        } catch let error as NSError {
            XCTAssertEqual(error.underlyingErrors.first?.localizedDescription, "Error: No recipes found. Please try again with different filters.")
        }
    }
    
    func testSearchAndOpenRecipe() async throws {
        let searchCriteria = StringSearchCriteria(term: "chicken")
        let intentResult = try await searchDefinition.makeIntent(criteria: searchCriteria).run()
        let searchResults: [AnyAppEntity] = try intentResult.value
        XCTAssertFalse(searchResults.isEmpty)
        
        let firstRecipe = searchResults[0]
        try await openDefinition.makeIntent(target: firstRecipe).run()
        let recipeTitle = app.staticTexts[try firstRecipe.name]
        XCTAssert(recipeTitle.waitForExistence(timeout: 30))
    }
    
    func testNoFilters() async throws {
        do {
            _ = try await searchDefinition.makeIntent(criteria: blankCriteria).run() // criteria is still required
            XCTFail("Error wasn't thrown when no filters were provided")
        } catch {
            XCTAssert(error.localizedDescription.contains("At least one filter must be provided"))
        }
    }
    
    func testUnknownSpiceLevel() async throws {
        do {
            _ = try await searchDefinition.makeIntent(criteria: blankCriteria, spiceLevel: ["unknown"]).run()
            XCTFail("Error wasn't thrown when an unknown spice level was passed")
        } catch {
            XCTAssert(error.localizedDescription.contains("The App Intent requested value for parameter 'spiceLevel'"))
        }
    }
    
    func testUnknownMealType() async throws {
        do {
            _ = try await searchDefinition.makeIntent(criteria: blankCriteria, type: ["unknown"]).run()
            XCTFail("Error wasn't thrown when an unknown meal type was passed")
        } catch {
            XCTAssert(error.localizedDescription.contains("The App Intent requested value for parameter 'type'"))
        }
    }
    
    func testUnknownCuisine() async throws {
        do {
            _ = try await searchDefinition.makeIntent(criteria: blankCriteria, culture: ["unknown"]).run()
            XCTFail("Error wasn't thrown when an unknown cuisine was passed")
        } catch {
            XCTAssert(error.localizedDescription.contains("The App Intent requested value for parameter 'culture'"))
        }
    }
}

#endif // canImport(AppIntentsTesting)
