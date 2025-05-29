//
//  RecipeFilter.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 2/3/24.
//

struct RecipeFilter: Encodable {
    var query: String = ""
    var minCals: Int?
    var maxCals: Int?
    var vegetarian: Bool = false
    var vegan: Bool = false
    var glutenFree: Bool = false
    var healthy: Bool = false
    var cheap: Bool = false
    var sustainable: Bool = false
    var rating: Int?
    var spiceLevel: Set<String> = []
    var type: Set<String> = []
    var culture: Set<String> = []
    var token: String? // either an ObjectId or searchSequenceToken for pagination
}
