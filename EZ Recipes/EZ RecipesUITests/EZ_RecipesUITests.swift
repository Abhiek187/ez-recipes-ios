//
//  EZ_RecipesUITests.swift
//  EZ RecipesUITests
//
//  Created by Abhishek Chaudhuri on 10/22/22.
//

import XCTest

@MainActor
class EZ_RecipesUITests: XCTestCase {
    private var app: XCUIApplication!
    private let isLocal = ProcessInfo.processInfo.environment["CI"] != "true"

    // Snapshot methods must be called on the main thread, but XCTestCase doesn't require isolation
    override func setUp() async throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        app = XCUIApplication()
        app.launchArguments.append("isUITest")
        if isLocal {
            // Screenshots can time out on GitHub Actions
            setupSnapshot(app)
        }
        app.launch()
    }

    override func tearDown() async throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
    
    private func takeScreenshot(withName name: String, shotNum: Int? = nil) {
        if isLocal {
            var screenshotName = name
            if let shotNum {
                screenshotName += "-\(shotNum)"
            }
            snapshot(screenshotName)
        }
    }

    func testFindMeARecipe() throws {
        // Tap the "Find Me A Recipe!" button and check that the recipe page loads properly (this will consume quota)
        // Take screenshots along the way
        var screenshotName = "home-view"
        var shotNum = 1
        takeScreenshot(withName: screenshotName, shotNum: shotNum)
        shotNum += 1
        
        // Check that the navigation title is Home
        let homeNavigationBar = app.navigationBars["Home"] // UI tests can't import modules from the app target
        XCTAssert(homeNavigationBar.exists, "Error line \(#line): The home navigation bar couldn't be found")
        
        // The accordions should be present, but not display any recipes
        let favoriteAccordion = app.buttons["💖 Favorites"]
        let recentAccordion = app.buttons["⌚ Recently Viewed"]
        let ratingAccordion = app.buttons["⭐ Ratings"]
        let signInMessage = app.staticTexts["Sign in to view your saved recipes"]
        
        // This assertion is flaky on GitHub Actions
        try XCTSkipUnless(favoriteAccordion.exists, "Skip line \(#line): The Favorites accordion isn't showing")
        XCTAssert(favoriteAccordion.exists, "Error line \(#line): The Favorites accordion isn't showing")
        XCTAssert(recentAccordion.exists, "Error line \(#line): The Recently Viewed accordion isn't showing")
        XCTAssert(ratingAccordion.exists, "Error line \(#line): The Ratings accordion isn't showing")
        XCTAssert(!signInMessage.exists, "Error line \(#line): The accordions shouldn't be expanded")

        favoriteAccordion.tap()
        XCTAssert(signInMessage.exists, "Error line \(#line): The sign in message isn't showing under favorites")
        favoriteAccordion.tap()
        recentAccordion.tap()
        XCTAssert(!signInMessage.exists, "Error line \(#line): The sign in message shouldn't appear under recents")
        recentAccordion.tap()
        ratingAccordion.tap()
        XCTAssert(signInMessage.exists, "Error line \(#line): The sign in message isn't showing under ratings")
        ratingAccordion.tap()
        
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
        
        // Hide the sidebar so the recipe can be interacted with
        let popoverDismissRegion = app.otherElements["PopoverDismissRegion"]
        if popoverDismissRegion.exists {
            popoverDismissRegion.tap()
        }
        screenshotName = "recipe-view"
        shotNum = 1
        takeScreenshot(withName: screenshotName, shotNum: shotNum)
        shotNum += 1
        
        // Check that the favorite button toggles between filling and un-filling when tapped
        let favoriteButton = recipeNavigationBar.buttons["Favorite this recipe"]
        let unFavoriteButton = recipeNavigationBar.buttons["Un-favorite this recipe"]
        XCTAssert(favoriteButton.exists, "Error line \(#line): The favorite button couldn't be found")
        XCTAssertFalse(unFavoriteButton.exists, "Error line \(#line): The favorite button shouldn't be filled")
        
        // Check that the share button is clickable (won't check the share sheet since it needs to be dismissed and requires waiting for the animation)
        let shareButton = recipeNavigationBar.buttons["Share this recipe"]
        XCTAssert(shareButton.isHittable, "Error line \(#line): The share button isn't clickable")
        
        // Since the recipe loaded will be random, check all the elements that are guaranteed to be there for all recipes
        // Check that the recipe button is clickable and the ProgressView is hidden
        let showAnotherRecipeButton = app.buttons["Show Me Another Recipe!"]
        XCTAssert(showAnotherRecipeButton.isEnabled, "Error line \(#line): The show button isn't clickable")
        XCTAssertFalse(progressView.isHittable, "Error line \(#line): The ProgressView should be hidden")
        
        // Scroll down and take screenshots of the recipe view
        let scrollView = app.scrollViews.firstMatch
        scrollView.swipeUp() // swipe up will scroll the whole screen
        takeScreenshot(withName: screenshotName, shotNum: shotNum)
        shotNum += 1
        
        // Check that the nutrition label contains all the required nutritional properties (except fiber)
        for label in ["Nutrition Facts", "Calories", "Fat", "Saturated Fat", "Carbohydrates", "Sugar", "Protein", "Cholesterol", "Sodium"] {
            let nutritionText = app.staticTexts[label]
            XCTAssert(nutritionText.exists, "Error line \(#line): \(label) is missing from the nutrition label")
        }
        
        scrollView.swipeUp()
        takeScreenshot(withName: screenshotName, shotNum: shotNum)
        shotNum += 1
        
        // Check that the summary box, ingredients list, instructions list, and footer are present
        let summary = app.staticTexts["Summary"]
        XCTAssert(summary.exists, "Error line \(#line): The summary box is missing")
        scrollView.swipeUp()
        takeScreenshot(withName: screenshotName, shotNum: shotNum)
        shotNum += 1
        
        let ingredients = app.staticTexts["Ingredients"]
        XCTAssert(ingredients.exists, "Error line \(#line): The ingredients list is missing")
        scrollView.swipeUp()
        takeScreenshot(withName: screenshotName, shotNum: shotNum)
        shotNum += 1
        
        let steps = app.staticTexts["Steps"]
        XCTAssert(steps.exists, "Error line \(#line): The instructions list is missing")
        scrollView.swipeUp()
        takeScreenshot(withName: screenshotName, shotNum: shotNum)
        shotNum += 1
        
        let attribution = app.staticTexts["Powered by spoonacular"]
        XCTAssert(attribution.exists, "Error line \(#line): The attribution is missing")
        
        // Check that tapping the show another recipe button disables the button (the ProgressView check doesn't work in the pipeline)
        showAnotherRecipeButton.tap()
        XCTAssertFalse(showAnotherRecipeButton.isEnabled, "Error line \(#line): The show button should be disabled")
    }
    
    func testSearchRecipes() throws {
        // Go to the Search tab
        goTo(tab: "Search")
        let screenshotName = "search-view"
        var shotNum = 1
        takeScreenshot(withName: screenshotName, shotNum: shotNum)
        shotNum += 1
        
        // If the sidebar button exists, check that the search recipes text is shown and tapping the sidebar button opens the filter form
        // Known as ToggleSidebar before iOS 26 & Show Sidebar in iOS 26 (not to be confused with ToggleSideBar on the TabView 😵‍💫)
        let sidebarButton = if #available(iOS 26.0, *) {
            app.buttons["Show Sidebar"]
        } else {
            app.navigationBars.buttons["ToggleSidebar"]
        }
        
        if sidebarButton.exists {
            let searchRecipes = app.staticTexts["Search for recipes by applying filters from the navigation menu."]
            XCTAssert(searchRecipes.exists, "Error line \(#line): The secondary view text isn't showing")
            
            sidebarButton.tap()
            takeScreenshot(withName: screenshotName, shotNum: shotNum)
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
        
        // The keyboard settings button can get in the way of the done button on iPads
        let keyboardButton = app.buttons["Keyboard"] // aka: SystemInputAssistantView
        if !doneButton.isHittable && keyboardButton.exists {
            keyboardButton.tap()
            collectionViewsQuery.buttons["Show Keyboard"].tap()
        }
        doneButton.tap()
        
        let calorieRangeError = collectionViewsQuery.staticTexts["Error: Max calories cannot exceed min calories"]
        XCTAssert(calorieRangeError.exists, "Error line \(#line): The calorie range error isn't shown")
        let submitButton = collectionViewsQuery.buttons["Apply"]
        collectionViewsQuery.element.swipeUp()
        XCTAssertFalse(submitButton.isEnabled, "Error line \(#line): The submit button should be disabled")
        collectionViewsQuery.element.swipeDown()
        
        maxCaloriesTextField.tap()
        maxCaloriesTextField.typeText("00")
        doneButton.tap()
        let maxCaloriesError = collectionViewsQuery.staticTexts["Error: Calories must be ≤ 2000"]
        XCTAssert(maxCaloriesError.exists, "Error line \(#line): The max calorie error isn't shown")
        collectionViewsQuery.element.swipeUp()
        XCTAssertFalse(submitButton.isEnabled, "Error line \(#line): The submit button should be disabled")
        collectionViewsQuery.element.swipeDown()
        
        maxCaloriesTextField.tap()
        maxCaloriesTextField.typeText(XCUIKeyboardKey.delete.rawValue)
        doneButton.tap()
        XCTAssertFalse(calorieRangeError.exists, "Error line \(#line): The calorie range error is still visible")
        XCTAssertFalse(maxCaloriesError.exists, "Error line \(#line): The max calorie error is still visible")
        collectionViewsQuery.element.swipeUp()
        XCTAssert(submitButton.isEnabled, "Error line \(#line): The submit button should be enabled")
        collectionViewsQuery.element.swipeDown()
        
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
        
        var ratingPicker = collectionViewsQuery.staticTexts["Rating"]
        XCTAssert(ratingPicker.exists, "Error line \(#line): The rating picker couldn't be found")
        for option in (0...5).reversed() {
            ratingPicker.tap()
            let optionLabel = option == 0 ? "(none)" : String(option)
            let optionButton = collectionViewsQuery.buttons[optionLabel]
            optionButton.tap()
            ratingPicker = collectionViewsQuery.staticTexts[optionLabel]
        }
        
        let spiceLevelText = collectionViewsQuery.staticTexts["Spice Level"]
        XCTAssert(spiceLevelText.exists, "Error line \(#line): The spice level picker couldn't be found")
        let spiceLevelButton = collectionViewsQuery.buttons["Spice Level"]
        spiceLevelButton.tap()
        // Tap twice on iPads to dismiss the sidebar
        let popoverDismissRegion = app.otherElements["PopoverDismissRegion"]
        if popoverDismissRegion.exists {
            popoverDismissRegion.tap()
        }
        
        let noneButton = collectionViewsQuery.buttons["none"]
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
        if popoverDismissRegion.exists {
            popoverDismissRegion.tap()
        }
        dinnerButton.tap()
        collectionViewsQuery.element.swipeUp()
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
        if !italianButton.exists {
            collectionViewsQuery.element.swipeUp() // for small screens
        } else if popoverDismissRegion.exists {
            popoverDismissRegion.tap() // for large screens
        }
        italianButton.tap()
        
        if backSearchButton.exists {
            backSearchButton.tap()
        } else if sidebarButton.exists {
            sidebarButton.tap()
        }
        
        let cuisines = collectionViewsQuery.staticTexts["Italian"]
        XCTAssert(cuisines.exists, "Error line \(#line): The cuisines selected aren't shown")
        takeScreenshot(withName: screenshotName, shotNum: shotNum)
        shotNum += 1
        
        // Submit the form and wait for results
        submitButton.tap()
        let resultsNavigationBar = app.navigationBars["Results"]
        XCTAssert(resultsNavigationBar.waitForExistence(timeout: 30), "Error line \(#line): The recipe results didn't load (the API request timed out after 30 seconds)")
        
        if popoverDismissRegion.exists {
            popoverDismissRegion.tap()
        }
        takeScreenshot(withName: screenshotName, shotNum: shotNum)
        shotNum += 1
    }
    
    func testGlossaryScreen() throws {
        // Take a screenshot of the glossary tab (no assertions)
        goTo(tab: "Glossary")
        takeScreenshot(withName: "glossary-view")
    }
    
    func testProfileScreen() throws {
        goTo(tab: "Profile")
        
        // Wait until the profile loads (should be logged out)
        let profileLoading = app.staticTexts["Getting your profile ready… 🧑‍🍳"]
        XCTAssert(profileLoading.waitForNonExistence(timeout: 30), "Error line \(#line): The profile didn't load (the API request timed out after 30 seconds)")
        let screenshotName = "profile-view"
        var shotNum = 1
        takeScreenshot(withName: screenshotName, shotNum: shotNum)
        shotNum += 1
        
        let loginButton = app.buttons["Login"]
        loginButton.tap()
        
        // Check all the validations on the login, create account, & forget password form
        var profileTest = ProfileTest(app: app, takeScreenshot: takeScreenshot, screenshotName: screenshotName, shotNum: shotNum)
        profileTest.testSignIn()
        try profileTest.testSignUp()
        profileTest.testForgetPassword()
    }
}
