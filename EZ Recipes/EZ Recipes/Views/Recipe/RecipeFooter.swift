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
        Text(Constants.Strings.attribution)
            .font(.footnote)
            .padding(.bottom)
    }
}

struct RecipeFooter_Previews: PreviewProvider {
    static var previews: some View {
        RecipeFooter()
    }
}
