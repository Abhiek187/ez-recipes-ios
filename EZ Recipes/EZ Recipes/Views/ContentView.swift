//
//  ContentView.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 10/22/22.
//

import SwiftUI

struct ContentView: View {
    // Subscribe to changes in the ObservableObject and automatically update the UI
    @StateObject private var viewModel = ContentViewModel(repository: NetworkManager.shared)
    
    var body: some View {
        Text("Hello, world!")
            .padding()
            .onAppear {
                viewModel.getRandomRecipe()
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
