//
//  RecipeHeader.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 12/4/22.
//

import SwiftUI

// Workaround since ternaries must be of the same type
private extension Button {
    /// Make the backgrounds of buttons more opaque in light mode than in dark mode
    @ViewBuilder
    func buttonStyle(for colorScheme: ColorScheme) -> some View {
        switch colorScheme {
        case .light:
            buttonStyle(.borderedProminent)
        case .dark:
            buttonStyle(.bordered)
        @unknown default:
            buttonStyle(.borderedProminent)
        }
    }
}

struct RecipeHeader: View {
    @Binding var recipe: Recipe
    @Binding var isLoading: Bool
    var onFindRecipeButtonTapped: () -> Void // callback to pass to the parent View
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 16) {
            // Recipe name and link
            VStack {
                Text(recipe.name.capitalized)
                    .font(.title)
                    .padding([.leading, .trailing])
                
                if let url = URL(string: recipe.url) {
                    Link(destination: url) {
                        Label(Constants.Strings.recipeLinkAlt, systemImage: "link")
                    }
                }
            }
            
            // Recipe image and caption
            VStack {
                AsyncImage(url: URL(string: recipe.image))
                    .frame(width: 312, height: 231)
                
                if let credit = recipe.credit {
                    // Add a clickable link to the image source
                    // Take up as many lines as needed
                    Text(Constants.Strings.imageCopyright(credit, recipe.sourceUrl))
                        .font(.caption)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            
            // Recipe time and buttons
            VStack {
                Text(Constants.Strings.recipeTime(recipe.time))
                    .font(.system(size: 20))
                
                HStack {
                    Button {
                        print("Nice! Hope it was tasty!")
                    } label: {
                        Label(Constants.Strings.madeButton, systemImage: "tuningfork") // TODO: find a food icon outside of SFSymbols
                    }
                    .buttonStyle(for: colorScheme)
                    .tint(.red)
                    
                    Button {
                        onFindRecipeButtonTapped()
                    } label: {
                        Label(Constants.Strings.showRecipeButton, systemImage: "text.book.closed")
                    }
                    .buttonStyle(for: colorScheme)
                    .tint(.yellow)
                    .foregroundColor(colorScheme == .light ? .black : .yellow)
                    .disabled(isLoading)
                }
            }
            
            if isLoading {
                ProgressView()
            }
        }
    }
}

struct RecipeHeader_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(Device.all, id: \.self) { device in
            RecipeHeader(recipe: .constant(Constants.Mocks.blueberryYogurt), isLoading: .constant(false)) {}
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName("\(device) (No Loading)")
            
            RecipeHeader(recipe: .constant(Constants.Mocks.blueberryYogurt), isLoading: .constant(true)) {}
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName("\(device) (Loading)")
        }
    }
}
