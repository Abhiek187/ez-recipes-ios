//
//  LoginRouter.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 3/22/25.
//

import SwiftUI

enum LoginRoute: Hashable {
    case forgotPassword
    case signUp
    case verifyEmail(email: String)
}

@Observable class LoginRouter {
    // Open the login form initially
    var path: [LoginRoute] = []
    
    func navigate(to route: LoginRoute) {
        // If the route already exists in the path, pop to the route
        if let routeIndex = path.firstIndex(of: route) {
            path.removeLast(path.count - routeIndex - 1)
        } else {
            path.append(route)
        }
    }
    
    func goBack() {
        // Do nothing if we're at the root
        if !path.isEmpty {
            path.removeLast()
        }
    }
}
