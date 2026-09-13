//
//  Term.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 2/3/24.
//

import AppIntents
import CoreSpotlight

// IndexedEntity allows terms to be searchable using Spotlight
struct Term: Codable, IndexedEntity {
    let _id: String
    var word: String
    var definition: String
    
    static let defaultQuery = TermQuery()
    
    var id: String { _id }
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        TypeDisplayRepresentation(name: "Terms", numericFormat: LocalizedStringResource("\(placeholder: .int) terms"))
    }
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(word)", subtitle: "\(definition)")
    }
    
    var attributeSet: CSSearchableItemAttributeSet {
        // The word is used by default as the title. The content description is shown underneath when viewing results in Spotlight.
        let attributes = defaultAttributeSet
        attributes.contentDescription = definition
        return attributes
    }
}

struct TermQuery: EntityQuery {
    func entities(for identifiers: [Term.ID]) async throws -> [Term] {
        let terms = UserDefaultsManager.getTerms() ?? []
        return terms.filter { identifiers.contains($0._id) }
    }
}
