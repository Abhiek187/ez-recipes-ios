//
//  Cuisine.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 2/9/24.
//

import AppIntents
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
    case BBQ
    case Barbecue
    case Scandinavian
    case unknown
    
    static func < (lhs: Cuisine, rhs: Cuisine) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
    init(from decoder: Decoder) throws {
        var decodedRawValue = try decoder.singleValueContainer().decode(RawValue.self)
        // BBQ appears lowercase from spoonacular
        if decodedRawValue == "bbq" {
            decodedRawValue = "BBQ"
        }
        
        guard let _self = Self(rawValue: decodedRawValue) else {
            let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? Constants.appName, category: "Cuisine")
            logger.warning("Encountered an unknown cuisine: \(decodedRawValue)")
            self = .unknown
            return
        }
        
        self = _self
    }
}

extension Cuisine: AppEnum {
    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        TypeDisplayRepresentation(name: "Cuisine")
    }
    
    static let caseDisplayRepresentations: [Cuisine: DisplayRepresentation] = [
        .African: DisplayRepresentation(title: "African"),
        .Asian: DisplayRepresentation(title: "Asian"),
        .American: DisplayRepresentation(title: "American"),
        .British: DisplayRepresentation(title: "British"),
        .Cajun: DisplayRepresentation(title: "Cajun"),
        .Caribbean: DisplayRepresentation(title: "Caribbean"),
        .Chinese: DisplayRepresentation(title: "Chinese"),
        .EasternEuropean: DisplayRepresentation(title: "Eastern European"),
        .European: DisplayRepresentation(title: "European"),
        .French: DisplayRepresentation(title: "French"),
        .German: DisplayRepresentation(title: "German"),
        .Greek: DisplayRepresentation(title: "Greek"),
        .Indian: DisplayRepresentation(title: "Indian"),
        .Irish: DisplayRepresentation(title: "Irish"),
        .Italian: DisplayRepresentation(title: "Italian"),
        .Japanese: DisplayRepresentation(title: "Japanese"),
        .Jewish: DisplayRepresentation(title: "Jewish"),
        .Korean: DisplayRepresentation(title: "Korean"),
        .LatinAmerican: DisplayRepresentation(title: "Latin American"),
        .Mediterranean: DisplayRepresentation(title: "Mediterranean"),
        .Mexican: DisplayRepresentation(title: "Mexican"),
        .MiddleEastern: DisplayRepresentation(title: "Middle Eastern"),
        .Nordic: DisplayRepresentation(title: "Nordic"),
        .Southern: DisplayRepresentation(title: "Southern"),
        .Spanish: DisplayRepresentation(title: "Spanish"),
        .Thai: DisplayRepresentation(title: "Thai"),
        .Vietnamese: DisplayRepresentation(title: "Vietnamese"),
        .English: DisplayRepresentation(title: "English"),
        .Scottish: DisplayRepresentation(title: "Scottish"),
        .SouthAmerican: DisplayRepresentation(title: "South American"),
        .Creole: DisplayRepresentation(title: "Creole"),
        .CentralAmerican: DisplayRepresentation(title: "Central American"),
        .BBQ: DisplayRepresentation(title: "BBQ"),
        .Barbecue: DisplayRepresentation(title: "Barbecue"),
        .Scandinavian: DisplayRepresentation(title: "Scandinavian"),
        .unknown: DisplayRepresentation(title: "Unknown")
    ]
}
