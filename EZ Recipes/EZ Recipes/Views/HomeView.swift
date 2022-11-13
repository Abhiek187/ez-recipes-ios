//
//  ContentView.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 10/22/22.
//

import SwiftUI

struct HomeView: View {
    // Subscribe to changes in the ObservableObject and automatically update the UI
    @StateObject private var viewModel = HomeViewModel(repository: NetworkManager.shared)
    
    var body: some View {
        Text("Hello, world!")
            .padding()
            .onAppear {
                //viewModel.getRandomRecipe()
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(Device.all, id: \.self) { device in
            HomeView()
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }
    }
}
