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
    @Bindable var homeViewModel: HomeViewModel
    var profileViewModel: ProfileViewModel
    @State var expandAccordions = false
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
        let isLoggedIn = profileViewModel.authState == .authenticated
        
        NavigationSplitView {
            ScrollView {
                VStack {
                    Button {
                        Task {
                            await homeViewModel.getRandomRecipe()
                        }
                    } label: {
                        Text(Constants.HomeView.findRecipeButton)
                            .foregroundStyle(homeViewModel.isLoading ? Color.primary : .black)
                            .font(.system(size: 22))
                    }
                    .padding(.top)
                    .buttonStyle(.borderedProminent)
                    .tint(.yellow)
                    // Prevent users from spamming the button
                    .disabled(homeViewModel.isLoading)
                    // Show an alert if the request failed
                    // recipeError shouldn't be nil if recipeFailedToLoad is true
                    .errorAlert(isPresented: $homeViewModel.recipeFailedToLoad, message: homeViewModel.recipeError?.error)
                    
                    // Show a spinner while the network request is loading
                    // Use opacity instead of an if statement so the button doesn't jump when pressed
                    ProgressView()
                        .opacity(homeViewModel.isLoading ? 1 : 0)
                    Text(loadingMessage)
                        .opacity(homeViewModel.isLoading ? 1 : 0)
                        .onChange(of: homeViewModel.isLoading) {
                            if homeViewModel.isLoading {
                                loadingMessage = defaultLoadingMessage
                            }
                        }
                        .onReceive(timer) { _ in
                            loadingMessage = Constants.loadingMessages.randomElement() ?? defaultLoadingMessage
                        }
                    
                    // Saved recipes
                    HomeAccordions(homeViewModel: homeViewModel, profileViewModel: profileViewModel, expandAccordions: expandAccordions)
                }
            }
            .navigationTitle(Constants.HomeView.homeTitle)
            // Show the recipe view once the recipe loads in the ViewModel
            .navigationDestination(isPresented: $homeViewModel.isRecipeLoaded) {
                RecipeView(homeViewModel: homeViewModel, profileViewModel: profileViewModel)
            }
        } detail: {
            // Show a message in the secondary view that tells the user to select a recipe (only visible on wide screens)
            HomeSecondaryView()
        }
        .onAppear {
            // Avoid presenting a review immediately on launch
            if homeViewModel.isFirstPrompt {
                homeViewModel.isFirstPrompt = false
                return
            }
            
            // If the user viewed enough recipes, ask for a review
            // Only ask once per app version to avoid intimidating the user and quickly reaching the 3-prompt limit
            if recipesViewed >= Constants.recipesToPresentReview && currentAppVersion != lastVersionPromptedForReview {
                presentReview()
                
                lastVersionPromptedForReview = currentAppVersion
            }
        }
        .task {
            if !isLoggedIn {
                await profileViewModel.getChef()
            }
        }
    }
}

// Show previews of the HomeView with and without the spinner or an alert box
// Expand the accordions by default to make it easier to distinguish each preview
@MainActor
private func setupPreview(isLoading: Bool = false, showAlert: Bool = false, recentRecipes: [Recipe] = [], authState: AuthState = .unauthenticated, expandAccordions: Bool = true) -> some View {
    var mockRepo = NetworkManagerMock.shared
    mockRepo.isSuccess = !showAlert
    
    let swiftData = SwiftDataManager.preview
    let homeViewModel = HomeViewModel(repository: mockRepo, swiftData: swiftData)
    homeViewModel.isLoading = isLoading
    homeViewModel.recentRecipes = recentRecipes.map { recipe in
        RecentRecipe(recipe: recipe)
    }
    
    let profileViewModel = ProfileViewModel(repository: mockRepo, swiftData: swiftData)
    profileViewModel.isLoading = isLoading
    profileViewModel.authState = authState
    profileViewModel.chef = authState == .authenticated ? mockRepo.mockChef : nil
    
    return HomeView(homeViewModel: homeViewModel, profileViewModel: profileViewModel, expandAccordions: expandAccordions)
}

#Preview("Offline Recipes") {
    setupPreview(showAlert: true, recentRecipes: [Constants.Mocks.blueberryYogurt, Constants.Mocks.chocolateCupcake, Constants.Mocks.thaiBasilChicken])
}

#Preview("Authenticated") {
    setupPreview(authState: .authenticated, expandAccordions: false)
}

#Preview("Loading (Auth)") {
    setupPreview(authState: .loading)
}

#Preview("No Loading") {
    setupPreview()
}

#Preview("Loading (Recipe)") {
    setupPreview(isLoading: true)
}

#Preview("Alert") {
    setupPreview(showAlert: true)
}
