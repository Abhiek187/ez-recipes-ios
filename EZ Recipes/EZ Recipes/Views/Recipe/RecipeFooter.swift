//
//  RecipeFooter.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 12/4/22.
//

import SwiftUI

struct RecipeFooter: View {
    var body: some View {
        // Attribution to spoonacular
        Text(Constants.RecipeView.attribution)
            .font(.footnote)
            .padding(.bottom)
    }
}

#Preview {
    RecipeFooter()
}
