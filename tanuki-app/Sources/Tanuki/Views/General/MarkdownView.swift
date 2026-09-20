//
//  MarkdownView.swift
//  Tanuki
//
//  Created by Felix Schindler on 19.09.26.
//

import SkipWeb
import SwiftUI

struct Markdown: View {
	private let contents: String
	private let baseURL: URL?
	private let imageBaseURL: URL?

	init(_ contents: String, baseURL: URL? = nil, imageBaseURL: URL? = nil) {
		self.contents = contents
		self.baseURL = baseURL
		self.imageBaseURL = imageBaseURL
	}

	var body: some View {
		HTMLWebView(html: MarkdownHTML.document(contents, baseURL: baseURL, imageBaseURL: imageBaseURL))
	}
}

extension Markdown {
	/// No-op: kept so existing call sites keep reading naturally.
	func markdownTheme(_ theme: MarkdownTheme) -> Markdown {
		self
	}
}

struct InlineMarkdown: View {
	private let contents: String

	init(_ contents: String) {
		self.contents = contents
	}

	var body: some View {
		#if SKIP_BRIDGE
			// SkipUI parses inline Markdown out of a `LocalizedStringKey`.
			Text(LocalizedStringKey(contents))
		#else
			if let attributed = try? AttributedString(
				markdown: contents,
				options: AttributedString.MarkdownParsingOptions(
					interpretedSyntax: .inlineOnlyPreservingWhitespace)
			) {
				Text(attributed)
			} else {
				Text(contents)
			}
		#endif
	}
}

struct HTMLWebView: View {
	let html: String

	// Skip bridges these to Android, so they must not be private.
	@Environment(\.openURL) var openURL
	@State var navigator = WebViewNavigator()
	@State var height: CGFloat = 1

	var body: some View {
		WebView(
			navigator: navigator,
			html: html,
			onNavigationFinished: { didFinishLoading() },
			shouldOverrideUrlLoading: { url, _ in
				// Let the internal about:blank/data: bootstrap through; only
				// intercept real web links and hand them to the system browser.
				guard let scheme = url.scheme?.lowercased(), scheme == "http" || scheme == "https" else {
					return false
				}
				openURL(url)
				return true
			}
		)
		.frame(height: height)
		.onChange(of: html) { _, newHTML in
			height = 1
			Task { @MainActor in
				navigator.load(html: newHTML)
			}
		}
	}

	private func didFinishLoading() {
		Task { @MainActor in
			// highlight.js is inlined only into documents that contain code.
			_ = try? await navigator.evaluateJavaScript("window.hljs ? hljs.highlightAll() : 0")
			await refreshHeight()
			// Images can finish after the load event; measure again.
			try? await Task.sleep(for: .milliseconds(300))
			await refreshHeight()
		}
	}

	@MainActor
	private func refreshHeight() async {
		guard let value = try? await navigator.evaluateJavaScript("document.body.scrollHeight"),
			let pixels = Double(value)
		else {
			return
		}
		height = CGFloat(pixels)
	}
}
