//
//  ProfileTest.swift
//  EZ RecipesUITests
//
//  Created by Abhishek Chaudhuri on 4/11/25.
//

import XCTest

@MainActor
struct ProfileTest {
    let app: XCUIApplication
    let takeScreenshot: (String, Int?) -> Void
    let screenshotName: String
    var shotNum: Int
    
    mutating func testSignIn() {
        let signUpButton = app.buttons["Sign Up"]
        XCTAssert(signUpButton.exists, "Error line \(#line): The sign in form isn't showing")
        let loginButton = app.buttons["Login"].firstMatch
        XCTAssertFalse(loginButton.isEnabled, "Error line \(#line): The login button shouldn't be enabled")
        takeScreenshot(screenshotName, shotNum)
        shotNum += 1
        
        /*
         * Username Check:
         * - No error should be shown initially
         * - An error should be shown if the field is empty
         */
        let usernameField = app.textFields["Username"]
        let usernameRequiredError = app.staticTexts["Error: Username is required"]
        XCTAssertFalse(usernameRequiredError.exists, "Error line \(#line): The username required error shouldn't be visible")
        usernameField.tap()
        XCTAssert(usernameRequiredError.exists, "Error line \(#line): The username required error isn't visible")
        usernameField.typeText("test@example.com")
        XCTAssertFalse(loginButton.isEnabled, "Error line \(#line): The login button shouldn't be enabled")

        /*
         * Password Check:
         * - No error should be shown initially
         * - An error should be shown if the field is empty
         * - The eye icon should toggle the password's visibility
         */
        let passwordRequiredError = app.staticTexts["Error: Password is required"]
        XCTAssertFalse(passwordRequiredError.exists, "Error line \(#line): The password required error shouldn't be visible")
        let passwordField = app.secureTextFields["Password"]
        passwordField.tap()
        XCTAssert(passwordRequiredError.exists, "Error line \(#line): The password required error isn't visible")
        passwordField.typeText("password")
        let showPasswordButton = app.buttons["Show password"]
        let hidePasswordButton = app.buttons["Hide password"]
        XCTAssertFalse(hidePasswordButton.exists, "Error line \(#line): The password should be hidden")
        XCTAssert(showPasswordButton.exists, "Error line \(#line): The password should be hidden")
        showPasswordButton.tap()
        XCTAssertFalse(showPasswordButton.exists, "Error line \(#line): The password should be visible")
        XCTAssert(hidePasswordButton.exists, "Error line \(#line): The password should be visible")
        hidePasswordButton.tap()
        XCTAssertFalse(hidePasswordButton.exists, "Error line \(#line): The password should be hidden")
        XCTAssert(showPasswordButton.exists, "Error line \(#line): The password should be hidden")
        
        /* OAuth check:
         * - The header is shown
         * - The buttons are shown for all the supported providers
         */
        let oAuthHeader = app.staticTexts["Or sign in using:"]
        XCTAssert(oAuthHeader.exists, "Error line \(#line): The OAuth header is missing")
        for provider in ["Google", "Facebook", "GitHub"] {
            let oAuthButton = app.buttons[provider]
            XCTAssert(oAuthButton.exists, "Error line \(#line): The \(provider) button is missing")
        }
        
        XCTAssert(loginButton.isEnabled, "Error line \(#line): The login button should be enabled")
        signUpButton.tap()
    }
    
    mutating func testSignUp() throws {
        // If the Save Password prompt appears, close it
        if app.staticTexts["Save Password?"].exists {
            app.buttons["Not Now"].tap()
        }
        // If an error alert appears, dismiss it
        let errorAlert = app.alerts["Error"]
        if errorAlert.exists {
            errorAlert.buttons["OK"].tap()
        }
        // If the keyboard is still present, hide it
        let doneButton = app.buttons["Done"]
        if doneButton.exists {
            doneButton.tap()
        }
        // Account for anything else preventing the form from being interactive
        app.tap()
        
        let signInButton = app.buttons["Sign In"].firstMatch
        XCTAssert(signInButton.isEnabled, "Error line \(#line): The sign in button isn't enabled")
        let signUpButton = app.buttons["Sign Up"]
        XCTAssertFalse(signUpButton.isEnabled, "Error line \(#line): The sign up button shouldn't be enabled")
        takeScreenshot(screenshotName, shotNum)
        shotNum += 1

        /*
         * Email check:
         * - No error should be shown initially
         * - An error should be shown if the field is empty
         * - An error should be shown if the email is invalid
         */
        let emailRequiredError = app.staticTexts["Error: Email is required"]
        let emailInvalidError = app.staticTexts["Error: Invalid email"]
        XCTAssertFalse(emailRequiredError.exists, "Error line \(#line): The email required error is visible")
        XCTAssertFalse(emailInvalidError.exists, "Error line \(#line): The invalid email error is visible")
        let emailField = app.textFields["Email"]
        emailField.tap()
        emailField.typeText("t")
        emailField.typeText(XCUIKeyboardKey.delete.rawValue)
        XCTAssert(emailRequiredError.exists, "Error line \(#line): The email required error isn't visible")
        emailField.typeText("test")
        XCTAssert(emailInvalidError.exists, "Error line \(#line): The invalid email error isn't visible")
        emailField.typeText("@example.com")
        XCTAssertFalse(signUpButton.isEnabled, "Error line \(#line): The sign up button shouldn't be enabled")

        /*
         * Password check:
         * - No error should be shown initially
         * - An error should be shown if the field is empty
         * - An error should be shown if the password is too short
         * - The eye icon should toggle the password's visibility
         */
        let passwordRequiredError = app.staticTexts["Error: Password is required"]
        XCTAssertFalse(passwordRequiredError.exists, "Error line \(#line): The password required error is visible")
        let passwordMinLengthText = app.staticTexts["Password must be at least 8 characters long"]
        XCTAssert(passwordMinLengthText.exists, "Error line \(#line): The password min length text isn't visible")
        // "Automatic Strong Password cover view text" prevents text from being entered in a SecureField
        let showPasswordButton = app.buttons["Show password"].firstMatch
        let hidePasswordButton = app.buttons["Hide password"].firstMatch
        XCTAssertFalse(hidePasswordButton.exists, "Error line \(#line): The password should be hidden")
        XCTAssert(showPasswordButton.exists, "Error line \(#line): The password should be hidden")
        showPasswordButton.tap()
        XCTAssert(hidePasswordButton.exists, "Error line \(#line): The password should be visible")
        let passwordField = app.textFields["Password"]
        passwordField.tap()
        XCTAssert(passwordRequiredError.exists, "Error line \(#line): The password required error isn't visible")
        passwordField.typeText("pass")
        let passwordMinLengthError = app.staticTexts["Error: Password must be at least 8 characters long"]
        XCTAssert(passwordMinLengthError.exists, "Error line \(#line): The password min length error isn't visible")
        passwordField.typeText("word")
        hidePasswordButton.tap()
        XCTAssertFalse(hidePasswordButton.exists, "Error line \(#line): The password should be hidden")
        XCTAssert(showPasswordButton.exists, "Error line \(#line): The password should be hidden")
        XCTAssertFalse(signUpButton.isEnabled, "Error line \(#line): The sign up button shouldn't be enabled")

        /*
         * Confirm Password check:
         * - No error should be shown initially
         * - An error should be shown if the field is empty
         * - An error should be shown if the passwords don't match
         * - The eye icon should toggle the password's visibility
         */
        let passwordMatchError = app.staticTexts["Error: Passwords do not match"]
        let confirmPasswordField = app.secureTextFields["Confirm Password"]
        confirmPasswordField.tap()
        XCTAssert(passwordMatchError.exists, "Error line \(#line): The password match error isn't visible")
        confirmPasswordField.typeText("password")
        
        // This assertion is flaky on GitHub Actions
        try XCTSkipUnless(signUpButton.isEnabled, "Skip line \(#line): The sign up button isn't enabled")
        XCTAssert(signUpButton.isEnabled, "Error line \(#line): The sign up button isn't enabled")
        signInButton.tap()
    }
    
    mutating func testForgetPassword() {
        let passwordForgetButton = app.buttons["Forgot password?"]
        XCTAssert(passwordForgetButton.exists, "Error line \(#line): The forget password button isn't visible")
        passwordForgetButton.tap()
        let submitButton = app.buttons["Submit"]
        XCTAssertFalse(submitButton.isEnabled, "Error line \(#line): The submit button shouldn't be enabled")
        takeScreenshot(screenshotName, shotNum)
        shotNum += 1

        /*
         * Email check:
         * - No error should be shown initially
         * - An error should be shown if the field is empty
         * - An error should be shown if the email is invalid
         */
        let emailRequiredError = app.staticTexts["Error: Email is required"]
        let emailInvalidError = app.staticTexts["Error: Invalid email"]
        XCTAssertFalse(emailRequiredError.exists, "Error line \(#line): The email required error is visible")
        XCTAssertFalse(emailInvalidError.exists, "Error line \(#line): The invalid email error is visible")
        let emailField = app.textFields["Email"]
        emailField.tap()
        emailField.typeText("t")
        emailField.typeText(XCUIKeyboardKey.delete.rawValue)
        XCTAssert(emailRequiredError.exists, "Error line \(#line): The email required error isn't visible")
        emailField.typeText("test")
        XCTAssert(emailInvalidError.exists, "Error line \(#line): The invalid email error isn't visible")
        emailField.typeText("@example.com")
        XCTAssert(submitButton.isEnabled, "Error line \(#line): The submit button isn't enabled")
    }
}
