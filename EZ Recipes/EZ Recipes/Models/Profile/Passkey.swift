//
//  Passkey.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 3/14/26.
//

struct Passkey: Codable, Equatable {
    var webAuthnUserID: String? = nil
    let id: String
    let publicKey: String
    let counter: Int
    var transports: [String]? = nil
    let deviceType: String
    let backedUp: Bool
    let name: String
    let lastUsed: String
    var iconLight: String? = nil
    var iconDark: String? = nil
}
