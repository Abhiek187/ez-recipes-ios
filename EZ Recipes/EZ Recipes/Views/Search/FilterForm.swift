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
    
    @State private var caloriesExceedMax = false
    @State private var caloriesInvalidRange = false
    
    var body: some View {
        Form {
            Section("Query") {
                TextField("food", text: $recipeFilter.query)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)
            }
            Section("Filters") {
                HStack {
                    TextField("0", value: $recipeFilter.minCals, format: .number)
                        .frame(width: 75)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                        .onChange(of: (recipeFilter.minCals ?? 0)) { newValue in
                            withAnimation {
                                caloriesExceedMax = newValue > 2000 || (recipeFilter.maxCals ?? 0) > 2000
                                caloriesInvalidRange = newValue > (recipeFilter.maxCals ?? Int.max)
                            }
                        }
                    Text("≤ Calories ≤")
                    TextField("2000", value: $recipeFilter.maxCals, format: .number)
                        .frame(width: 75)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                        .onChange(of: (recipeFilter.maxCals ?? 0)) { newValue in
                            withAnimation {
                                caloriesExceedMax = newValue > 2000 || (recipeFilter.minCals ?? 0) > 2000
                                caloriesInvalidRange = newValue < (recipeFilter.minCals ?? 0)
                            }
                        }
                    Text("kcal")
                }
                FormError(on: caloriesExceedMax, message: "Error: Calories must be ≤ 2000")
                FormError(on: caloriesInvalidRange, message: "Error: Max calories cannot exceed min calories")
                
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
            .disabled(caloriesExceedMax || caloriesInvalidRange)
        }
    }
}

struct FilterForm_Previews: PreviewProvider {
    static let emptyRecipeFilter = RecipeFilter()
    static var recipeFilterWithMaxError = RecipeFilter()
    static var recipeFilterWithRangeError = RecipeFilter()
    
    static var previews: some View {
        recipeFilterWithMaxError.maxCals = 2001
        recipeFilterWithRangeError.minCals = 200
        recipeFilterWithRangeError.maxCals = 100
        
        return ForEach([1], id: \.self) {_ in
            FilterForm(recipeFilter: .constant(emptyRecipeFilter)) {
                print("Form submitted!")
            }
            .previewDisplayName("Empty")
            
            FilterForm(recipeFilter: .constant(recipeFilterWithMaxError)) {}
                .previewDisplayName("Max Error")
            
            FilterForm(recipeFilter: .constant(recipeFilterWithRangeError)) {}
                .previewDisplayName("Range Error")
        }
    }
}
