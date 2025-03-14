//
//  SubmitButton.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 2/24/24.
//

import SwiftUI

struct SubmitButton: View {
    @Bindable var viewModel: SearchViewModel
    
    // Don't take up additional space when hidden
    private let defaultLoadingMessage = ""
    @State private var loadingMessage = ""
    private let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            HStack {
                Button(Constants.SearchView.applyButton) {
                    Task {
                        await viewModel.searchRecipes()
                    }
                }
                .disabled(viewModel.isLoading)
                .alert(Constants.errorTitle, isPresented: $viewModel.recipeFailedToLoad) {
                    Button(Constants.okButton, role: .cancel) {}
                } message: {
                    Text(viewModel.recipeError?.error ?? Constants.unknownError)
                }
                .padding(.trailing)
                
                ProgressView()
                    .opacity(viewModel.isLoading ? 1 : 0)
                Spacer()
            }
            if viewModel.isLoading {
                Text(loadingMessage)
                    .multilineTextAlignment(.leading)
                    .padding(.top, 1)
                    .onChange(of: viewModel.isLoading) {
                        if viewModel.isLoading {
                            loadingMessage = defaultLoadingMessage
                        }
                    }
                    .onReceive(timer) { _ in
                        loadingMessage = Constants.loadingMessages.randomElement() ?? defaultLoadingMessage
                    }
            }
        }
    }
}

#Preview("No Loading") {
    let repoSuccess = NetworkManagerMock.shared
    let viewModelWithoutLoading = SearchViewModel(repository: repoSuccess)
    
    return SubmitButton(viewModel: viewModelWithoutLoading)
        .padding()
}

#Preview("Loading") {
    let repoSuccess = NetworkManagerMock.shared
    let viewModelWithLoading = SearchViewModel(repository: repoSuccess)
    viewModelWithLoading.isLoading = true
    
    return SubmitButton(viewModel: viewModelWithLoading)
        .padding()
}

#Preview("Alert") {
    var repoFail = NetworkManagerMock.shared
    repoFail.isSuccess = false
    let viewModelWithAlert = SearchViewModel(repository: repoFail)
    
    return SubmitButton(viewModel: viewModelWithAlert)
        .padding()
}
