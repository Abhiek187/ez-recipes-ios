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
        // Take screenshots along the way
        var shotNum = 1
        snapshot("home-view-\(shotNum)")
        shotNum += 1
        
        // If the sidebar button exists, check that the select recipe text is showing and tapping the sidebar button opens the home view
        let sidebarButton = app.navigationBars.buttons["ToggleSidebar"]
        
        if sidebarButton.exists {
            let selectRecipe = app.staticTexts["Select a recipe from the navigation menu."]
            XCTAssert(selectRecipe.exists, "Error line \(#line): The secondary view text isn't showing")
            
            sidebarButton.tap()
            snapshot("home-view-\(shotNum)")
            shotNum += 1
        }
        
        // Check that the navigation title is Home
        let homeNavigationBar = app.navigationBars["Home"] // UI tests can't import modules from the app target
        XCTAssert(homeNavigationBar.exists, "Error line \(#line): The home navigation bar couldn't be found")
        
        // When first launching the app, the find recipe button should be clickable and the ProgressView should be hidden
        let findRecipeButton = app.buttons["Find Me a Recipe!"]
        let progressView = app.activityIndicators.firstMatch
        XCTAssert(findRecipeButton.isEnabled, "Error line \(#line): The find recipe button isn't enabled")
        XCTAssertFalse(progressView.isHittable, "Error line \(#line): The ProgressView is visible")
        
        // After tapping the find recipe button, the button should be disabled and the ProgressView should be visible
        findRecipeButton.tap()
        XCTAssertFalse(findRecipeButton.isEnabled, "Error line \(#line): The find recipe button should be disabled")
        XCTAssert(progressView.isHittable, "Error line \(#line): The ProgressView isn't visible")
        
        // Wait up to 30 seconds for the recipe to load
        let recipeNavigationBar = app.navigationBars["Recipe"]
        XCTAssert(recipeNavigationBar.waitForExistence(timeout: 30), "Error line \(#line): The recipe page didn't load (the API request timed out after 30 seconds)")
        shotNum = 1
        snapshot("recipe-view-\(shotNum)")
        shotNum += 1
        
        // Check that the favorite button toggles between filling and un-filling when tapped
        let favoriteButton = recipeNavigationBar.buttons["Favorite this recipe"]
        let unFavoriteButton = recipeNavigationBar.buttons["Un-favorite this recipe"]
        XCTAssert(favoriteButton.exists, "Error line \(#line): The favorite button couldn't be found")
        XCTAssertFalse(unFavoriteButton.exists, "Error line \(#line): The favorite button shouldn't be filled")
        
        favoriteButton.tap()
        XCTAssertFalse(favoriteButton.exists, "Error line \(#line): The favorite button should be filled")
        XCTAssert(unFavoriteButton.exists, "Error line \(#line): The un-favorite button couldn't be found")
        
        unFavoriteButton.tap()
        XCTAssert(favoriteButton.exists, "Error line \(#line): The favorite button couldn't be found")
        XCTAssertFalse(unFavoriteButton.exists, "Error line \(#line): The favorite button shouldn't be filled")
        
        // Check that the share button is clickable (won't check the share sheet since it needs to be dismissed and requires waiting for the animation)
        let shareButton = recipeNavigationBar.buttons["Share"]
        XCTAssert(shareButton.isEnabled, "Error line \(#line): The share button isn't clickable")
        
        // Since the recipe loaded will be random, check all the elements that are guaranteed to be there for all recipes
        // Check that the two recipe buttons are clickable and the ProgressView is hidden
        let madeButton = app.buttons["I Made This!"]
        XCTAssert(madeButton.isEnabled, "Error line \(#line): The made button isn't clickable")
        let showAnotherRecipeButton = app.buttons["Show Me Another Recipe!"]
        XCTAssert(showAnotherRecipeButton.isEnabled, "Error line \(#line): The show button isn't clickable")
        XCTAssertFalse(progressView.isHittable, "Error line \(#line): The ProgressView should be hidden")
        
        // Scroll down and take screenshots of the recipe view
        let scrollView = app.scrollViews.firstMatch
        scrollView.swipeUp() // swipe up will scroll the whole screen
        snapshot("recipe-view-\(shotNum)")
        shotNum += 1
        
        // Check that the nutrition label contains all the required nutritional properties
        for label in ["Nutrition Facts", "Calories", "Fat", "Saturated Fat", "Carbohydrates", "Fiber", "Sugar", "Protein", "Cholesterol", "Sodium"] {
            let nutritionText = app.staticTexts[label]
            XCTAssert(nutritionText.exists, "Error line \(#line): \(label) is missing from the nutrition label")
        }
        
        scrollView.swipeUp()
        snapshot("recipe-view-\(shotNum)")
        shotNum += 1
        
        // Check that the summary box, ingredients list, instructions list, and footer are present
        let summary = app.staticTexts["Summary"]
        XCTAssert(summary.exists, "Error line \(#line): The summary box is missing")
        scrollView.swipeUp()
        snapshot("recipe-view-\(shotNum)")
        shotNum += 1
        
        let ingredients = app.staticTexts["Ingredients"]
        XCTAssert(ingredients.exists, "Error line \(#line): The ingredients list is missing")
        scrollView.swipeUp()
        snapshot("recipe-view-\(shotNum)")
        shotNum += 1
        
        let steps = app.staticTexts["Steps"]
        XCTAssert(steps.exists, "Error line \(#line): The instructions list is missing")
        scrollView.swipeUp()
        snapshot("recipe-view-\(shotNum)")
        shotNum += 1
        
        let attribution = app.staticTexts["Powered by spoonacular"]
        XCTAssert(attribution.exists, "Error line \(#line): The attribution is missing")
        
        // Check that tapping the show another recipe button disables the button (the ProgressView check doesn't work in the pipeline)
        showAnotherRecipeButton.tap()
        XCTAssertFalse(showAnotherRecipeButton.isEnabled, "Error line \(#line): The show button should be disabled")
    }
}
