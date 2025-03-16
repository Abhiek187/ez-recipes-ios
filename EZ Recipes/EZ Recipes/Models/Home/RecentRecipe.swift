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
    // @Attribute(.transformable(by: NSSecureUnarchiveFromDataTransformer.self)) var recipe: [String: Any]
    // Temporary workaround to remove all the warnings about NSKeyedUnarchiveFromData
    @Attribute(.transformable(by: SecureValueTransformer.self)) var recipe: [String: Any]
    @Attribute var isFavorite: Bool = false // v2 (lightweight migration)
    
    public init(recipe: Recipe) {
        self.id = recipe.id
        self.recipe = recipe.dictionary
        self.timestamp = Date()
    }
}
