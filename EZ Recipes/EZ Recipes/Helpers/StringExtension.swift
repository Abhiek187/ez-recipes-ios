//
//  StringExtension.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 7/24/24.
//

import RegexBuilder

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
}
