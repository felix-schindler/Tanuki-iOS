//
//  HTMLView.swift
//  GitLab
//
//  Created by Felix Schindler on 27.02.22.
//

import SwiftUI
import WebKit

struct HTMLView: UIViewRepresentable {
    let htmlString: String

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.loadHTMLString(htmlString, baseURL: nil)
    }
}
