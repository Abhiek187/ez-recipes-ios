//
//  IntentError.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 9/2/26.
//

import Foundation

enum IntentError: Error {
    case failure(String)
}

// CustomLocalizedStringResourceConvertible needs to be used instead of LocalizedError to prevent "Throwing unknown NSError" warnings
extension IntentError: CustomLocalizedStringResourceConvertible {
    var localizedStringResource: LocalizedStringResource {
        switch self {
        case .failure(let error):
            return "Error: \(error)"
        }
    }
}
