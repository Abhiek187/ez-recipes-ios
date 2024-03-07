//
//  EZ_RecipesApp.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 10/22/22.
//

import SwiftUI

@main
struct EZ_RecipesApp: App {
    // @ObservedObject/@StateObject/@EnvironmentObject is required to initialize ViewModels on the main thread
    @ObservedObject var homeViewModel = HomeViewModel(repository: NetworkManager.shared)
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    homeViewModel.handleRecipeLink(url)
                }
        }
    }
}
