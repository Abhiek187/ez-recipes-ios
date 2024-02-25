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
        
        // If the sidebar button exists, check that the select recipe text is shown and tapping the sidebar button opens the home view
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
        
        // After tapping the find recipe button, the button should be disabled
        findRecipeButton.tap()
        XCTAssertFalse(findRecipeButton.isEnabled, "Error line \(#line): The find recipe button should be disabled")
        
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
        let shareButton = recipeNavigationBar.buttons["Share this recipe"]
        XCTAssert(shareButton.isHittable, "Error line \(#line): The share button isn't clickable")
        
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
    
    func testSearchRecipes() throws {
        // Go to the Search tab
        app.tabBars["Tab Bar"].buttons["Search"].tap()
        var shotNum = 1
        snapshot("search-view-\(shotNum)")
        shotNum += 1
        
        // If the sidebar button exists, check that the search recipes text is shown and tapping the sidebar button opens the filter form
        let sidebarButton = app.navigationBars.buttons["ToggleSidebar"]
        
        if sidebarButton.exists {
            let searchRecipes = app.staticTexts["Search for recipes by applying filters from the navigation menu."]
            XCTAssert(searchRecipes.exists, "Error line \(#line): The secondary view text isn't showing")
            
            sidebarButton.tap()
            snapshot("search-view-\(shotNum)")
            shotNum += 1
        }
        
        // Interact with all the filter options
        let collectionViewsQuery = app.collectionViews
        let foodTextField = collectionViewsQuery.textFields["food"]
        foodTextField.tap()
        foodTextField.typeText("pasta")
        
        // Navigate using the toolbar above the keyboard
        let toolbar = app.toolbars["Toolbar"]
        let previousButton = toolbar.buttons["Previous"]
        let nextButton = toolbar.buttons["Next"]
        let doneButton = toolbar.buttons["Done"]
        XCTAssertFalse(previousButton.isEnabled, "Error line \(#line): The previous button isn't disabled")
        XCTAssert(nextButton.isEnabled, "Error line \(#line): The next button isn't enabled")
        
        let minCaloriesTextField = collectionViewsQuery.textFields["0"]
        minCaloriesTextField.tap()
        let calories = collectionViewsQuery.staticTexts["kcal"]
        XCTAssert(calories.exists, "Error line \(#line): No calories label was found")
        minCaloriesTextField.typeText("500")
        XCTAssert(previousButton.isEnabled, "Error line \(#line): The previous button isn't enabled")
        XCTAssert(nextButton.isEnabled, "Error line \(#line): The next button isn't enabled")
        
        let maxCaloriesTextField = collectionViewsQuery.textFields["2000"]
        maxCaloriesTextField.tap()
        maxCaloriesTextField.typeText("80")
        XCTAssert(previousButton.isEnabled, "Error line \(#line): The previous button isn't enabled")
        XCTAssertFalse(nextButton.isEnabled, "Error line \(#line): The next button isn't disabled")
        doneButton.tap()
        
        let calorieRangeError = collectionViewsQuery.staticTexts["Error: Max calories cannot exceed min calories"]
        XCTAssert(calorieRangeError.exists, "Error line \(#line): The calorie range error isn't shown")
        let submitButton = collectionViewsQuery.buttons["Apply"]
        XCTAssertFalse(submitButton.isEnabled, "Error line \(#line): The submit button should be disabled")
        
        maxCaloriesTextField.tap()
        maxCaloriesTextField.typeText("00")
        let maxCaloriesError = collectionViewsQuery.staticTexts["Error: Calories must be ≤ 2000"]
        XCTAssert(maxCaloriesError.exists, "Error line \(#line): The max calorie error isn't shown")
        XCTAssertFalse(submitButton.isEnabled, "Error line \(#line): The submit button should be disabled")
        
        maxCaloriesTextField.typeText(XCUIKeyboardKey.delete.rawValue)
        doneButton.tap()
        XCTAssertFalse(calorieRangeError.exists, "Error line \(#line): The calorie range error is still visible")
        XCTAssertFalse(maxCaloriesError.exists, "Error line \(#line): The max calorie error is still visible")
        XCTAssert(submitButton.isEnabled, "Error line \(#line): The submit button should be enabled")
        
        let vegetarianText = collectionViewsQuery.staticTexts["Vegetarian"]
        XCTAssert(vegetarianText.exists, "Error line \(#line): The vegetarian switch couldn't be found")
        let vegetarianSwitch = collectionViewsQuery.switches["Vegetarian"].switches.firstMatch
        vegetarianSwitch.tap()
        
        let veganText = collectionViewsQuery.staticTexts["Vegan"]
        XCTAssert(veganText.exists, "Error line \(#line): The vegan switch couldn't be found")
        let veganSwitch = collectionViewsQuery.switches["Vegan"].switches.firstMatch
        veganSwitch.tap()
        veganSwitch.tap()
        
        let glutenFreeText = collectionViewsQuery.staticTexts["Gluten-Free"]
        XCTAssert(glutenFreeText.exists, "Error line \(#line): The gluten-free switch couldn't be found")
        let glutenFreeSwitch = collectionViewsQuery.switches["Gluten-Free"].switches.firstMatch
        glutenFreeSwitch.tap()
        
        let healthyText = collectionViewsQuery.staticTexts["Healthy"]
        XCTAssert(healthyText.exists, "Error line \(#line): The healthy switch couldn't be found")
        let healthySwitch = collectionViewsQuery.switches["Healthy"].switches.firstMatch
        healthySwitch.tap()
        healthySwitch.tap()
        
        let cheapText = collectionViewsQuery.staticTexts["Cheap"]
        XCTAssert(cheapText.exists, "Error line \(#line): The cheap switch couldn't be found")
        let cheapSwitch = collectionViewsQuery.switches["Cheap"].switches.firstMatch
        cheapSwitch.tap()
        cheapSwitch.tap()
        
        let sustainableText = collectionViewsQuery.staticTexts["Sustainable"]
        XCTAssert(sustainableText.exists, "Error line \(#line): The sustainable switch couldn't be found")
        let sustainableSwitch = collectionViewsQuery.switches["Sustainable"].switches.firstMatch
        sustainableSwitch.tap()
        sustainableSwitch.tap()
        
        let spiceLevelText = collectionViewsQuery.staticTexts["Spice Level"]
        XCTAssert(spiceLevelText.exists, "Error line \(#line): The spice level picker couldn't be found")
        let spiceLevelButton = collectionViewsQuery.buttons["Spice Level"]
        spiceLevelButton.tap()
        let noneButton = collectionViewsQuery.buttons["none"]
        // Tap twice on iPads to dismiss the sidebar
        if !noneButton.isHittable {
            noneButton.tap()
        }
        noneButton.tap()
        let mildButton = collectionViewsQuery.buttons["mild"]
        mildButton.tap()
        let spicyButton = collectionViewsQuery.buttons["spicy"]
        spicyButton.tap()
        spicyButton.tap()
        let backSearchButton = app.navigationBars.buttons["Search"]
        
        if backSearchButton.exists {
            backSearchButton.tap()
        } else if sidebarButton.exists {
            sidebarButton.tap()
        }
        
        let mealTypeText = collectionViewsQuery.staticTexts["Meal Type"]
        XCTAssert(mealTypeText.exists, "Error line \(#line): The meal type picker couldn't be found")
        let mealTypeButton = collectionViewsQuery.buttons["Meal Type"]
        mealTypeButton.tap()
        let dinnerButton = collectionViewsQuery.buttons["dinner"]
        if !dinnerButton.isHittable {
            dinnerButton.tap()
        }
        dinnerButton.tap()
        let lunchButton = collectionViewsQuery.buttons["lunch"]
        lunchButton.tap()
        let mainCourseButton = collectionViewsQuery.buttons["main course"]
        mainCourseButton.tap()
        let mainDishButton = collectionViewsQuery.buttons["main dish"]
        mainDishButton.tap()
        
        if backSearchButton.exists {
            backSearchButton.tap()
        } else if sidebarButton.exists {
            sidebarButton.tap()
        }
        
        let cuisineText = collectionViewsQuery.staticTexts["Cuisine"]
        XCTAssert(cuisineText.exists, "Error line \(#line): The cuisine picker couldn't be found")
        let cuisineButton = collectionViewsQuery.buttons["Cuisine"]
        cuisineButton.tap()
        let italianButton = collectionViewsQuery.buttons["Italian"]
        if !italianButton.isHittable {
            italianButton.tap()
        }
        italianButton.tap()
        
        if backSearchButton.exists {
            backSearchButton.tap()
        } else if sidebarButton.exists {
            sidebarButton.tap()
        }
        
        let cuisines = collectionViewsQuery.staticTexts["Italian"]
        XCTAssert(cuisines.exists, "Error line \(#line): The cuisines selected aren't shown")
        snapshot("search-view-\(shotNum)")
        shotNum += 1
        
        // Submit the form and wait for results
        submitButton.tap()
        XCTAssertFalse(submitButton.isEnabled, "Error line \(#line): The submit button should be disabled")
        let resultsNavigationBar = app.navigationBars["Results"]
        XCTAssert(resultsNavigationBar.waitForExistence(timeout: 30), "Error line \(#line): The recipe results didn't load (the API request timed out after 30 seconds)")
        snapshot("search-view-\(shotNum)")
        shotNum += 1
    }
}
