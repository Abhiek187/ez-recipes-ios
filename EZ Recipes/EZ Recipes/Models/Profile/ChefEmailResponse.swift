//
//  ChefEmailResponse.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 2/17/25.
//

struct ChefEmailResponse: Decodable {
    let kind: String
    let email: String
    var token: String? = nil
}
