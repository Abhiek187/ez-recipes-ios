//
//  DataExtension.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 3/15/26.
//

import Foundation

extension Data {
    /// Convert Data into a UTF-8 String
    var string: String {
        return String(decoding: self, as: UTF8.self)
    }
}
