//
//  HomeView.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 10/22/22.
//

import StoreKit
import SwiftUI

struct HomeView: View {
    // Subscribe to changes in the ObservableObject and automatically update the UI
    @State var viewModel: HomeViewModel
    @State private var recentRecipes: [RecentRecipe] = []
    
    // Don't show any messages initially if the recipe loads quickly
    // " " will allocate space for the loading message so the UI doesn't dynamically shift
    private let defaultLoadingMessage = " "
    @State private var loadingMessage = " "
    private let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    // Up to 3 review prompts can appear every 365 days
    @Environment(\.requestReview) private var requestReview

    // Stored in UserDefaults.standard by default
    @AppStorage(UserDefaultsManager.Keys.recipesViewed) var recipesViewed = 0
    @AppStorage(UserDefaultsManager.Keys.lastVersionPromptedForReview) var lastVersionPromptedForReview = ""
    private let currentAppVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    
    struct ToggleStates {
        var expandFavorites = false
        var expandRecents = false
        var expandRatings = false
    }
    @State private var toggleStates = ToggleStates()
    
    private func presentReview() {
        // Don't show the alert in a UI test
        if !Constants.isUITest {
            Task {
                // Delay for two seconds to avoid interrupting the person using the app
                try await Task.sleep(for: .seconds(2))
                requestReview()
            }
        }
    }
    
    var body: some View {
        NavigationSplitView {
            ScrollView {
                VStack {
                    Button {
                        Task {
                            await viewModel.getRandomRecipe()
                        }
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
                    // recipeError shouldn't be nil if recipeFailedToLoad is true
                    .errorAlert(isPresented: $viewModel.recipeFailedToLoad, message: viewModel.recipeError?.error)
                    
                    // Show a spinner while the network request is loading
                    // Use opacity instead of an if statement so the button doesn't jump when pressed
                    ProgressView()
                        .opacity(viewModel.isLoading ? 1 : 0)
                    Text(loadingMessage)
                        .opacity(viewModel.isLoading ? 1 : 0)
                        .onChange(of: viewModel.isLoading) {
                            if viewModel.isLoading {
                                loadingMessage = defaultLoadingMessage
                            }
                        }
                        .onReceive(timer) { _ in
                            loadingMessage = Constants.loadingMessages.randomElement() ?? defaultLoadingMessage
                        }
                    
                    // Saved recipes
                    VStack {
                        DisclosureGroup(Constants.HomeView.profileFavorites, isExpanded: $toggleStates.expandFavorites) {
                            Text(Constants.HomeView.signInForRecipes)
                        }
                        Divider()
                        DisclosureGroup(Constants.HomeView.profileRecentlyViewed, isExpanded: $toggleStates.expandRecents) {
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(viewModel.recentRecipes, id: \.id) { recentRecipe in
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
                        Divider()
                        DisclosureGroup(Constants.HomeView.profileRatings, isExpanded: $toggleStates.expandRatings) {
                            RecipeCard(recipe: Constants.Mocks.blueberryYogurt)
                                .frame(width: 350)
                                .redacted(reason: .placeholder)
                                .disabled(true)
                        }
                    }
                    .padding()
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
        .onAppear {
            // Avoid presenting a review immediately on launch
            if viewModel.isFirstPrompt {
                viewModel.isFirstPrompt = false
                return
            }
            
            // If the user viewed enough recipes, ask for a review
            // Only ask once per app version to avoid intimidating the user and quickly reaching the 3-prompt limit
            if recipesViewed >= Constants.recipesToPresentReview && currentAppVersion != lastVersionPromptedForReview {
                presentReview()
                
                lastVersionPromptedForReview = currentAppVersion
            }
        }
    }
}

// Show previews of the HomeView with and without the spinner or an alert box
#Preview("No Loading") {
    let repoSuccess = NetworkManagerMock.shared
    let swiftData = SwiftDataManager.preview
    let viewModelWithoutLoading = HomeViewModel(repository: repoSuccess, swiftData: swiftData)
    
    return HomeView(viewModel: viewModelWithoutLoading)
}

#Preview("Loading") {
    let repoSuccess = NetworkManagerMock.shared
    let swiftData = SwiftDataManager.preview
    let viewModelWithLoading = HomeViewModel(repository: repoSuccess, swiftData: swiftData)
    viewModelWithLoading.isLoading = true
    
    return HomeView(viewModel: viewModelWithLoading)
}

#Preview("Alert") {
    var repoFail = NetworkManagerMock.shared
    repoFail.isSuccess = false
    let swiftData = SwiftDataManager.preview
    let viewModelWithAlert = HomeViewModel(repository: repoFail, swiftData: swiftData)
    
    return HomeView(viewModel: viewModelWithAlert)
}
