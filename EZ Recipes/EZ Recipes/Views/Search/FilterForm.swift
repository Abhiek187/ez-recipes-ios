//
//  FilterForm.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 2/9/24.
//

import SwiftUI

struct FilterForm: View {
    @Binding var recipeFilter: RecipeFilter
    var onSubmit: () -> Void
    
    var body: some View {
        Form {
            Section("Query") {
                TextField("food", text: $recipeFilter.query)
                    .textFieldStyle(.roundedBorder)
            }
            Section("Filters") {
                HStack {
                    TextField("0", value: $recipeFilter.minCals, format: .number)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                    Text("≤ Calories ≤")
                    TextField("2000", value: $recipeFilter.maxCals, format: .number)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                    Text("kcal")
                }
                Toggle("Vegetarian", isOn: $recipeFilter.vegetarian)
                Toggle("Vegan", isOn: $recipeFilter.vegan)
                Toggle("Gluten-Free", isOn: $recipeFilter.glutenFree)
                Toggle("Healthy", isOn: $recipeFilter.healthy)
                Toggle("Cheap", isOn: $recipeFilter.cheap)
                Toggle("Sustainable", isOn: $recipeFilter.sustainable)
                Picker("Spice Level", selection: $recipeFilter.spiceLevel) {
                    ForEach(SpiceLevel.allCases, id: \.rawValue) { spiceLevel in
                        // Don't filter by unknown
                        if spiceLevel != .unknown {
                            Text(spiceLevel.rawValue)
                        }
                    }
                }
                Picker("Meal Type", selection: $recipeFilter.type) {
                    ForEach(MealType.allCases, id: \.rawValue) { mealType in
                        Text(mealType.rawValue)
                    }
                }
                Picker("Cuisine", selection: $recipeFilter.culture) {
                    ForEach(Cuisine.allCases, id: \.rawValue) { cuisine in
                        Text(cuisine.rawValue)
                    }
                }
            }
            Button("Apply") {
                onSubmit()
            }
        }
    }
}

struct FilterForm_Previews: PreviewProvider {
    static var previews: some View {
        FilterForm(recipeFilter: .constant(RecipeFilter())) {
            print("Form submitted!")
        }
    }
}
