//
//  ProviderData.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 12/21/25.
//

struct ProviderData: Codable, Equatable {
    var displayName: String? = nil
    let email: String
    var phoneNumber: String? = nil
    var photoURL: String? = nil
    let providerId: String // password auth can appear here
    let uid: String
}
