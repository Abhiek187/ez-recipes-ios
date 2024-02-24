//
//  SubmitButton.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 2/24/24.
//

import SwiftUI

struct SubmitButton: View {
    @ObservedObject var viewModel: SearchViewModel
    var isDisabled: Bool
    
    // Don't take up additional space when hidden
    private let defaultLoadingMessage = ""
    @State private var loadingMessage = ""
    private let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            HStack {
                Button(Constants.SearchView.submitButton) {
                    viewModel.searchRecipes()
                }
                .disabled(isDisabled)
                .alert(Constants.errorTitle, isPresented: $viewModel.recipeFailedToLoad) {
                    Button(Constants.okButton, role: .cancel) {}
                } message: {
                    Text(viewModel.recipeError?.error ?? Constants.unknownError)
                }
                .padding(.trailing)
                
                ProgressView()
                    .opacity(viewModel.isLoading ? 1 : 0)
            }
            if viewModel.isLoading {
                Text(loadingMessage)
                    .onChange(of: viewModel.isLoading) { isLoading in
                        if isLoading {
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
    
    struct BindingTestHolder: View {
        @State var viewModel: SearchViewModel
        @State var isDisabled: Bool
        
        var body: some View {
            SubmitButton(viewModel: viewModel, isDisabled: isDisabled)
                .border(.primary)
        }
    }
    
    static var previews: some View {
        viewModelWithLoading.isLoading = true
        repoFail.isSuccess = false
        
        return ForEach([1], id: \.self) { _ in
            BindingTestHolder(viewModel: viewModelWithoutLoading, isDisabled: false)
                .previewDisplayName("No Loading")
            BindingTestHolder(viewModel: viewModelWithLoading, isDisabled: true)
                .previewDisplayName("Loading")
            BindingTestHolder(viewModel: viewModelWithAlert, isDisabled: false)
                .previewDisplayName("Alert")
        }
    }
}
