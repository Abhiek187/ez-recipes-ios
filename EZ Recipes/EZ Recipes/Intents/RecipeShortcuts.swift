//
//  RecipeShortcuts.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 9/3/26.
//

import AppIntents

// Displays all the intents in a dedicated gallery section in Shortcuts
struct RecipeShortcuts: AppShortcutsProvider {
    static let shortcutTileColor: ShortcutTileColor = .yellow
    
    static var appShortcuts: [AppShortcut] {
        AppShortcut(intent: SearchRecipeIntent(), phrases: [
            // Phrases don't need to match what someone would ask Siri, but should be semantically similar
            // Parameters can't be passed unless they're AppEntity's or AppEnum's
            "Search recipes in \(.applicationName)",
            "Search for recipes in \(.applicationName)"
        ], shortTitle: "Search Recipes", systemImageName: "magnifyingglass")
        
        AppShortcut(intent: GetRecipeIntent(), phrases: [
            "Open a recipe in \(.applicationName)",
            "View a recipe in \(.applicationName)"
        ], shortTitle: "Open Recipe", systemImageName: "fork.knife")
        
        AppShortcut(intent: GetRecipeDefinitionIntent(), phrases: [
            "Get a recipe definition in \(.applicationName)",
            "Get a cooking-related term in \(.applicationName)",
            "Explain what a word means in \(.applicationName)",
            "Explain what a cooking term means in \(.applicationName)",
            "What does this word mean in \(.applicationName)?"
        ], shortTitle: "Get Recipe Definition", systemImageName: "character.book.closed.fill")
    }
}
