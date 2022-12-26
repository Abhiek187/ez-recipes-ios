//
//  EZ_RecipesUITests.swift
//  EZ RecipesUITests
//
//  Created by Abhishek Chaudhuri on 10/22/22.
//

import XCTest

class EZ_RecipesUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFindMeARecipe() throws {
        // Tap the "Find Me A Recipe!" button and check that the recipe page loads properly (this will consume quota)
        //snapshot("01LoginScreen")
        // Check that the navigation title is Home
        let homeNavigationBar = app.navigationBars["Home"] // UI tests can't import modules from the app target
        XCTAssert(homeNavigationBar.exists)
        
        // When first launching the app, the find recipe button should be clickable and the ProgressView should be hidden
        let findRecipeButton = app.buttons["Find Me a Recipe!"]
        let progressView = app.activityIndicators.firstMatch
        XCTAssert(findRecipeButton.isEnabled)
        XCTAssertFalse(progressView.isHittable)
        
        // After tapping the find recipe button, the button should be disabled and the ProgressView should be visible
        findRecipeButton.tap()
        XCTAssertFalse(findRecipeButton.isEnabled)
        XCTAssert(progressView.isHittable)
        
        // Wait up to 30 seconds for the recipe to load
        let recipeNavigationBar = app.navigationBars["Recipe"]
        XCTAssert(recipeNavigationBar.waitForExistence(timeout: 30))
        
        // Check that the favorite button toggles between filling and un-filling when tapped
        let favoriteButton = recipeNavigationBar.buttons["Favorite this recipe"]
        let unFavoriteButton = recipeNavigationBar.buttons["Un-favorite this recipe"]
        XCTAssert(favoriteButton.exists)
        XCTAssertFalse(unFavoriteButton.exists)
        
        favoriteButton.tap()
        XCTAssertFalse(favoriteButton.exists)
        XCTAssert(unFavoriteButton.exists)
        
        unFavoriteButton.tap()
        XCTAssert(favoriteButton.exists)
        XCTAssertFalse(unFavoriteButton.exists)
        
        // Check that the share button is clickable (won't check the share sheet since it needs to be dismissed and requires waiting for the animation)
        let shareButton = recipeNavigationBar.buttons["Share"]
        XCTAssert(shareButton.isHittable)
        
        // Since the recipe loaded will be random, check all the elements that are guaranteed to be there for all recipes
        // Check that the two recipe buttons are clickable and the ProgressView is hidden
        let madeButton = app.buttons["I Made This!"]
        XCTAssert(madeButton.isEnabled)
        let showAnotherRecipeButton = app.buttons["Show Me Another Recipe!"]
        XCTAssert(showAnotherRecipeButton.isEnabled)
        XCTAssertFalse(progressView.isHittable)
        
        // Check that the nutrition label contains all the required nutritional properties
        for label in ["Nutrition Facts", "Calories", "Fat", "Saturated Fat", "Carbohydrates", "Fiber", "Sugar", "Protein", "Cholesterol", "Sodium"] {
            let nutritionText = app.staticTexts[label]
            XCTAssert(nutritionText.exists)
        }
        
        // Check that the summary box, ingredients list, instructions list, and footer are present
        let summary = app.staticTexts["Summary"]
        XCTAssert(summary.exists)
        let ingredients = app.staticTexts["Ingredients"]
        XCTAssert(ingredients.exists)
        let steps = app.staticTexts["Steps"]
        XCTAssert(steps.exists)
        let attribution = app.staticTexts["Powered by spoonacular"]
        XCTAssert(attribution.exists)
        
        // Check that tapping the show another recipe button disables the button and shows a ProgressView
        showAnotherRecipeButton.tap()
        XCTAssertFalse(showAnotherRecipeButton.isEnabled)
        XCTAssert(progressView.exists)
    }
}
