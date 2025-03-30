//
//  Chef.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 2/17/25.
//

struct Chef: Codable, Equatable {
    let uid: String
    let email: String
    let emailVerified: Bool
    let ratings: [String: Int]
    let recentRecipes: [String: String]
    let favoriteRecipes: [String]
    let token: String
    
    func copy(emailVerified: Bool) -> Self {
        return Chef(uid: self.uid, email: self.email, emailVerified: emailVerified, ratings: self.ratings, recentRecipes: self.recentRecipes, favoriteRecipes: self.favoriteRecipes, token: self.token)
    }
}
