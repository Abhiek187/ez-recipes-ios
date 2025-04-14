//
//  ContentView.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 2/8/24.
//

import SwiftUI

struct ContentView: View {
    let repository = NetworkManager.shared
    let homeViewModel: HomeViewModel
    let searchViewModel: SearchViewModel
    let profileViewModel: ProfileViewModel
    
    init() {
        homeViewModel = HomeViewModel(repository: repository)
        searchViewModel = SearchViewModel(repository: repository)
        profileViewModel = ProfileViewModel(repository: repository)
    }
    
    var body: some View {
        TabView {
            // TODO: Replace .tabItem with Tab() for iOS 18.0+
            HomeView(homeViewModel: homeViewModel, profileViewModel: profileViewModel)
                .tabItem {
                    Constants.Tabs.home
                }
            SearchView(viewModel: searchViewModel)
                .tabItem {
                    Constants.Tabs.search
                }
            GlossaryView()
                .tabItem {
                    Constants.Tabs.glossary
                }
            ProfileView(viewModel: profileViewModel)
                .tabItem {
                    Constants.Tabs.profile
                }
        }
    }
}

#Preview {
    ContentView()
}
