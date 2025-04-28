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
    
    @State private var currentTab = Constants.HomeView.homeTitle
    
    // HomeViewModel is used for deep linking
    init(homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel
        searchViewModel = SearchViewModel(repository: repository)
        profileViewModel = ProfileViewModel(repository: repository)
    }
    
    var body: some View {
        TabView(selection: $currentTab) {
            // TODO: Replace .tabItem with Tab() for iOS 18.0+
            HomeView(homeViewModel: homeViewModel, profileViewModel: profileViewModel)
                .tabItem {
                    Constants.Tabs.home
                }
                .tag(Constants.HomeView.homeTitle)
            SearchView(viewModel: searchViewModel)
                .tabItem {
                    Constants.Tabs.search
                }
                .tag(Constants.SearchView.searchTitle)
            GlossaryView()
                .tabItem {
                    Constants.Tabs.glossary
                }
                .tag(Constants.GlossaryView.glossaryTitle)
            ProfileView(viewModel: profileViewModel, profileAction: homeViewModel.profileAction)
                .tabItem {
                    Constants.Tabs.profile
                }
                .tag(Constants.ProfileView.profileTitle)
        }
        .onChange(of: homeViewModel.profileAction) { oldValue, newValue in
            // Open ProfileView with the appropriate confirmation message
            if oldValue == nil && newValue != nil {
                currentTab = Constants.ProfileView.profileTitle
            }
        }
    }
}

#Preview {
    let homeViewModel = HomeViewModel(repository: NetworkManager.shared)
    
    ContentView(homeViewModel: homeViewModel)
}
