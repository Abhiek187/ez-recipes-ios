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
    
    // Load all recent recipes from Core Data by timestamp
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \RecentRecipe.timestamp, ascending: false)],
        animation: .default)
    private var recentRecipes: FetchedResults<RecentRecipe>
    
    // Don't show any messages initially if the recipe loads quickly
    // " " will allocate space for the loading message so the UI doesn't dynamically shift
    private let defaultLoadingMessage = " "
    @State private var loadingMessage = " "
    private let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationSplitView {
            ScrollView {
                VStack {
                    Button {
                        viewModel.getRandomRecipe()
                    } label: {
                        Text(Constants.HomeView.findRecipeButton)
                            .foregroundStyle(viewModel.isLoading ? Color.primary : .black)
                            .font(.system(size: 22))
                    }
                    .padding(.top)
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
                    
                    // Recently viewed recipes
                    if recentRecipes.count > 0 {
                        Text(Constants.HomeView.recentlyViewed)
                            .font(.title)
                        Divider()
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(recentRecipes, id: \.id) { recentRecipe in
                                    if let recipe: Recipe = recentRecipe.recipe.decode() {
                                        RecipeCard(recipe: recipe)
                                            .frame(width: 350)
                                            .simultaneousGesture(TapGesture().onEnded {
                                                // Show the recipe cards animating to the right position after tapping them
                                                withAnimation {
                                                    viewModel.setRecipe(recipe)
                                                }
                                            })
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle(Constants.HomeView.homeTitle)
            // Show the recipe view once the recipe loads in the ViewModel
            .navigationDestination(isPresented: $viewModel.isRecipeLoaded) {
                RecipeView(viewModel: viewModel)
            }
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
    static let coreData = CoreDataManager.preview
    
    static let viewModelWithoutLoading = HomeViewModel(repository: repoSuccess, coreData: coreData)
    static let viewModelWithLoading = HomeViewModel(repository: repoSuccess, coreData: coreData)
    static let viewModelWithAlert = HomeViewModel(repository: repoFail, coreData: coreData)
    
    static let managedObjectContext = CoreDataManager.preview.container.viewContext
    
    static var previews: some View {
        viewModelWithLoading.isLoading = true
        repoFail.isSuccess = false
        
        return ForEach([1], id: \.self) {_ in
            HomeView(viewModel: viewModelWithoutLoading)
                .previewDisplayName("No Loading")
                .environment(\.managedObjectContext, managedObjectContext)
            HomeView(viewModel: viewModelWithLoading)
                .previewDisplayName("Loading")
                .environment(\.managedObjectContext, managedObjectContext)
            HomeView(viewModel: viewModelWithAlert)
                .previewDisplayName("Alert")
                .environment(\.managedObjectContext, managedObjectContext)
        }
    }
}
