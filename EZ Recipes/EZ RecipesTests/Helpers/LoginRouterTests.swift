//
//  LoginRouterTests.swift
//  EZ RecipesTests
//
//  Created by Abhishek Chaudhuri on 3/30/25.
//

import Testing
@testable import EZ_Recipes

@Suite struct LoginRouterTests {
    private let loginRouter = LoginRouter()
    
    @Test func navigateWithEmptyPath() {
        // Given an empty path
        loginRouter.path = []
        
        // When navigating to a route
        loginRouter.navigate(to: .signUp)
        
        // Then the route is added to the path
        #expect(loginRouter.path == [.signUp])
    }
    
    @Test func navigateToUniqueRoute() {
        // Given a path
        loginRouter.path = [.forgotPassword, .signUp]
        
        // When navigating to a new route
        loginRouter.navigate(to: .verifyEmail(email: Constants.Mocks.chef.email))
        
        // Then the route is appended to the path
        #expect(loginRouter.path == [.forgotPassword, .signUp, .verifyEmail(email: Constants.Mocks.chef.email)])
    }
    
    @Test func navigateToExistingRoute() {
        // Given a path
        loginRouter.path = [.forgotPassword, .signUp]
        
        // When navigating to an existing route
        loginRouter.navigate(to: .forgotPassword)
        
        // Then the router pops to the existing route
        #expect(loginRouter.path == [.forgotPassword])
    }
    
    @Test func navigateBack() {
        // Given a path
        loginRouter.path = [.signUp]
        
        // When navigating back
        loginRouter.goBack()
        
        // Then the last route is removed from the path
        #expect(loginRouter.path.isEmpty)
    }
    
    @Test func navigateBackWithEmptyPath() {
        // Given an empty path
        loginRouter.path = []
        
        // When navigating back
        loginRouter.goBack()
        
        // Then nothing happens
        #expect(loginRouter.path.isEmpty)
    }
}
