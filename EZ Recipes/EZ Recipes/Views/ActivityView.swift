//
//  ActivityView.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 11/26/22.
//

import UIKit
import SwiftUI

// Display a share sheet on iOS 15
// https://stackoverflow.com/a/72035626
struct ActivityView: UIViewControllerRepresentable {
    let text: String

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityView>) -> UIActivityViewController {
        return UIActivityViewController(activityItems: [text], applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityView>) {}
}

struct ShareText: Identifiable {
    let id = UUID()
    let text: String
}
