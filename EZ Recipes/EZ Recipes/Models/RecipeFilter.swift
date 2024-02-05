//
//  RecipeFilter.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 2/3/24.
//

struct RecipeFilter: Encodable {
    let query: String?
    let minCals: Int?
    let maxCals: Int?
    let vegetarian: Bool?
    let vegan: Bool?
    let glutenFree: Bool?
    let healthy: Bool?
    let cheap: Bool?
    let sustainable: Bool?
    let spiceLevel: [SpiceLevel]?
    let type: [String]?
    let culture: [String]?
}
