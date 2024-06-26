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
        NavigationSplitView {
            FilterForm(viewModel: viewModel)
                .navigationTitle(Constants.SearchView.searchTitle)
        } detail: {
            NavigationStack {
                SearchSecondaryView()
            }
        }
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
