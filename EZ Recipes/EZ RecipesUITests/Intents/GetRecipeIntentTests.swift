//
//  GetRecipeIntentTests.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 9/20/26.
//

#if canImport(AppIntentsTesting)

import AppIntentsTesting
import XCTest

@available(iOS 27, *)
@MainActor
class GetRecipeIntentTests: XCTestCase {
    private let app = XCUIApplication()
    private let definitions = IntentDefinitions(bundleIdentifier: "com.abhiek.EZ-Recipes")
    
    override func setUp() async throws {
        app.launch()
    }
    
    func testIntent() async throws {
        let recipePreviewDefinition = definitions.entities["RecipePreview"]
        let recipePreviews = try await recipePreviewDefinition.entities(identifiers: [644783]) // chocolate cupcake's ID
        try await definitions.intents["GetRecipeIntent"].makeIntent(target: recipePreviews[0]).run()
        
        let recipeTitle = app.staticTexts["Gluten And Dairy Free Chocolate Cupcakes"]
        XCTAssert(recipeTitle.waitForExistence(timeout: 30))
    }
    
    func testInvalidRecipe() async throws {
        let recipePreviewDefinition = definitions.entities["RecipePreview"]
        let recipePreviews = try await recipePreviewDefinition.entities(identifiers: [-1])
        XCTAssert(recipePreviews.isEmpty)
    }
}

#endif // canImport(AppIntentsTesting)
