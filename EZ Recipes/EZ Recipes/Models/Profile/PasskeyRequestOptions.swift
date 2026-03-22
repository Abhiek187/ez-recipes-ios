//
//  PasskeyRequestOptions.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 3/14/26.
//

struct PasskeyRequestOptions: Decodable {
    let rpId: String
    let challenge: String
    let allowCredentials: [Credential]
    let timeout: Int
    let userVerification: String
    
    struct Credential: Decodable {
        let id: String
        let transports: [String]
        let type: String
    }
}
