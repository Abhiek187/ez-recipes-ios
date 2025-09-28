//
//  SearchView.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 2/8/24.
//

import SwiftUI

struct SearchView: View {
    var viewModel: SearchViewModel
    
    var body: some View {
        NavigationSplitView {
            FilterForm(viewModel: viewModel)
                .navigationTitle(Constants.Tabs.searchTitle)
        } detail: {
            NavigationStack {
                SearchSecondaryView()
            }
        }
    }
}

#Preview {
    let mockRepo = NetworkManagerMock.shared
    let viewModel = SearchViewModel(repository: mockRepo)
    
    return SearchView(viewModel: viewModel)
}
