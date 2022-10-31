//
//  Instruction.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 10/30/22.
//

struct Instruction: Decodable, Equatable {
    let name: String
    let steps: [Step]
}
