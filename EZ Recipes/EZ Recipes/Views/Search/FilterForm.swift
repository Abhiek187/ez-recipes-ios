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
    
    @ObservedObject var viewModel: SearchViewModel
    
    @FocusState private var focusedField: Field?
    @State private var caloriesExceedMax = false
    @State private var caloriesInvalidRange = false
    @State private var noRecipesFound = false
    
    private let MIN_CALS = Constants.SearchView.minCals
    private let MAX_CALS = Constants.SearchView.maxCals
    
    var body: some View {
        Form {
            Section(Constants.SearchView.querySection) {
                TextField(Constants.SearchView.queryPlaceholder, text: $viewModel.recipeFilter.query)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)
                    .focused($focusedField, equals: .query)
            }
            Section(Constants.SearchView.filterSection) {
                HStack {
                    // Extend the divider all the way to the left (it goes up to the first "text" element)
                    // https://stackoverflow.com/a/77823150
                    Text("")
                    Spacer()
                    TextField(String(MIN_CALS), value: $viewModel.recipeFilter.minCals, format: .number)
                        .frame(width: 75)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                        .focused($focusedField, equals: .minCals)
                        .onChange(of: (viewModel.recipeFilter.minCals ?? MIN_CALS)) { newValue in
                            withAnimation {
                                caloriesExceedMax = newValue > MAX_CALS || (viewModel.recipeFilter.maxCals ?? MIN_CALS) > MAX_CALS
                                caloriesInvalidRange = newValue > (viewModel.recipeFilter.maxCals ?? Int.max)
                            }
                        }
                    Text(Constants.SearchView.calorieLabel)
                    TextField(String(MAX_CALS), value: $viewModel.recipeFilter.maxCals, format: .number)
                        .frame(width: 75)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                        .focused($focusedField, equals: .maxCals)
                        .onChange(of: (viewModel.recipeFilter.maxCals ?? Int.max)) { newValue in
                            withAnimation {
                                caloriesExceedMax = newValue != Int.max && newValue > MAX_CALS || (viewModel.recipeFilter.minCals ?? MIN_CALS) > MAX_CALS
                                caloriesInvalidRange = newValue < (viewModel.recipeFilter.minCals ?? MIN_CALS)
                            }
                        }
                    Text(Constants.SearchView.calorieUnit)
                    Spacer()
                }
                FormError(on: caloriesExceedMax, message: Constants.SearchView.calorieExceedMaxError)
                FormError(on: caloriesInvalidRange, message: Constants.SearchView.calorieInvalidRangeError)
                
                Toggle(Constants.SearchView.vegetarianLabel, isOn: $viewModel.recipeFilter.vegetarian)
                Toggle(Constants.SearchView.veganLabel, isOn: $viewModel.recipeFilter.vegan)
                Toggle(Constants.SearchView.glutenFreeLabel, isOn: $viewModel.recipeFilter.glutenFree)
                Toggle(Constants.SearchView.healthyLabel, isOn: $viewModel.recipeFilter.healthy)
                Toggle(Constants.SearchView.cheapLabel, isOn: $viewModel.recipeFilter.cheap)
                Toggle(Constants.SearchView.sustainableLabel, isOn: $viewModel.recipeFilter.sustainable)
                
                MultiPicker(Constants.SearchView.spiceLabel, selection: $viewModel.recipeFilter.spiceLevel) {
                    ForEach(SpiceLevel.allCases, id: \.rawValue) { spiceLevel in
                        // Don't filter by unknown
                        if spiceLevel != .unknown {
                            Text(spiceLevel.rawValue)
                                .mpTag(spiceLevel.rawValue)
                        }
                    }
                }
                .mpPickerStyle(.navigationLink)
                MultiPicker(Constants.SearchView.typeLabel, selection: $viewModel.recipeFilter.type) {
                    ForEach(MealType.allCases.sorted(), id: \.rawValue) { mealType in
                        if mealType != .unknown {
                            Text(mealType.rawValue)
                                .mpTag(mealType.rawValue)
                        }
                    }
                }
                .mpPickerStyle(.navigationLink)
                MultiPicker(Constants.SearchView.cultureLabel, selection: $viewModel.recipeFilter.culture) {
                    ForEach(Cuisine.allCases.sorted(), id: \.rawValue) { cuisine in
                        if cuisine != .unknown {
                            Text(cuisine.rawValue)
                                .mpTag(cuisine.rawValue)
                        }
                    }
                }
                .mpPickerStyle(.navigationLink)
            }
            
            Section {
                SubmitButton(viewModel: viewModel)
                    .disabled(caloriesExceedMax || caloriesInvalidRange || viewModel.isLoading)
                    .onChange(of: viewModel.noRecipesFound) { newValue in
                        withAnimation {
                            noRecipesFound = newValue
                        }
                    }
                FormError(on: noRecipesFound, message: Constants.SearchView.noResults)
            }
        }
        // Prevent navigation unless the recipes are loaded
        .onAppear {
            if UIDevice.current.userInterfaceIdiom == .phone {
                viewModel.isRecipeLoaded = false
            }
        }
        // Must place navigationDestination outside lazy containers (Form is rendered as a List)
        .navigationDestination(isPresented: viewModel.isRecipeLoaded.binding()) {
            SearchResults(recipes: viewModel.recipes, searchViewModel: viewModel)
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
    static let mockRepo = NetworkManagerMock.shared
    static var repoNoResults = NetworkManagerMock.shared
    
    static let emptyRecipeFilter = SearchViewModel(repository: mockRepo)
    static var recipeFilterWithMaxError = SearchViewModel(repository: mockRepo)
    static var recipeFilterWithRangeError = SearchViewModel(repository: mockRepo)
    static var viewModelLoading = SearchViewModel(repository: mockRepo)
    static var viewModelNoResults = SearchViewModel(repository: repoNoResults)
    
    static var previews: some View {
        recipeFilterWithMaxError.recipeFilter.maxCals = 2001
        recipeFilterWithRangeError.recipeFilter.minCals = 200
        recipeFilterWithRangeError.recipeFilter.maxCals = 100
        viewModelLoading.isLoading = true
        repoNoResults.noResults = true
        
        return ForEach([1], id: \.self) {_ in
            NavigationStack {
                FilterForm(viewModel: emptyRecipeFilter)
            }
            .previewDisplayName("Empty")
            
            FilterForm(viewModel: recipeFilterWithMaxError)
                .previewDisplayName("Max Error")
            
            FilterForm(viewModel: recipeFilterWithRangeError)
                .previewDisplayName("Range Error")
            
            FilterForm(viewModel: viewModelLoading)
                .previewDisplayName("Loading")
            
            NavigationStack {
                FilterForm(viewModel: viewModelNoResults)
            }
            .previewDisplayName("No Results")
        }
    }
}
