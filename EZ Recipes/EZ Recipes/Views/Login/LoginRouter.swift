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
    var path = NavigationPath()
    
    func navigate(to route: LoginRoute) {
        path.append(route)
    }
    
    func goBack() {
        path.removeLast()
    }
}
