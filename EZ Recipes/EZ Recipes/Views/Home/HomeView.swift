//
//  HomeView.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 10/22/22.
//

import SwiftUI

struct HomeView: View {
    // Subscribe to changes in the ObservableObject and automatically update the UI
    @StateObject var viewModel: HomeViewModel
    
    // Don't show any messages initially if the recipe loads quickly
    // " " will allocate space for the loading message so the UI doesn't dynamically shift
    private let defaultLoadingMessage = " "
    @State private var loadingMessage = " "
    private let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationSplitView {
            VStack {
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
                .alert(Constants.errorTitle, isPresented: $viewModel.recipeFailedToLoad) {
                    Button(Constants.okButton, role: .cancel) {}
                } message: {
                    // recipeError shouldn't be nil if recipeFailedToLoad is true
                    Text(viewModel.recipeError?.error ?? Constants.unknownError)
                }
                // Show the recipe view once the recipe loads in the ViewModel
                .navigationDestination(isPresented: $viewModel.isRecipeLoaded) {
                    RecipeView(viewModel: viewModel)
                }
                
                // Show a spinner while the network request is loading
                // Use opacity instead of an if statement so the button doesn't jump when pressed
                ProgressView()
                    .opacity(viewModel.isLoading ? 1 : 0)
                Text(loadingMessage)
                    .opacity(viewModel.isLoading ? 1 : 0)
                // TODO: change to the 0-parameter variant if this deprecated modifier is removed (or targeting iOS 17)
                    .onChange(of: viewModel.isLoading) { isLoading in
                        if isLoading {
                            loadingMessage = defaultLoadingMessage
                        }
                    }
                    .onReceive(timer) { _ in
                        loadingMessage = Constants.loadingMessages.randomElement() ?? defaultLoadingMessage
                    }
            }
            .navigationTitle(Constants.HomeView.homeTitle)
        } detail: {
            // Show a message in the secondary view that tells the user to select a recipe (only visible on wide screens)
            HomeSecondaryView()
        }
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
            HomeView(viewModel: viewModelWithoutLoading)
                .previewDisplayName("No Loading")
            HomeView(viewModel: viewModelWithLoading)
                .previewDisplayName("Loading")
            HomeView(viewModel: viewModelWithAlert)
                .previewDisplayName("Alert")
        }
    }
}
