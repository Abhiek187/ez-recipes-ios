//
//  HomeView.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 10/22/22.
//

import SwiftUI

struct HomeView: View {
    // Subscribe to changes in the ObservableObject and automatically update the UI
    @EnvironmentObject private var viewModel: HomeViewModel
    
    // Don't show any messages initially if the recipe loads quickly
    // " " will allocate space for the loading message so the UI doesn't dynamically shift
    @State private var loadingMessage = " "
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView {
            VStack {
                // Show the recipe view once the recipe loads in the ViewModel
                NavigationLink(destination: RecipeView(), isActive: $viewModel.isRecipeLoaded) {
                    Button {
                        viewModel.getRandomRecipe()
                    } label: {
                        Text(Constants.HomeView.findRecipeButton)
                            .foregroundStyle(viewModel.isLoading ? Color.primary : .black)
                            .font(.system(size: 22))
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.yellow)
                    // Prevent users from spamming the button
                    .disabled(viewModel.isLoading)
                    // Show an alert if the request failed
                    .alert(Constants.HomeView.errorTitle, isPresented: $viewModel.recipeFailedToLoad) {
                        Button(Constants.HomeView.okButton, role: .cancel) {}
                    } message: {
                        // recipeError shouldn't be nil if recipeFailedToLoad is true
                        Text(viewModel.recipeError?.error ?? Constants.HomeView.unknownError)
                    }
                }
                
                // Show a spinner while the network request is loading
                // Use opacity instead of an if statement so the button doesn't jump when pressed
                ProgressView()
                    .opacity(viewModel.isLoading ? 1 : 0)
                Text(loadingMessage)
                    .opacity(viewModel.isLoading ? 1 : 0)
                    // TODO: change to the 0 or 2-parameter variant if this deprecated modifier is removed
                    .onChange(of: viewModel.isLoading) { isLoading in
                        if isLoading {
                            loadingMessage = " "
                        }
                    }
                    .onReceive(timer) { _ in
                        loadingMessage = Constants.HomeView.loadingMessages.randomElement() ?? " "
                    }
            }
            .navigationTitle(Constants.HomeView.homeTitle)
            
            // Show a message in the secondary view that tells the user to select a recipe (only visible on wide screens)
            SecondaryView()
        }
        .navigationViewStyle(.automatic) // TODO: when iOS 16 is the minimum deployment target, migrate to NavigationStack/NavigationSplitView: https://developer.apple.com/documentation/swiftui/migrating-to-new-navigation-types
        .onDisappear {
            // Stop any network calls when switching tabs
            viewModel.task?.cancel()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    // Show previews of the HomeView with and without the spinner or an alert box
    static let repoSuccess = NetworkManagerMock.shared
    static var repoFail = NetworkManagerMock.shared
    
    static let viewModelWithoutLoading = HomeViewModel(repository: repoSuccess)
    static let viewModelWithLoading = HomeViewModel(repository: repoSuccess)
    static let viewModelWithAlert = HomeViewModel(repository: repoFail)
    
    static var previews: some View {
        viewModelWithLoading.isLoading = true
        repoFail.isSuccess = false
        
        return ForEach([1], id: \.self) {_ in
            HomeView()
                .previewDisplayName("No Loading")
                .environmentObject(viewModelWithoutLoading)
            HomeView()
                .previewDisplayName("Loading")
                .environmentObject(viewModelWithLoading)
            HomeView()
                .previewDisplayName("Alert")
                .environmentObject(viewModelWithAlert)
        }
    }
}
