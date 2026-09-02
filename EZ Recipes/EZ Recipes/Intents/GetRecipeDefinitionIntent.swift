//
//  GetRecipeDefinitionIntent.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 8/26/26.
//

import AppIntents
import OSLog

struct GetRecipeDefinitionIntent: AppIntent {
    static let title: LocalizedStringResource = "Get Recipe Definition"
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? Constants.appName, category: "GetRecipeDefinitionIntent")
    
    @Parameter(title: "Word", description: "The cooking-related term to look up")
    var word: String
    
    static var parameterSummary: some ParameterSummary {
        Summary("Get the definition for \(\.$word)")
    }
    
    func perform() async throws -> some IntentResult & ReturnsValue<String> {
        logger.debug("Calling App Intent \(#file) with args: word=\(word)")
        
        guard let terms = UserDefaultsManager.getTerms(), let definition = terms.first(where: { $0.word.lowercased() == word.lowercased() })?.definition else {
            throw NSError(domain: "GetRecipeDefinitionIntent", code: 1, userInfo: [NSLocalizedDescriptionKey: "No definition found for \(word)"])
        }
        
        return .result(value: definition)
    }
}
