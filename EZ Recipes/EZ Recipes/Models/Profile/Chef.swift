//
//  Chef.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 2/17/25.
//

struct Chef: Codable {
    let uid: String
    let email: String
    let emailVerified: Bool
    let ratings: [String: Int]
    let recentRecipes: [String: String]
    let favoriteRecipes: [String]
    let token: String
}
