//
//  ContentView.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 2/8/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView(viewModel: HomeViewModel(repository: NetworkManager.shared))
                .tabItem {
                    Label(Constants.Tabs.home, systemImage: "house")
                }
            SearchView(viewModel: SearchViewModel(repository: NetworkManager.shared))
                .tabItem {
                    Label(Constants.Tabs.search, systemImage: "magnifyingglass")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
