//
//  EZ_RecipesApp.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 10/22/22.
//

import SwiftUI

@main
struct EZ_RecipesApp: App {
    let viewModel = HomeViewModel(repository: NetworkManager.shared)
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(viewModel)
                .onOpenURL { url in
                    viewModel.handleRecipeLink(url)
                }
        }
    }
}
