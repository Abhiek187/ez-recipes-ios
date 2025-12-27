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
    let providerData: [ProviderData]
    let ratings: [String: Int]
    let recentRecipes: [String: String]
    let favoriteRecipes: [String]
    let token: String
    
    func copy(emailVerified: Bool? = nil, providerData: [ProviderData]? = nil, ratings: [String: Int]? = nil, recentRecipes: [String: String]? = nil, favoriteRecipes: [String]? = nil) -> Self {
        return Chef(uid: self.uid, email: self.email, emailVerified: emailVerified ?? self.emailVerified, providerData: providerData ?? self.providerData, ratings: ratings ?? self.ratings, recentRecipes: recentRecipes ?? self.recentRecipes, favoriteRecipes: favoriteRecipes ?? self.favoriteRecipes, token: self.token)
    }
}
