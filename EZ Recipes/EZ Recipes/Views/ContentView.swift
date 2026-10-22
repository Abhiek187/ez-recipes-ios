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
    let glossaryViewModel: GlossaryViewModel
    let profileViewModel: ProfileViewModel
    
    @State private var currentTab = Constants.Tabs.homeTitle
    
    // HomeViewModel is used for deep linking
    init(homeViewModel: HomeViewModel, glossaryViewModel: GlossaryViewModel) {
        self.homeViewModel = homeViewModel
        searchViewModel = SearchViewModel(repository: repository)
        self.glossaryViewModel = glossaryViewModel
        profileViewModel = ProfileViewModel(repository: repository)
    }
    
    var body: some View {
        TabView(selection: $currentTab) {
            Tab(Constants.Tabs.homeTitle, systemImage: "house", value: Constants.Tabs.homeTitle) {
                HomeView(homeViewModel: homeViewModel, profileViewModel: profileViewModel)
            }
            Tab(Constants.Tabs.searchTitle, systemImage: "magnifyingglass", value: Constants.Tabs.searchTitle) {
                SearchView(viewModel: searchViewModel)
            }
            Tab(Constants.Tabs.glossaryTitle, systemImage: "book", value: Constants.Tabs.glossaryTitle) {
                GlossaryView(viewModel: glossaryViewModel)
            }
            Tab(Constants.Tabs.profileTitle, systemImage: "person.crop.circle", value: Constants.Tabs.profileTitle) {
                ProfileView(viewModel: profileViewModel, profileAction: homeViewModel.profileAction)
            }
        }
        .tabViewStyle(.sidebarAdaptable)
        .onChange(of: homeViewModel.profileAction) { oldValue, newValue in
            // Open ProfileView with the appropriate confirmation message
            if oldValue == nil && newValue != nil {
                currentTab = Constants.Tabs.profileTitle
            }
        }
    }
}

#Preview {
    let repository = NetworkManager.shared
    let homeViewModel = HomeViewModel(repository: repository)
    let glossaryViewModel = GlossaryViewModel(repository: repository)
    
    ContentView(homeViewModel: homeViewModel, glossaryViewModel: glossaryViewModel)
}
