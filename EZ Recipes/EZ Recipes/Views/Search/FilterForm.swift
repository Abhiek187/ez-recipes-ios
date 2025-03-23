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
    private enum Field: CaseIterable {
        case query
        case minCals
        case maxCals
    }
    
    @Bindable var viewModel: SearchViewModel
    
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
                        .onChange(of: (viewModel.recipeFilter.minCals ?? MIN_CALS)) { _, newValue in
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
                        .onChange(of: (viewModel.recipeFilter.maxCals ?? Int.max)) { _, newValue in
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
                    .onChange(of: viewModel.noRecipesFound) {
                        withAnimation {
                            noRecipesFound = viewModel.noRecipesFound
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
        .navigationDestination(isPresented: viewModel.isRecipeLoaded.binding) {
            SearchResults(searchViewModel: viewModel)
        }
        .keyboardNavigation(focusedField: $focusedField)
    }
}

#Preview("Empty") {
    let mockRepo = NetworkManagerMock.shared
    let emptyRecipeFilter = SearchViewModel(repository: mockRepo)
    
    return NavigationStack {
        FilterForm(viewModel: emptyRecipeFilter)
    }
}

#Preview("Max Error") {
    let mockRepo = NetworkManagerMock.shared
    let recipeFilterWithMaxError = SearchViewModel(repository: mockRepo)
    recipeFilterWithMaxError.recipeFilter.maxCals = 2001
    
    return FilterForm(viewModel: recipeFilterWithMaxError)
}

#Preview("Range Error") {
    let mockRepo = NetworkManagerMock.shared
    let recipeFilterWithRangeError = SearchViewModel(repository: mockRepo)
    recipeFilterWithRangeError.recipeFilter.minCals = 200
    recipeFilterWithRangeError.recipeFilter.maxCals = 100
    
    return FilterForm(viewModel: recipeFilterWithRangeError)
}

#Preview("Loading") {
    let mockRepo = NetworkManagerMock.shared
    let viewModelLoading = SearchViewModel(repository: mockRepo)
    viewModelLoading.isLoading = true
    
    return FilterForm(viewModel: viewModelLoading)
}

#Preview("No Results") {
    var repoNoResults = NetworkManagerMock.shared
    repoNoResults.noResults = true
    let viewModelNoResults = SearchViewModel(repository: repoNoResults)
    
    return NavigationStack {
        FilterForm(viewModel: viewModelNoResults)
    }
}
