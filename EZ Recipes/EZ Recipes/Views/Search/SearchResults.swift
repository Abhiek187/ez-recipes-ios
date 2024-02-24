//
//  SearchResults.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 2/9/24.
//

import SwiftUI

struct SearchResults: View {
    var recipes: [Recipe]
    
    let columns = [
        GridItem(.adaptive(minimum: 350), alignment: .top)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, alignment: .center, spacing: 8) {
                ForEach(recipes, id: \.id) { recipe in
                    NavigationLink(destination: EmptyView()) {
                        RecipeCard(recipe: recipe)
                    }
                    // Don't make all the text the accent color
                    .buttonStyle(.plain)
                }
            }
        }
        .navigationTitle(Constants.SearchView.resultsTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SearchResults_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SearchResults(recipes: [
                Constants.Mocks.blueberryYogurt,
                Constants.Mocks.chocolateCupcake,
                Constants.Mocks.thaiBasilChicken
            ])
        }
    }
}
