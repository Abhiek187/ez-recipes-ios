//
//  PasskeyCreationOptions.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 3/14/26.
//

struct PasskeyCreationOptions: Decodable {
    let challenge: String
    let rp: RelyingParty
    let user: User
    let pubKeyCredParams: [PubKeyCredParam]
    let timeout: Int
    let attestation: String
    let excludeCredentials: [Credential]
    let authenticatorSelection: AuthenticatorSelection
    let extensions: [String: Bool]
    let hints: [String]
    
    struct RelyingParty: Decodable {
        let name: String
        let id: String
    }
    
    struct User: Decodable {
        let id: String
        let name: String
        let displayName: String
    }
    
    struct PubKeyCredParam: Decodable {
        let alg: Int
        let type: String
    }
    
    struct Credential: Decodable {
        let id: String
        let transports: [String]
        let type: String
    }

    struct AuthenticatorSelection: Decodable {
        let requireResidentKey: Bool
        let residentKey: String
        let userVerification: String
    }
}
