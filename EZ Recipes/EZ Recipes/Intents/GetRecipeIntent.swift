//
//  GetRecipeIntent.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 8/26/26.
//

import AppIntents
import OSLog

// Use .system.open in iOS 27+
//@AppIntent(schema: .system.open)
struct GetRecipeIntent: OpenIntent, URLRepresentableIntent {
    static let title: LocalizedStringResource = "Open Recipe"
    static let description = IntentDescription("View a recipe by its ID")
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? Constants.appName, category: "GetRecipeIntent")
    
    @Parameter(title: "Recipe")
    var target: RecipePreview
    
    static var parameterSummary: some ParameterSummary {
        Summary("Open recipe: \(\.$target)")
    }
}
