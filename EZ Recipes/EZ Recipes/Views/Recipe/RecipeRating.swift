//
//  RecipeRating.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 4/13/25.
//

import SwiftUI

struct RecipeRating: View {
    var averageRating: Double?
    var totalRatings: Int
    var myRating: Int? = nil
    var enabled = true
    var onRate: (Int) -> Void = { _ in }
    
    private func starIcon(for i: Int) -> String {
        // If the user has rated the recipe, show their rating instead of the average
        // If there are no ratings, show all empty stars
        var starRating: Double = 0
        if let myRating {
            starRating = Double(myRating)
        } else if let averageRating {
            starRating = averageRating
        }
        let stars = Int(starRating.round()) ?? 0
        
        if i < stars || (i == stars && starRating >= Double(stars)) {
            return "star.fill"
        } else if i == stars && starRating < Double(stars) {
            return "star.leadinghalf.filled"
        } else {
            return "star"
        }
    }
    
    private func ratingLabel() -> String {
        return if let myRating {
            Constants.RecipeView.starRatingUser(myRating)
        } else if let averageRating {
            Constants.RecipeView.starRatingAverage(averageRating)
        } else {
            Constants.RecipeView.starRatingNone
        }
    }
    
    var body: some View {
        HStack {
            ForEach(1...5, id: \.self) { i in
                Button {
                    onRate(i)
                } label: {
                    Image(systemName: starIcon(for: i))
                        .tint(myRating != nil ? .orange : .yellow)
                }
                .disabled(!enabled)
                .accessibilityLabel(Constants.RecipeView.starRatingInput(i))
            }
            
            if let averageRating {
                Text("(\(averageRating.round(to: 1))/5, \(Constants.RecipeView.totalRatings(totalRatings)))")
            } else {
                Text("(\(Constants.RecipeView.totalRatings(totalRatings)))")
            }
        }
        .accessibilityLabel(ratingLabel())
    }
}

#Preview("No ratings") {
    RecipeRating(averageRating: nil, totalRatings: 0)
}

#Preview("Disabled") {
    RecipeRating(averageRating: nil, totalRatings: 0, enabled: false)
}

#Preview("5 stars, 1 rating") {
    RecipeRating(averageRating: 5, totalRatings: 1)
}

#Preview("4.1 stars, 1934 ratings") {
    RecipeRating(averageRating: 4.1, totalRatings: 1934)
}

#Preview("2.5 stars, 10 ratings") {
    RecipeRating(averageRating: 2.5, totalRatings: 10)
}

#Preview("3.625 stars, 582 ratings") {
    RecipeRating(averageRating: 3.625, totalRatings: 582)
}

#Preview("My rating") {
    RecipeRating(averageRating: 1, totalRatings: 8, myRating: 3)
}
