//
//  Instruction.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 10/30/22.
//

struct Instruction: Codable, Equatable {
    let name: String
    let steps: [Step]
}
