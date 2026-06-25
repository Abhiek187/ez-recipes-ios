//
//  RememberMe.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 6/23/26.
//

import Foundation

struct RememberMe: Codable {
    let username: String
    let expireAt: TimeInterval
}
