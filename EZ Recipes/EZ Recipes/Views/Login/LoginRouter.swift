//
//  LoginRouter.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 3/22/25.
//

import SwiftUI

enum LoginRoute: Hashable {
    case forgotPassword
    case login
    case signUp
    case verifyEmail(email: String)
}

@Observable class LoginRouter {
    // Open the login form initially
    var path: [LoginRoute] = [.login]
    
    func navigate(to route: LoginRoute) {
        // If the route already exists in the path, pop to the route
        if let routeIndex = path.firstIndex(of: route) {
            path.removeLast(path.count - routeIndex - 1)
        } else {
            path.append(route)
        }
    }
    
    func goBack() {
        path.removeLast()
    }
}
