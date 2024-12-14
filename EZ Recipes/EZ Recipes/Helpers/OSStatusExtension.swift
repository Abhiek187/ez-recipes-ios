//
//  OSStatusExtension.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 12/13/24.
//

import Foundation

extension OSStatus {
    /// Convert an OSStatus code to a more human-readable error
    /// - Returns: an `NSError` object with the error message, or `nil` if the status is success
    /// - Note: OSStatus codes can be found at https://www.osstatus.com/
    var error: NSError {
//        guard self != errSecSuccess else { return nil }

        let message = SecCopyErrorMessageString(self, nil) as String? ?? "Unknown error"

        return NSError(domain: NSOSStatusErrorDomain, code: Int(self), userInfo: [
            NSLocalizedDescriptionKey: message
        ])
    }
}
