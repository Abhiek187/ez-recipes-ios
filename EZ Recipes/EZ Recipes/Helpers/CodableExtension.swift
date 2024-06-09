//
//  CodableExtension.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 6/8/24.
//

import Foundation

extension Encodable {
    /// Convert an Encodable object to a dictionary
    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(self))) as? [String: Any] ?? [:]
    }
}

extension Dictionary {
    /// Convert a dictionary to a Decodable object
    /// - Returns: the Decodable object, or `nil` if the dictionary couldn't be decoded
    func decode<T: Decodable>() -> T? {
        return try? JSONDecoder().decode(T.self, from: JSONSerialization.data(withJSONObject: self))
    }
}
