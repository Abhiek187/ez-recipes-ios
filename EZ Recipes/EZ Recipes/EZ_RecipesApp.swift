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
                    Task {
                        await homeViewModel.handleRecipeLink(url)
                    }
                }
                .task {
                    await homeViewModel.checkCachedTerms()
                }
        }
    }
}
