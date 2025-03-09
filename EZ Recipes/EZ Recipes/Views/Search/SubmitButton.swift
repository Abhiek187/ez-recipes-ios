//
//  SubmitButton.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 2/24/24.
//

import SwiftUI

struct SubmitButton: View {
    @ObservedObject var viewModel: SearchViewModel
    
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

struct SubmitButton_Previews: PreviewProvider {
    static let repoSuccess = NetworkManagerMock.shared
    static var repoFail = NetworkManagerMock.shared
    
    static let viewModelWithoutLoading = SearchViewModel(repository: repoSuccess)
    static let viewModelWithLoading = SearchViewModel(repository: repoSuccess)
    static let viewModelWithAlert = SearchViewModel(repository: repoFail)
    
    static var previews: some View {
        viewModelWithLoading.isLoading = true
        repoFail.isSuccess = false
        
        return ForEach([1], id: \.self) { _ in
            SubmitButton(viewModel: viewModelWithoutLoading)
                .previewDisplayName("No Loading")
                .padding()
            SubmitButton(viewModel: viewModelWithLoading)
                .previewDisplayName("Loading")
                .padding()
            SubmitButton(viewModel: viewModelWithAlert)
                .previewDisplayName("Alert")
                .padding()
        }
    }
}
