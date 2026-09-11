//
//  SpotlightManager.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 9/10/26.
//

import CoreSpotlight
import OSLog

struct SpotlightManager {
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? Constants.appName, category: "SpotlightManager")
    
    /// Add a list of terms so they can be searched in Spotlight
    static func donateTerms(_ terms: [Term]) async throws {
        let index = CSSearchableIndex(name: "Terms")
        try await index.indexAppEntities(terms, priority: 1)
        
        logger.debug("Donated \(terms.count) terms to Spotlight")
    }
}
