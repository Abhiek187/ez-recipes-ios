//
//  GetRecipeDefinitionIntentTests.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 9/16/26.
//

#if canImport(AppIntentsTesting)

import AppIntentsTesting
import XCTest

@available(iOS 27, *)
@MainActor
class GetRecipeDefinitionIntentTests: XCTestCase {
    private let app = XCUIApplication()
    private let definitions = IntentDefinitions(bundleIdentifier: "com.abhiek.EZ-Recipes")
    
    override func setUp() async throws {
        app.launch()
    }
    
    func testIntent() async throws {
        let result = try await definitions.intents["GetRecipeDefinitionIntent"].makeIntent(word: "al dente").run()
        XCTAssertEqual(try result.value, "(\"to the tooth\") pasta or rice that's cooked so it can be chewed")
    }
    
    func testIntentCaseInsensitive() async throws {
        let result = try await definitions.intents["GetRecipeDefinitionIntent"].makeIntent(word: "AL DENTE").run()
        XCTAssertEqual(try result.value, "(\"to the tooth\") pasta or rice that's cooked so it can be chewed")
    }
    
    func testBlankWord() async throws {
        do {
            _ = try await definitions.intents["GetRecipeDefinitionIntent"].makeIntent(word: " ").run()
            XCTFail("Intent should've failed, but got success instead")
        } catch {
            // Can't get error inside needsValueError, but can check if the correct parameter failed
            XCTAssert(error.localizedDescription.contains("The App Intent requested value for parameter 'word'"))
        }
    }
    
    func testUnknownWord() async throws {
        do {
            _ = try await definitions.intents["GetRecipeDefinitionIntent"].makeIntent(word: "pizza").run()
            XCTFail("Intent should've failed, but got success instead")
        } catch let error as NSError {
            // The raw error prepends "LNPerformActionErrorCodeLocalizedStringResource:" before the actual error message
            XCTAssertEqual(error.underlyingErrors.first?.localizedDescription, "Error: No definition found for pizza")
        }
    }
    
    func testFindTermByWord() async throws {
        let termDefinition = definitions.entities["Term"]
        let terms = try await termDefinition.entities(matching: "al dente")
        // Only the id field is exposed from entities by default, but exposing other fields will interfere with decoding JSON responses
        // So just test if at least one result is found
        XCTAssertFalse(terms.isEmpty)
    }
    
    func testFindTermByWordCaseInsensitive() async throws {
        let termDefinition = definitions.entities["Term"]
        let terms = try await termDefinition.entities(matching: "Al Dente")
        XCTAssertFalse(terms.isEmpty)
    }
    
    func testTermAppearsInSpotlight() async throws {
        let termDefinition = definitions.entities["Term"]
        let spotlightResults = try await termDefinition.spotlightQuery("al dente")
        XCTAssertFalse(spotlightResults.isEmpty)
    }
    
    func testAllTermsIndexed() async throws {
        let termDefinition = definitions.entities["Term"]
        let allTerms = try await termDefinition.spotlightQuery()
        XCTAssertFalse(allTerms.isEmpty)
    }
}

#endif // canImport(AppIntentsTesting)
