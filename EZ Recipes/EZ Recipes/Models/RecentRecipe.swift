//
//  RecentRecipe.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 6/8/24.
//

import CoreData

class RecentRecipe: NSManagedObject {
    @NSManaged var id: Int // extract id from recipe to detect duplicates
    @NSManaged var timestamp: Date
    @NSManaged var recipe: [String: Any] // transformable types can only be arrays or dictionaries
    
    /// Initialize a new RecentRecipe object and insert it into Core Data
    convenience init(recipe: Recipe, insertInto context: NSManagedObjectContext) {
        // Don't define an entity here, otherwise the previews will crash
        self.init(context: context)
        
        self.id = recipe.id
        self.recipe = recipe.dictionary
        self.timestamp = Date()
    }
}
