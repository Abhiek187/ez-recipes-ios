//
//  GlossaryView.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 5/30/24.
//

import SwiftUI

struct GlossaryView: View {
    var viewModel: HomeViewModel
    // Update the terms list when switching tabs
    @State var terms = UserDefaultsManager.getTerms()
    
    var sortedTerms: [Term]? {
        terms?.sorted(by: {
            // Sort all the terms alphabetically for ease of reference
            $0.word < $1.word
        })
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoadingTerms {
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
        .onChange(of: viewModel.isLoadingTerms) {
            terms = UserDefaultsManager.getTerms()
        }
        .task {
            if terms?.isEmpty != false {
                await viewModel.checkCachedTerms()
            } else if let terms {
                try? await SpotlightManager.donateTerms(terms)
            }
        }
    }
}

#Preview("No Loading") {
    let mockRepo = NetworkManagerMock.shared
    let swiftData = SwiftDataManager.preview
    let homeViewModel = HomeViewModel(repository: mockRepo, swiftData: swiftData)
    
    UserDefaultsManager.saveTerms(terms: Constants.Mocks.terms)
    
    return GlossaryView(viewModel: homeViewModel)
}

#Preview("Loading") {
    let mockRepo = NetworkManagerMock.shared
    let swiftData = SwiftDataManager.preview
    let homeViewModel = HomeViewModel(repository: mockRepo, swiftData: swiftData)
    homeViewModel.isLoadingTerms = true
    
    return GlossaryView(viewModel: homeViewModel)
}
