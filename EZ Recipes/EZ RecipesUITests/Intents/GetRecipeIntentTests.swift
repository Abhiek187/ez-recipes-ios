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
    private var intentDefinition: AppIntentDefinition!
    private var entityDefinition: AppEntityDefinition!
    
    override func setUp() async throws {
        app.launch()
        
        intentDefinition = definitions.intents["GetRecipeIntent"]
        entityDefinition = definitions.entities["RecipePreview"]
    }
    
    func testIntent() async throws {
        let recipePreviews = try await entityDefinition.entities(identifiers: [644783]) // chocolate cupcake's ID
        try await intentDefinition.makeIntent(target: recipePreviews[0]).run()
        
        let recipeTitle = app.staticTexts["Gluten And Dairy Free Chocolate Cupcakes"]
        XCTAssert(recipeTitle.waitForExistence(timeout: 30))
    }
    
    func testInvalidRecipe() async throws {
        let recipePreviews = try await entityDefinition.entities(identifiers: [-1])
        XCTAssert(recipePreviews.isEmpty)
    }
}

#endif // canImport(AppIntentsTesting)
