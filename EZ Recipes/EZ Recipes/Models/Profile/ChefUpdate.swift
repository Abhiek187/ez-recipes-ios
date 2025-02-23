//
//  ChefUpdate.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 2/17/25.
//

struct ChefUpdate: Encodable {
    let type: ChefUpdateType
    let email: String
    let password: String?
}
