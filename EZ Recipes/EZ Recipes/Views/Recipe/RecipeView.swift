//
//  RecipeView.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 11/13/22.
//

import SwiftUI

struct RecipeView: View {
    @EnvironmentObject private var viewModel: HomeViewModel
    @State var isFavorite = false
    @State var shareText: ShareText?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                if let recipe = viewModel.recipe {
                    RecipeHeader(recipe: recipe)
                    NutritionLabel(recipe: recipe)
                    SummaryBox(recipe: recipe)
                    IngredientsList(recipe: recipe)
                    InstructionsList(recipe: recipe)
                    
                    Divider()
                    
                    RecipeFooter()
                } else {
                    Text(Constants.Strings.noRecipe) // shouldn't be seen normally
                }
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        .navigationTitle(Constants.Strings.recipeTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            // Buttons on the top right of the screen
            ToolbarItemGroup {
                Button {
                    isFavorite.toggle()
                } label: {
                    // Add alt text to the system image
                    Label(isFavorite ? Constants.Strings.unFavoriteAlt : Constants.Strings.favoriteAlt, systemImage: isFavorite ? "heart.fill" : "heart")
                }
                if #available(iOS 16.0, *) {
                    ShareLink(item: Constants.Strings.shareBody)
                } else {
                    // Fallback on earlier versions
                    Button {
                        shareText = ShareText(text: Constants.Strings.shareBody)
                    } label: {
                        Label(Constants.Strings.shareAlt, systemImage: "square.and.arrow.up")
                    }
                }
            }
        }
        .sheet(item: $shareText) { shareText in
            ActivityView(text: shareText.text)
        }
    }
}

struct RecipeView_Previews: PreviewProvider {
    static let mockNetworkManager = NetworkManagerMock.shared
    static let viewModel = HomeViewModel(repository: mockNetworkManager)
    
    static var previews: some View {
        viewModel.getRandomRecipe()
        
        // The preview device and display name don't work when wrapped in a NavigationView (might be a bug)
        return ForEach(Device.all, id: \.self) { device in
            NavigationView {
                RecipeView()
                    .previewDevice(PreviewDevice(rawValue: device))
                    .previewDisplayName(device)
                    .environmentObject(viewModel)
            }
        }
    }
}
