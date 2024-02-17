//
//  Cuisine.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 2/9/24.
//

enum Cuisine: String, Codable, CaseIterable, Comparable {
    case African
    case Asian
    case American
    case British
    case Cajun
    case Caribbean
    case Chinese
    case EasternEuropean = "Eastern European"
    case European
    case French
    case German
    case Greek
    case Indian
    case Irish
    case Italian
    case Japanese
    case Jewish
    case Korean
    case LatinAmerican = "Latin American"
    case Mediterranean
    case Mexican
    case MiddleEastern = "Middle Eastern"
    case Nordic
    case Southern
    case Spanish
    case Thai
    case Vietnamese
    
    static func < (lhs: Cuisine, rhs: Cuisine) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
