//
//  AuthUrl.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 12/20/25.
//

struct AuthUrl: Decodable {
    let providerId: Provider
    let authUrl: String
}
