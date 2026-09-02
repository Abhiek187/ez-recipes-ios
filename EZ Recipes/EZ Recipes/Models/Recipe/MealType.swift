//
//  MealType.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 2/9/24.
//

import AppIntents
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
    case smoothie
    case cocktail
    case mocktail
    case seasoning
    case batter
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

extension MealType: AppEnum {
    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        TypeDisplayRepresentation(name: "Meal Type")
    }
    
    static let caseDisplayRepresentations: [MealType: DisplayRepresentation] = [
        .mainCourse: DisplayRepresentation(title: "main course"),
        .sideDish: DisplayRepresentation(title: "side dish"),
        .dessert: DisplayRepresentation(title: "dessert"),
        .appetizer: DisplayRepresentation(title: "appetizer"),
        .salad: DisplayRepresentation(title: "salad"),
        .bread: DisplayRepresentation(title: "bread"),
        .breakfast: DisplayRepresentation(title: "breakfast"),
        .soup: DisplayRepresentation(title: "soup"),
        .beverage: DisplayRepresentation(title: "beverage"),
        .sauce: DisplayRepresentation(title: "sauce"),
        .marinade: DisplayRepresentation(title: "marinade"),
        .fingerfood: DisplayRepresentation(title: "fingerfood"),
        .snack: DisplayRepresentation(title: "snack"),
        .drink: DisplayRepresentation(title: "drink"),
        .antipasti: DisplayRepresentation(title: "antipasti"),
        .starter: DisplayRepresentation(title: "starter"),
        .antipasto: DisplayRepresentation(title: "antipasto"),
        .horDOeuvre: DisplayRepresentation(title: "hor d'oeuvre"),
        .lunch: DisplayRepresentation(title: "lunch"),
        .mainDish: DisplayRepresentation(title: "main dish"),
        .dinner: DisplayRepresentation(title: "dinner"),
        .morningMeal: DisplayRepresentation(title: "morning meal"),
        .brunch: DisplayRepresentation(title: "brunch"),
        .condiment: DisplayRepresentation(title: "condiment"),
        .dip: DisplayRepresentation(title: "dip"),
        .spread: DisplayRepresentation(title: "spread"),
        .smoothie: DisplayRepresentation(title: "smoothie"),
        .cocktail: DisplayRepresentation(title: "cocktail"),
        .mocktail: DisplayRepresentation(title: "mocktail"),
        .seasoning: DisplayRepresentation(title: "seasoning"),
        .batter: DisplayRepresentation(title: "batter"),
        .unknown: DisplayRepresentation(title: "Unknown")
    ]
}
