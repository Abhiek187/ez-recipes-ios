//
//  RecipeUpdate.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 2/17/25.
//

struct RecipeUpdate: Encodable {
    var rating: Int? = nil
    var view: Bool? = nil
    var isFavorite: Bool? = nil
}
