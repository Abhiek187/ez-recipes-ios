//
//  HTMLText.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 12/18/22.
//

import SwiftUI

// Render an HTML string using UIKit's NSAttributedString, with help from https://stackoverflow.com/a/68498657
struct HTMLText: UIViewRepresentable {
    let text: String
    private let textView = UITextView()
    
    init(_ content: String) {
        self.text = content
    }
    
    func makeUIView(context: Context) -> UITextView {
        // Keep the text within the screen's bounds (+ some padding)
        textView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 60).isActive = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        // Show all the text on screen without needing a ScrollView
        textView.isScrollEnabled = false
        // Make the anchor tags clickable: https://stackoverflow.com/a/50977234
        textView.isEditable = false
        textView.dataDetectorTypes = [.link]
        textView.backgroundColor = .clear // remove the white background
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        DispatchQueue.main.async {
            if let attributeText = self.convertHTML(text: text) {
                textView.attributedText = attributeText
            } else {
                textView.text = ""
            }
        }
    }
    
    private func convertHTML(text: String) -> NSAttributedString? {
        guard let data = text.data(using: .utf8) else {
            return nil
        }
        
        // .characterEncoding ensures characters like dashes are rendered properly
        return try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
    }
}
