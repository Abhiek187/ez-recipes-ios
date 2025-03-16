//
//  EZ_RecipesApp.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 10/22/22.
//

import SwiftUI

@main
struct EZ_RecipesApp: App {
    let homeViewModel = HomeViewModel(repository: NetworkManager.shared)
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    // Verify Universal Links configuration: https://app-site-association.cdn-apple.com/a/v1/ez-recipes-web.onrender.com
                    Task {
                        await homeViewModel.handleDeepLink(url)
                    }
                }
                .task {
                    await homeViewModel.checkCachedTerms()
                }
        }
    }
}
