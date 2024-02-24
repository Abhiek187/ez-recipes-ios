//
//  SearchView.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 2/8/24.
//

import SwiftUI

struct SearchView: View {
    @StateObject var viewModel: SearchViewModel
    
    @State private var loadingMessage = " "
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: SearchResults(recipes: viewModel.recipes), isActive: $viewModel.isRecipeLoaded) {
                    FilterForm(recipeFilter: $viewModel.recipeFilter) {
                        viewModel.searchRecipes()
                    }
                    .disabled(viewModel.isLoading)
                    .alert(Constants.errorTitle, isPresented: $viewModel.recipeFailedToLoad) {
                        Button(Constants.okButton, role: .cancel) {}
                    } message: {
                        Text(viewModel.recipeError?.error ?? Constants.unknownError)
                    }
                }
                
                ProgressView()
                    .opacity(viewModel.isLoading ? 1 : 0)
                Text(loadingMessage)
                    .opacity(viewModel.isLoading ? 1 : 0)
                    .onChange(of: viewModel.isLoading) { isLoading in
                        if isLoading {
                            loadingMessage = " "
                        }
                    }
                    .onReceive(timer) { _ in
                        loadingMessage = Constants.loadingMessages.randomElement() ?? " "
                    }
            }
            .navigationTitle(Constants.SearchView.searchTitle)
        }
        .navigationViewStyle(.automatic)
        .onDisappear {
            viewModel.task?.cancel()
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static let repoSuccess = NetworkManagerMock.shared
    static var repoFail = NetworkManagerMock.shared
    
    static let viewModelWithoutLoading = SearchViewModel(repository: repoSuccess)
    static let viewModelWithLoading = SearchViewModel(repository: repoSuccess)
    static let viewModelWithAlert = SearchViewModel(repository: repoFail)
    
    static var previews: some View {
        viewModelWithLoading.isLoading = true
        repoFail.isSuccess = false
        
        return ForEach([1], id: \.self) { _ in
            SearchView(viewModel: viewModelWithoutLoading)
                .previewDisplayName("No Loading")
            SearchView(viewModel: viewModelWithLoading)
                .previewDisplayName("Loading")
            SearchView(viewModel: viewModelWithAlert)
                .previewDisplayName("Alert")
        }
    }
}
