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
    
    let coreData = CoreDataManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, coreData.container.viewContext)
                .onOpenURL { url in
                    homeViewModel.handleRecipeLink(url)
                }
                .onAppear {
                    homeViewModel.checkCachedTerms()
                }
        }
    }
}
