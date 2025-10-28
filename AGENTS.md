# Agent Instructions

## Project Overview

This is an iOS app that lets users learning to cook to search, view, and save a variety of recipes. The UI is built using SwiftUI and follows Apple's Human Interface Guidelines. It connects to a backend service called EZ Recipes Server that routes all API requests to the appropriate services. API calls are handled using Alamofire. The CI/CD pipeline is handled using Fastlane & GitHub Actions. The app isn't currently published on the App Store due to Apple's yearly developer fee, but it should be configured as if it can be deployed on the App Store at any point. For example, any features that require changes to plist files, privacy manifests, or entitlements must be included as long as they don't require an Apple Developer membership to build the app.

App versioning and management of certificates and provisioning profiles should be automated where possible. Use semantic versioning and update the build number with every attempt to create a signed build for an app version. App builds should be deployed to TestFlight to check for any prod-specific issues before being promoted to the App Store. Each release requires writing release notes under the Fastlane changelogs directory, named after the marketing version. The release notes shouldn't go into technical detail. Instead, they should give a high-level summary of changes made since the last release that can be understood by the average user.

Before writing any code, review the existing architecture and propose your implementation plan for approval by the user. If something is uncertain, always prefer asking for clarity over making any assumptions. If you're not sure how to implement a solution, it's ok to be honest and admit it to the user.

## Build and Test Commands

Before committing changes, make sure the following command succeeds:

```bash
# Test
bundle exec fastlane ios test
```

This command runs both unit tests and UI tests. While UI tests may be flaky, at a minimum, unit tests must succeed with each commit.

## Code Style Guidelines

This project should follow Apple's best practices for SwiftUI apps. Do not create any UI using Storyboards or UIKit, unless a feature isn't available in SwiftUI. The code should follow MVVM architecture, with a clear separation between the UI and business logic. All user-facing strings should be localized and included in string catalogs in case the app should support multiple languages. Make sure to account for different string variants, such as pluralization or device types.

The UI must be designed to be responsive on various screen sizes and accessible to all users. The UI should match what users expect for native iOS apps. Any changes should be compatible with the 2 most recent iOS versions for both iPhones and iPads. Small features that require the latest iOS or Swift version may be used with version checks. But don't introduce larger features that require the latest iOS version until it's at least 2 versions old (therefore meeting the deployment target requirements). Ensure the app is efficient on mobile devices, balancing performance with memory and power management. Avoid memory leaks or slow, unresponsive UI.

For every SwiftUI view, include previews that test the UI under different states. Additional views can be created to break up a large view or make certain sections more reusable. The app should support light/dark mode, portrait/landscape mode, and small/large font sizes. Ensure the keyboard is optimized for certain inputs, such as email addresses or numbers. The user must validate the styling on their end to make sure the app looks neat and presentable for the end user. Provide some guidance on things to check, such as color contrast or accessibility labels via VoiceOver. If you're able to analyze screenshots, you may suggest that the user share some screenshots of the app to provide feedback.

Follow the best practices for writing Swift code. No Objective-C code should be used unless something can't be coded in Swift. Avoid writing code that can risk the app crashing. Handle all potential crash scenarios gracefully so the app can continue running efficiently. Do not use ! to force unwrap optionals. Always prefer using ? or guard statements to check for nil values. Comments can be used to explain more complicated code, but shouldn't be overused if the code is self-explanatory. Make sure test logs and unused imports are removed prior to committing changes. Xcode warnings must be kept to a minimum. Commented or unused code should be removed unless the user intends to reference it in the future. Avoid using deprecated code, or replace any existing deprecations as long as the deployment target is respected. Always consider edge cases when implementing features. Above anything else, make sure the functionality is understandable to someone reading the code.

Data can be stored locally using User Defaults, SwiftData, or the Keychain. User Defaults should be used for simple key-value pairs, like settings. SwiftData should be used for more complex, relational data. Finally, the Keychain should be used to encrypt sensitive credentials, such as the JWT shared by the server.

Any other files created in this repo should be included in the Xcode project, but should not be added to a target if they don't contribute to the final app build (e.g., docs, Fastlane, GitHub Actions). Make sure the file paths specified in the Xcode project file are relative to the project. Don't use absolute paths that reference directories only present on a user's machine.

When you write commit messages, prepend them with 🤖 so it's clear the changes were made with AI. When you raise PRs, make sure to disclose the AI tool used. All changes must be made to a feature branch and then merged to main via a PR.

When working with the user, ensure you follow all guidelines for ethical AI, such as keeping the human in the loop, taking accountability for changes, and being transparent about the thought process and where you retrieve your ideas from.

## Testing Instructions

Helper methods should be unit tested where possible with reasonable coverage. Prefer using Swift Testing over XCTest for unit tests. Mock any external dependencies needed for unit tests.

Write UI tests for journeys that mimic how real users would use the app. Since these kinds of tests take longer and can be flaky, don't overrely on them. Take into account how certain inputs are labeled on iPhones vs. iPads and across different iOS versions. Utilize Fastlane's SnapshotHelper to take screenshots as the UI test is running. This will help when gathering screenshots for the App Store.

In addition to running the test command above, ensure the user tests the app running locally on various devices, both on the simulator and physical devices. Ideally, the user should test that the app works on iPhone and iPad.

## Security Considerations

This is a frontend app. Therefore, NO secrets should be managed in this repo since mobile apps can be reverse-engineered. Secrets should be delegated to EZ Recipes Server. If the user has to enter sensitive credentials, such as passwords, they should be masked, but provide an option to view what they're entering to ensure they're typing things properly. Consider also if a feature on the app requires the user to be authenticated first. If so, utilize the Keychain to manage the user's token.

While the server will validate all inputs, it's still good practice to validate inputs on the client side. This way, users can receive immediate feedback on their inputs before sending them to the server.

Use Apple's unified logging system for structured logs that should be saved on the user's device. All API requests and responses should be logged for auditing purposes, but sensitive information like passwords, cookies, or API keys should be masked in the logs. Important transactions can be logged as well, but don't make logs excessive when it comes time to search logs to troubleshoot bugs with the app. If an API errors out, make sure to provide a user-friendly message explaining what went wrong. Don't go into too much technical detail, especially if the error exposes information that would benefit malicious actors, such as if the username is correct, but the password is invalid.

Use Swift Package Manager to manage dependencies. In addition to Package Dependencies within Xcode's UI, utilize Package.swift found at the root of this repo. This helps ensure the pipeline can keep track of any outdated dependencies. The Package.resolved files are symlinked together to ensure the normal build process continues to work. All dependencies should be kept up-to-date to minimize any vulnerabilities. Any new packages added to this project should be regularly updated and not abandoned after several years or contain lingering vulnerabilities. If a feature can be implemented trivially without introducing another dependency, that's preferred.
