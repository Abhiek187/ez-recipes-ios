//
//  RecentRecipe.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 3/8/25.
//
//

import Foundation
import SwiftData

@Model
class RecentRecipe {
    @Attribute(.unique) var id: Int
    var timestamp: Date
    // Transformable types can only be arrays or dictionaries
    // SwiftData automatically transforms attribute using NSSecureUnarchiveFromData
    @Attribute(.transformable(by: "NSSecureUnarchiveFromData")) var recipe: [String: Any]
    
    public init(recipe: Recipe) {
        self.id = recipe.id
        self.recipe = recipe.dictionary
        self.timestamp = Date()
    }
}
