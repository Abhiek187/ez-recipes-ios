//
//  SearchRecipeIntentTests.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 9/20/26.
//

#if canImport(AppIntentsTesting)

import AppIntentsTesting
import XCTest

@available(iOS 27, *)
@MainActor
class SearchRecipeIntentTests: XCTestCase {
    private let app = XCUIApplication()
    private let definitions = IntentDefinitions(bundleIdentifier: "com.abhiek.EZ-Recipes")
    
    override func setUp() async throws {
        app.launch()
    }
    
    func testIntent() async throws {
        let result = try await definitions.intents["SearchRecipeIntent"].makeIntent(word: "al dente").run()
        XCTAssertEqual(try result.value, "(\"to the tooth\") pasta or rice that's cooked so it can be chewed")
    }
    
    func testSearchAndOpenRecipe() async throws {}
}

#endif // canImport(AppIntentsTesting)
