//
//  Provider.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 12/20/25.
//

import SwiftUI

enum Provider: String, Codable, CaseIterable {
    case google = "google.com"
    case facebook = "facebook.com"
    case github = "github.com"
    
    // Source: https://github.com/firebase/FirebaseUI-iOS/blob/main/FirebaseSwiftUI/FirebaseAuthUIComponents/Sources/Theme/ProviderStyle.swift
    var style: ProviderStyle {
        // The labels also match the asset names
        switch self {
        case .google:
            ProviderStyle(label: "Google", backgroundColor: Color(hex: 0xFFFFFF), contentColor: Color(hex: 0x757575))
        case .facebook:
            ProviderStyle(label: "Facebook", backgroundColor: Color(hex: 0x1877F2), contentColor: Color(hex: 0xFFFFFF))
        case .github:
            ProviderStyle(label: "GitHub", backgroundColor: Color(hex: 0x24292E), contentColor: Color(hex: 0xFFFFFF))
        }
    }
}
