//
//  GlossaryView.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 5/30/24.
//

import SwiftUI

struct GlossaryView: View {
    var viewModel: GlossaryViewModel
    
    // Update the terms list when switching tabs
    var sortedTerms: [Term]? {
        viewModel.terms?.sorted(by: {
            // Sort all the terms alphabetically for ease of reference
            $0.word < $1.word
        })
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    // Show that the terms are loading
                    ProgressView()
                } else if let sortedTerms {
                    List(sortedTerms, id: \._id) { term in
                        Text("**\(term.word)** — \(term.definition)")
                    }
                }
            }
            .navigationTitle(Constants.Tabs.glossaryTitle)
        }
        .task {
            if viewModel.terms?.isEmpty != false {
                await viewModel.checkCachedTerms()
            } else if let terms = viewModel.terms {
                try? await SpotlightManager.donateTerms(terms)
            }
        }
    }
}

#Preview("No Loading") {
    let mockRepo = NetworkManagerMock.shared
    let homeViewModel = GlossaryViewModel(repository: mockRepo)
    
    UserDefaultsManager.saveTerms(terms: Constants.Mocks.terms)
    
    return GlossaryView(viewModel: homeViewModel)
}

#Preview("Loading") {
    let mockRepo = NetworkManagerMock.shared
    let homeViewModel = GlossaryViewModel(repository: mockRepo)
    homeViewModel.isLoading = true
    
    return GlossaryView(viewModel: homeViewModel)
}
