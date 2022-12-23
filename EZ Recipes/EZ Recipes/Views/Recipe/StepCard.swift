//
//  StepCard.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 12/23/22.
//

import SwiftUI

struct StepCard: View {
    @State var recipe: Recipe
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .card(width: 300)
    }
}

struct StepCard_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(Device.all, id: \.self) { device in
            StepCard(recipe: Constants.Mocks.mockRecipe)
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }
    }
}
