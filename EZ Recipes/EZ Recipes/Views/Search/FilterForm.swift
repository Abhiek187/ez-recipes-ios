//
//  FilterForm.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 2/9/24.
//

import SwiftUI
import MultiPicker

struct FilterForm: View {
    @Binding var recipeFilter: RecipeFilter
    var onSubmit: () -> Void
    
    @State private var caloriesExceedMax = false
    @State private var caloriesInvalidRange = false
    
    private let MIN_CALS = Constants.SearchView.minCals
    private let MAX_CALS = Constants.SearchView.maxCals
    
    var body: some View {
        Form {
            Section(Constants.SearchView.querySection) {
                TextField(Constants.SearchView.queryPlaceholder, text: $recipeFilter.query)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)
            }
            Section(Constants.SearchView.filterSection) {
                HStack {
                    TextField(String(MIN_CALS), value: $recipeFilter.minCals, format: .number)
                        .frame(width: 75)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                        .onChange(of: (recipeFilter.minCals ?? MIN_CALS)) { newValue in
                            withAnimation {
                                caloriesExceedMax = newValue > MAX_CALS || (recipeFilter.maxCals ?? MIN_CALS) > MAX_CALS
                                caloriesInvalidRange = newValue > (recipeFilter.maxCals ?? Int.max)
                            }
                        }
                    Text(Constants.SearchView.calorieLabel)
                    TextField(String(MAX_CALS), value: $recipeFilter.maxCals, format: .number)
                        .frame(width: 75)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                        .onChange(of: (recipeFilter.maxCals ?? MIN_CALS)) { newValue in
                            withAnimation {
                                caloriesExceedMax = newValue > MAX_CALS || (recipeFilter.minCals ?? MIN_CALS) > MAX_CALS
                                caloriesInvalidRange = newValue < (recipeFilter.minCals ?? MIN_CALS)
                            }
                        }
                    Text(Constants.SearchView.calorieUnit)
                }
                FormError(on: caloriesExceedMax, message: Constants.SearchView.calorieExceedMaxError)
                FormError(on: caloriesInvalidRange, message: Constants.SearchView.calorieInvalidRangeError)
                
                Toggle(Constants.SearchView.vegetarianLabel, isOn: $recipeFilter.vegetarian)
                Toggle(Constants.SearchView.veganLabel, isOn: $recipeFilter.vegan)
                Toggle(Constants.SearchView.glutenFreeLabel, isOn: $recipeFilter.glutenFree)
                Toggle(Constants.SearchView.healthyLabel, isOn: $recipeFilter.healthy)
                Toggle(Constants.SearchView.cheapLabel, isOn: $recipeFilter.cheap)
                Toggle(Constants.SearchView.sustainableLabel, isOn: $recipeFilter.sustainable)
                
                MultiPicker(Constants.SearchView.spiceLabel, selection: $recipeFilter.spiceLevel) {
                    ForEach(SpiceLevel.allCases, id: \.rawValue) { spiceLevel in
                        // Don't filter by unknown
                        if spiceLevel != .unknown {
                            Text(spiceLevel.rawValue)
                                .mpTag(spiceLevel.rawValue)
                        }
                    }
                }
                .mpPickerStyle(.navigationLink)
                MultiPicker(Constants.SearchView.typeLabel, selection: $recipeFilter.type) {
                    ForEach(MealType.allCases, id: \.rawValue) { mealType in
                        Text(mealType.rawValue)
                            .mpTag(mealType.rawValue)
                    }
                }
                .mpPickerStyle(.navigationLink)
                MultiPicker(Constants.SearchView.cultureLabel, selection: $recipeFilter.culture) {
                    ForEach(Cuisine.allCases, id: \.rawValue) { cuisine in
                        Text(cuisine.rawValue)
                            .mpTag(cuisine.rawValue)
                    }
                }
                .mpPickerStyle(.navigationLink)
            }
            Button(Constants.SearchView.submitButton) {
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
    
    // Allow the recipe filter to be mutated in the preview
    struct BindingTestHolder: View {
        @State var recipeFilter: RecipeFilter
        
        var body: some View {
            NavigationView {
                FilterForm(recipeFilter: $recipeFilter) {
                    print("Recipe filter: \(recipeFilter)")
                }
            }
        }
    }
    
    static var previews: some View {
        recipeFilterWithMaxError.maxCals = 2001
        recipeFilterWithRangeError.minCals = 200
        recipeFilterWithRangeError.maxCals = 100
        
        return ForEach([1], id: \.self) {_ in
            BindingTestHolder(recipeFilter: emptyRecipeFilter)
                .previewDisplayName("Empty")
            
            BindingTestHolder(recipeFilter: recipeFilterWithMaxError)
                .previewDisplayName("Max Error")
            
            BindingTestHolder(recipeFilter: recipeFilterWithRangeError)
                .previewDisplayName("Range Error")
        }
    }
}
