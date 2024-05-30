//
//  TermStore.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 5/30/24.
//

import Foundation

struct TermStore: Codable {
    let terms: [Term]
    let expireAt: TimeInterval
}
