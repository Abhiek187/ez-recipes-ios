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
    private var intentDefinition: AppIntentDefinition!
    private var entityDefinition: AppEntityDefinition!
    
    private let testWord = "al dente"
    private let testDefinition = "(\"to the tooth\") pasta or rice that's cooked so it can be chewed"
    
    override func setUp() async throws {
        app.launch()
        
        intentDefinition = definitions.intents["GetRecipeDefinitionIntent"]
        entityDefinition = definitions.entities["Term"]
        
        // Go to the glossary screen so the entities can be donated for Spotlight tests
        goTo(tab: "Glossary")
        let predicate = NSPredicate(format: "label CONTAINS[cd] %@", testWord) // cd = case & diacritic-insensitive
        XCTAssert(app.staticTexts.element(matching: predicate).waitForExistence(timeout: 30))
    }
    
    private func goTo(tab: String) {
        // On iPadOS 18+, the tab bars are floating tab buttons
        let tabBar = app.tabBars["Tab Bar"]
        
        if tabBar.exists {
            tabBar.buttons[tab].tap()
        } else {
            app.buttons[tab].firstMatch.tap()
        }
    }
    
    func testIntent() async throws {
        let result = try await intentDefinition.makeIntent(word: testWord).run()
        XCTAssertEqual(try result.value, testDefinition)
    }
    
    func testIntentCaseInsensitive() async throws {
        let result = try await intentDefinition.makeIntent(word: "AL DENTE").run()
        XCTAssertEqual(try result.value, testDefinition)
    }
    
    func testBlankWord() async throws {
        do {
            _ = try await intentDefinition.makeIntent(word: " ").run()
            XCTFail("Intent should've failed, but got success instead")
        } catch {
            // Can't get error inside needsValueError, but can check if the correct parameter failed
            XCTAssert(error.localizedDescription.contains("The App Intent requested value for parameter 'word'"))
        }
    }
    
    func testUnknownWord() async throws {
        do {
            _ = try await intentDefinition.makeIntent(word: "pizza").run()
            XCTFail("Intent should've failed, but got success instead")
        } catch let error as NSError {
            // The raw error prepends "LNPerformActionErrorCodeLocalizedStringResource:" before the actual error message
            XCTAssertEqual(error.underlyingErrors.first?.localizedDescription, "Error: No definition found for pizza")
        }
    }
    
    func testFindTermByWord() async throws {
        let terms = try await entityDefinition.entities(matching: testWord)
        // Only the id field is exposed from entities by default, but exposing other fields will interfere with decoding JSON responses
        // So just test if at least one result is found
        XCTAssertFalse(terms.isEmpty)
    }
    
    func testFindTermByWordCaseInsensitive() async throws {
        let terms = try await entityDefinition.entities(matching: "Al Dente")
        XCTAssertFalse(terms.isEmpty)
    }
    
    func testTermAppearsInSpotlight() async throws {
        let spotlightResults = try await entityDefinition.spotlightQuery(testWord)
        XCTAssertFalse(spotlightResults.isEmpty)
    }
    
    func testTermNotInSpotlight() async throws {
        let spotlightResults = try await entityDefinition.spotlightQuery("asdfjkl;")
        XCTAssert(spotlightResults.isEmpty)
    }
    
    func testAllTermsIndexed() async throws {
        let allTerms = try await entityDefinition.spotlightQuery()
        XCTAssertFalse(allTerms.isEmpty)
    }
}

#endif // canImport(AppIntentsTesting)
