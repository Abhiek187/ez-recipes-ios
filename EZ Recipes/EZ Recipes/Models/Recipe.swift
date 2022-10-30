//
//  Recipe.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 10/22/22.
//

struct Recipe: Decodable {
    let id: Int
    let name: String
    let url: String
    let image: String
    let credit: String?
    let sourceUrl: String
    let healthScore: Int
    let time: Int
    let servings: Int
    let summary: String
    let nutrients: [Nutrient]
    let ingredients: [Ingredient]
    let instructions: [Instruction]
    
    struct Nutrient: Decodable {
        let name: String
        let amount: Double
        let unit: String
    }
    
    struct Ingredient: Decodable {
        let id: Int
        let name: String
        let amount: Double
        let unit: String
    }
    
    struct Instruction: Decodable {
        let name: String
        let steps: [Step]
        
        struct Step: Decodable {
            let number: Int
            let step: String
            let ingredients: [StepItem]
            let equipment: [StepItem]
            
            struct StepItem: Decodable {
                let id: Int
                let name: String
                let image: String
            }
        }
    }
}
