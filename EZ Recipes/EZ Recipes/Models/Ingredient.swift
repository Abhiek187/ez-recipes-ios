//
//  Ingredient.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 10/30/22.
//

struct Ingredient: Codable, Equatable {
    let id: Int
    let name: String
    let amount: Double
    let unit: String
}
