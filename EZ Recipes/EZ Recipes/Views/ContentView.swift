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
            HomeView()
                .tabItem {
                    Label(Constants.Strings.Tabs.home, systemImage: "house")
                }
            SearchView()
                .tabItem {
                    Label(Constants.Strings.Tabs.search, systemImage: "magnifyingglass")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static let viewModel = HomeViewModel(repository: NetworkManagerMock.shared)
    
    static var previews: some View {
        ContentView()
            .environmentObject(viewModel)
    }
}
