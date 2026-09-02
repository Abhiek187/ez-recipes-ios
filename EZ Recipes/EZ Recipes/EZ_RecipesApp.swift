//
//  EZ_RecipesApp.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 10/22/22.
//

import SwiftUI
import AppIntents

@main
struct EZ_RecipesApp: App {
    let homeViewModel: HomeViewModel
    
    init() {
        let networkManager = NetworkManager.shared
        homeViewModel = HomeViewModel(repository: networkManager)
        
        // Dependencies required for App Intents
        AppDependencyManager.shared.add(dependency: networkManager)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(homeViewModel: homeViewModel)
                .onOpenURL { url in
                    // Verify Universal Links configuration: https://app-site-association.cdn-apple.com/a/v1/ez-recipes-web.onrender.com
                    // Debugging Universal Links: https://developer.apple.com/documentation/technotes/tn3155-debugging-universal-links
                    Task {
                        await homeViewModel.handleDeepLink(url)
                    }
                }
                .task {
                    await homeViewModel.checkCachedTerms()
                    // Universal Links for testing
                    // await homeViewModel.handleDeepLink(URL(string: "\(Constants.recipeWebOrigin)/recipe/644783")!)
                    // await homeViewModel.handleDeepLink(URL(string: "\(Constants.recipeWebOrigin)/profile?action=verifyEmail")!)
                }
        }
    }
}
