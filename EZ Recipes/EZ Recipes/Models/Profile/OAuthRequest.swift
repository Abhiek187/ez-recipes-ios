//
//  OAuthRequest.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 12/20/25.
//

struct OAuthRequest: Encodable {
    let code: String
    let providerId: Provider
    let redirectUrl: String
}
