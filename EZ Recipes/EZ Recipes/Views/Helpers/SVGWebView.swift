//
//  SVGWebView.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 3/21/26.
//

import SwiftUI
import WebKit

/* Libraries like SVGView support rendering basic vector syntax, but some SVGs like Apple Passwords have more complex features like clip paths, gradients, and URL references.
 *
 * Using WebView will allow all SVGs to be rendered using WebKit, but needs to be controlled in a SwiftUI environment. (Note: iOS 26's WebView doesn't support all the settings WKWebView has to render the vectors properly.
 */
struct SVGWebView: UIViewRepresentable {
    let src: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.isScrollEnabled = false
        webView.isUserInteractionEnabled = false
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        let html = """
        <html>
            <head>
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <style>
                    html, body {
                        margin: 0;
                        padding: 0;
                        background: transparent;
                        width: 100%;
                        height: 100%;
                        overflow: hidden;
                    }
                    body {
                        display: flex;
                        align-items: center;
                        justify-content: center;
                    }
                    .container {
                        width: 100%;
                        height: 100%;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                    }
                    img {
                        width: 100%;
                        height: 100%;
                        object-fit: contain;
                    }
                </style>
            </head>
            <body>
                <div class="container">
                    <img src="\(src)" alt="" />
                </div>
            </body>
        </html>
        """

        webView.loadHTMLString(html, baseURL: nil)
    }
}

#Preview {
    SVGWebView(src: Constants.Mocks.chef.passkeys[0].iconLight!)
        .frame(width: 100, height: 100)
        .border(Color.red, width: 2)
}
