//
//  SpiceLevel.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 2/3/24.
//

import AppIntents

enum SpiceLevel: String, Codable, CaseIterable {
    case none, mild, spicy, unknown
}

extension SpiceLevel: AppEnum {
    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        TypeDisplayRepresentation(name: "Spice Level")
    }
    
    static let caseDisplayRepresentations: [SpiceLevel : DisplayRepresentation] = [
        .none: DisplayRepresentation(title: "none"),
        .mild: DisplayRepresentation(title: "mild"),
        .spicy: DisplayRepresentation(title: "spicy"),
        .unknown: DisplayRepresentation(title: "unknown")
    ]
}
