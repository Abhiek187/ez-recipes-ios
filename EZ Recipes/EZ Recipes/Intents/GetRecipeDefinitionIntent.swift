//
//  GetRecipeDefinitionIntent.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 8/26/26.
//

import AppIntents
import OSLog

struct GetRecipeDefinitionIntent: AppIntent {
    // Title of the shortcut
    static let title: LocalizedStringResource = "Get Recipe Definition" // strings must be hardcoded, not dynamic
    // Shown underneath the title when viewing more information about a shortcut
    static let description = IntentDescription("Look up the definition of a cooking-related term", searchKeywords: ["Cooking", "Recipe", "Definition", "Lookup", "Term"])
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? Constants.appName, category: "GetRecipeDefinitionIntent")
    
    // Shown when viewing more information about a shortcut
    @Parameter(title: "Word", description: "The cooking-related term to look up")
    var word: String
    
    // Shown when invoking a shortcut by passing parameters
    // Parameters not inline are listed in an accordion
    static var parameterSummary: some ParameterSummary {
        Summary("Get the definition of \(\.$word)")
    }
    
    func perform() async throws -> some IntentResult & ReturnsValue<String> & ProvidesDialog {
        logger.debug("Calling App Intent \(#file) with args: word=\(word)")
        let trimmedWord = word.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // The parameter should be required, but an empty string could be considered "a value"
        guard !trimmedWord.isEmpty else {
            throw $word.needsValueError("The cooking term cannot be blank, please try again")
        }
        
        guard let terms = UserDefaultsManager.getTerms(), let definition = terms.first(where: { $0.word.lowercased() == trimmedWord.lowercased() })?.definition else {
            throw IntentError.failure("No definition found for \(word)")
        }
        
        // full = what Siri says, supporting = what's shown on screen while Siri is speaking
        let response: LocalizedStringResource = "Here is the definition of \(word): \(definition)"
        let dialog = IntentDialog(full: response, supporting: response)
        return .result(value: definition, dialog: dialog)
    }
}
