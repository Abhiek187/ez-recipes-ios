//
//  PasskeyClientResponse.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 3/14/26.
//

struct PasskeyClientResponse<R: PasskeyResponse & Sendable>: Encodable {
    let authenticatorAttachment: String
    // let clientExtensionResults: [String: Any] // excluding since the type can be any arbitrary dictionary and doesn't conform to Encodable
    let id: String
    let rawId: String
    let response: R
    let type: String
}

protocol PasskeyResponse: Encodable {
    var authenticatorData: String { get }
    var clientDataJSON: String { get }
}

struct NewPasskeyResponse: PasskeyResponse {
    let attestationObject: String
    let authenticatorData: String
    let clientDataJSON: String
    let publicKey: String
    let publicKeyAlgorithm: Int
    let transports: [String]
}

struct ExistingPasskeyResponse: PasskeyResponse {
    let authenticatorData: String
    let clientDataJSON: String
    let signature: String
}

typealias NewPasskeyClientResponse = PasskeyClientResponse<NewPasskeyResponse>
typealias ExistingPasskeyClientResponse = PasskeyClientResponse<ExistingPasskeyResponse>
