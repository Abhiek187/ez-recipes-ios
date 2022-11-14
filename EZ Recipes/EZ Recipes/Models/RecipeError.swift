//
//  RecipeError.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 10/22/22.
//

struct RecipeError: Decodable, Equatable, Error {
    let error: String
}
