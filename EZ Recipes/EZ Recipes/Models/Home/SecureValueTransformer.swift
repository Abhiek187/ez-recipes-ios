//
//  SecureValueTransformer.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 3/9/25.
//

import Foundation
import OSLog

class SecureValueTransformer: ValueTransformer {
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? Constants.appName, category: "SecureValueTransformer")
    
    override class func transformedValueClass() -> AnyClass {
        return NSDictionary.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let dictionary = value as? [String: Any] else { return nil }
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: dictionary, requiringSecureCoding: true)
            return data
        } catch {
            logger.warning("Failed to encode dictionary: \(error.localizedDescription)")
            return nil
        }
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        do {
            // Account for all subtypes within the dictionary
            let dictionary = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSDictionary.self, NSString.self, NSNumber.self, NSArray.self], from: data) as? [String: Any]
            return dictionary
        } catch {
            logger.warning("Failed to decode dictionary: \(error.localizedDescription)")
            return nil
        }
    }
}
