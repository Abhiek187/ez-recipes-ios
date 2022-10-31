//
//  Step.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 10/30/22.
//

struct Step: Decodable, Equatable {
    let number: Int
    let step: String
    let ingredients: [StepItem]
    let equipment: [StepItem]
}
