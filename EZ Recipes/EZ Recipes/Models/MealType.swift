//
//  MealType.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 2/9/24.
//

import OSLog

enum MealType: String, Codable, CaseIterable, Comparable {
    case mainCourse = "main course"
    case sideDish = "side dish"
    case dessert
    case appetizer
    case salad
    case bread
    case breakfast
    case soup
    case beverage
    case sauce
    case marinade
    case fingerfood
    case snack
    case drink
    case antipasti
    case starter
    case antipasto
    case horDOeuvre = "hor d'oeuvre"
    case lunch
    case mainDish = "main dish"
    case dinner
    case morningMeal = "morning meal"
    case brunch
    case condiment
    case dip
    case spread
    case unknown
    
    // Allow the meal types to be sorted for ease of reference
    static func < (lhs: MealType, rhs: MealType) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
    // Default to unknown if spoonacular returns a value that's undocumented
    init(from decoder: Decoder) throws {
        let decodedRawValue = try decoder.singleValueContainer().decode(RawValue.self)
        
        guard let _self = Self(rawValue: decodedRawValue) else {
            let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? Constants.appName, category: "MealType")
            logger.warning("Encountered an unknown meal type: \(decodedRawValue)")
            self = .unknown
            return
        }
        
        self = _self
    }
}
