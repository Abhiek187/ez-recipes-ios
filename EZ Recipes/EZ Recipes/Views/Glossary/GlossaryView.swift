//
//  GlossaryView.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 5/30/24.
//

import SwiftUI

struct GlossaryView: View {
    @State var terms = UserDefaultsManager.getTerms()?.sorted(by: {
        // Sort all the terms alphabetically for ease of reference
        $0.word < $1.word
    })
    
    var body: some View {
        NavigationStack {
            Group {
                if let terms {
                    List(terms, id: \._id) { term in
                        Text("**\(term.word)** — \(term.definition)")
                    }
                } else {
                    // Show that the terms are loading
                    ProgressView()
                }
            }
            .navigationTitle(Constants.Tabs.glossaryTitle)
        }
        .onAppear {
            // Update the terms list when switching tabs
            terms = UserDefaultsManager.getTerms()?.sorted {
                $0.word < $1.word
            }
        }
    }
}

#Preview {
    UserDefaultsManager.saveTerms(terms: Constants.Mocks.terms)
    
    return GlossaryView()
}
