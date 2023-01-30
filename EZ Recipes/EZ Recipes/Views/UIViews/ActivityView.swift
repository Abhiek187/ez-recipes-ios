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
    // A coordinator is needed to implement delegates
    class Coordinator: NSObject, UIActivityItemSource {
        var parent: ActivityView
        
        init(_ parent: ActivityView) {
            self.parent = parent
        }
        
        func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
            return "\(parent.message)\n\n\(parent.url.absoluteString)"
        }
        
        func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
            return "\(parent.message)\n\n\(parent.url.absoluteString)"
        }
        
        func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
            return parent.subject
        }
    }
    
    let url: URL
    let subject: String
    let message: String

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityView>) -> UIActivityViewController {
        return UIActivityViewController(activityItems: [self], applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityView>) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

struct ShareText: Identifiable {
    let id = UUID()
    // Matches the parameters in ActivityView
    let url: URL
    let subject: String
    let message: String
}
