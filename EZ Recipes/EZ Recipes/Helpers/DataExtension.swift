//
//  DataExtension.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 3/15/26.
//

import Foundation

extension Data {
    /// Convert Data into a base64 URL-encoded String
    var base64URLEncodedString: String {
        return self.base64EncodedString()
            .replacing("+", with: "-")
            .replacing("/", with: "_")
            .replacing("=", with: "")
    }
}
