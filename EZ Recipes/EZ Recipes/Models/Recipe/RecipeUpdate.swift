//
//  RecipeUpdate.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 2/17/25.
//

struct RecipeUpdate: Encodable {
    let rating: Int?
    let view: Bool?
    let isFavorite: Bool?
}
