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
                    Constants.Tabs.home
                }
            SearchView(viewModel: SearchViewModel(repository: NetworkManager.shared))
                .tabItem {
                    Constants.Tabs.search
                }
            GlossaryView()
                .tabItem {
                    Constants.Tabs.glossary
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
