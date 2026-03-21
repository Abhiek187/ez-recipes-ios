//
//  StringExtension.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 7/24/24.
//

import Foundation

extension String {
    /// Convert an HTML string to Markdown
    ///
    /// Source: https://stackoverflow.com/a/74800470
    var htmlToMarkdown: String {
        var text = self

        // Replace HTML comments in the format: <!-- ... comment ... -->
        let searchComment = /<!--.*?-->/
        text = text.replacing(searchComment, with: "")

        // Replace line feeds with nothing, which is how HTML notation is read in the browsers
        text = text.replacing("\n", with: "")
        
        // Line breaks
        text = text.replacing("<div>", with: "\n")
        text = text.replacing("</div>", with: "")
        text = text.replacing("<p>", with: "\n")
        text = text.replacing("</p>", with: "")
        text = text.replacing("<br>", with: "\n")

        // Text formatting
        text = text.replacing("<strong>", with: "**")
        text = text.replacing("</strong>", with: "**")
        text = text.replacing("<b>", with: "**")
        text = text.replacing("</b>", with: "**")
        text = text.replacing("<em>", with: "*")
        text = text.replacing("</em>", with: "*")
        text = text.replacing("<i>", with: "*")
        text = text.replacing("</i>", with: "*")
        
        // Replace hyperlinks block in the format: <a... href="<hyperlink>"....>
        let searchHyperlink = /<a[^>]*\s+href\s*=\s*"([^"]*)"[^>]*>(.*?)<\/a>/
        text = text.replacing(searchHyperlink) { match in
            let (_, href, content) = match.output
            return "[\(content)](\(href))"
        }

        return text
    }
    
    /// Convert a base64 String to Data, returns `nil` if conversion failed
    var base64Data: Data? {
        return Data(base64Encoded: self, options: .ignoreUnknownCharacters)
    }
    
    /// Convert a base64 URL-encoded String to Data, returns `nil` if conversion failed
    var base64UrlData: Data? {
        // Convert to regular base64 first
        var base64Str = self
            .replacing("-", with: "+")
            .replacing("_", with: "/")
            
        // Add padding if required
        let remainder = base64Str.count % 4
        if remainder != 0 {
            base64Str.append(String(repeating: "=", count: 4 - remainder))
        }
        
        return base64Str.base64Data
    }
    
    /// Convert the base64 portion of an image string that starts with "data:IMAGE\_TYPE;base64,..." to Data, returns `nil` if conversion failed
    var base64ImageData: Data? {
        let base64Str = self.replacing(/^.+?,/, with: "")
        return base64Str.base64Data
    }
    
    /// Convert an ISO date string into a Date, returns `nil` if conversion failed
    var date: Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.date(from: self)
    }
}
