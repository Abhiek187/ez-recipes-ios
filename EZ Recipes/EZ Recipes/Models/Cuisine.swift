//
//  Cuisine.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 2/9/24.
//

import OSLog

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
    case English
    case Scottish
    case SouthAmerican = "South American"
    case Creole
    case CentralAmerican = "Central American"
    case unknown
    
    static func < (lhs: Cuisine, rhs: Cuisine) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
    init(from decoder: Decoder) throws {
        let decodedRawValue = try decoder.singleValueContainer().decode(RawValue.self)
        
        guard let _self = Self(rawValue: decodedRawValue) else {
            let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? Constants.appName, category: "Cuisine")
            logger.warning("Encountered an unknown cuisine: \(decodedRawValue)")
            self = .unknown
            return
        }
        
        self = _self
    }
}
