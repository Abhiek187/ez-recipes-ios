//
//  FilterForm.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 2/9/24.
//

import SwiftUI
import MultiPicker

struct FilterForm: View {
    // Focusable fields in form order
    enum Field: CaseIterable {
        case query
        case minCals
        case maxCals
    }
    
    @Binding var recipeFilter: RecipeFilter
    var onSubmit: () -> Void
    
    @FocusState private var focusedField: Field?
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
                    .focused($focusedField, equals: .query)
            }
            Section(Constants.SearchView.filterSection) {
                HStack {
                    Spacer()
                    TextField(String(MIN_CALS), value: $recipeFilter.minCals, format: .number)
                        .frame(width: 75)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                        .focused($focusedField, equals: .minCals)
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
                        .focused($focusedField, equals: .maxCals)
                        .onChange(of: (recipeFilter.maxCals ?? Int.max)) { newValue in
                            withAnimation {
                                caloriesExceedMax = newValue != Int.max && newValue > MAX_CALS || (recipeFilter.minCals ?? MIN_CALS) > MAX_CALS
                                caloriesInvalidRange = newValue < (recipeFilter.minCals ?? MIN_CALS)
                            }
                        }
                    Text(Constants.SearchView.calorieUnit)
                    Spacer()
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
                    ForEach(MealType.allCases.sorted(), id: \.rawValue) { mealType in
                        if mealType != .unknown {
                            Text(mealType.rawValue)
                                .mpTag(mealType.rawValue)
                        }
                    }
                }
                .mpPickerStyle(.navigationLink)
                MultiPicker(Constants.SearchView.cultureLabel, selection: $recipeFilter.culture) {
                    ForEach(Cuisine.allCases.sorted(), id: \.rawValue) { cuisine in
                        if cuisine != .unknown {
                            Text(cuisine.rawValue)
                                .mpTag(cuisine.rawValue)
                        }
                    }
                }
                .mpPickerStyle(.navigationLink)
            }
            Button(Constants.SearchView.submitButton) {
                onSubmit()
            }
            .disabled(caloriesExceedMax || caloriesInvalidRange)
        }
        .toolbar {
            // Add buttons above the keyboard for ease of navigation
            ToolbarItem(placement: .keyboard) {
                HStack {
                    Button(Constants.KeyboardNavigation.previous, systemImage: "chevron.up") {
                        focusedField = focusedField?.previous()
                    }
                    .disabled(focusedField?.isFirst != false)
                    Button(Constants.KeyboardNavigation.next, systemImage: "chevron.down") {
                        focusedField = focusedField?.next()
                    }
                    .disabled(focusedField?.isLast != false)
                    Spacer()
                    Button(Constants.KeyboardNavigation.done) {
                        focusedField = nil
                    }
                }
            }
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
