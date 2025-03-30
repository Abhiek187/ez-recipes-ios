//
//  LoginResponse.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 2/17/25.
//

struct LoginResponse: Decodable {
    let uid: String
    let token: String
    let emailVerified: Bool
    
    func copy(emailVerified: Bool) -> Self {
        return LoginResponse(uid: self.uid, token: self.token, emailVerified: emailVerified)
    }
}
