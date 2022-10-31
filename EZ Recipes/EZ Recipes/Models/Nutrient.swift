//
//  Nutrient.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 10/30/22.
//

struct Nutrient: Decodable, Equatable {
    let name: String
    let amount: Double
    let unit: String
}
