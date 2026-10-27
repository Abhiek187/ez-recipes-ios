//
//  PersistNavigationTitle.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 10/25/26.
//

import SwiftUI

private struct PersistNavigationTitle: ViewModifier {
    func body(content: Content) -> some View {
        // Temporary until the pipeline uses Xcode 27
        #if CI
        content
        #else
        if #available(iOS 27.0, *) {
            content
                .toolbarMinimizationBehavior(.never, for: .navigationBar)
        } else {
            content
        }
        #endif
    }
}


extension View {
    /// On iOS 27+, the app will hang when tapping on a MultiPicker with a NavigationLink if the navigation title disappears (such as on an iPhone Duo), so force it to stay on screen when scrolling down
    /// - Returns: the resulting View
    func persistNavigationTitle() -> some View {
        modifier(PersistNavigationTitle())
    }
}
