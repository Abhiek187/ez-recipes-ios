//
//  GlossaryView.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 5/30/24.
//

import SwiftUI

struct GlossaryView: View {
    var body: some View {
        NavigationStack {
            if let terms = UserDefaultsManager.getTerms()?.sorted(by: {
                // Sort all the terms alphabetically for ease of reference
                $0.word < $1.word
            }) {
                List(terms, id: \._id) { term in
                    Text("**\(term.word)** — \(term.definition)")
                }
                // Prevent the list from overlapping the status bar
                .navigationTitle(Constants.GlossaryView.glossaryTitle)
            }
        }
    }
}

struct GlossaryView_Previews: PreviewProvider {
    static var previews: some View {
        UserDefaultsManager.saveTerms(terms: Constants.Mocks.terms)
        
        return GlossaryView()
    }
}
