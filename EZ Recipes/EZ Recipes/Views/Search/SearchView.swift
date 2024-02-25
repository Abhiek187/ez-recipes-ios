//
//  SearchView.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 2/8/24.
//

import SwiftUI

struct SearchView: View {
    @StateObject var viewModel: SearchViewModel
    
    var body: some View {
        NavigationView {
            FilterForm(viewModel: viewModel)
                .navigationTitle(Constants.SearchView.searchTitle)
            
            SearchSecondaryView()
        }
        .navigationViewStyle(.automatic)
        .onDisappear {
            viewModel.task?.cancel()
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static let mockRepo = NetworkManagerMock.shared
    static let viewModel = SearchViewModel(repository: mockRepo)
    
    static var previews: some View {
        SearchView(viewModel: viewModel)
    }
}
