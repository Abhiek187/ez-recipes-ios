//
//  Recipe.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 10/22/22.
//

struct Recipe: Decodable, Equatable {
    let _id: String?
    let id: Int // each recipe has a unique ID
    let name: String
    let url: String?
    let image: String
    let credit: String
    let sourceUrl: String
    let healthScore: Int
    let time: Int
    let servings: Int
    let summary: String
    let types: [MealType]
    let spiceLevel: SpiceLevel
    let isVegetarian: Bool
    let isVegan: Bool
    let isGlutenFree: Bool
    let isHealthy: Bool
    let isCheap: Bool
    let isSustainable: Bool
    let culture: [Cuisine]
    let nutrients: [Nutrient]
    let ingredients: [Ingredient]
    let instructions: [Instruction]
    var token: String? // searchSequenceToken for pagination
}
