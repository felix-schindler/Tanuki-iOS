//
//  MarkdownHTML.swift
//  Tanuki
//
//  Created by Felix Schindler on 19.09.26.
//

import Foundation
import cmark_gfm
import cmark_gfm_extensions

enum MarkdownHTML {
	private static let syntaxExtensionNames = ["table", "strikethrough", "autolink", "tasklist"]

	// MARK: - Fragment
	static func fragment(_ markdown: String) -> String {
		cmark_gfm_core_extensions_ensure_registered()

		guard let parser = cmark_parser_new(CMARK_OPT_DEFAULT) else {
			return ""
		}
		defer { cmark_parser_free(parser) }

		for name in syntaxExtensionNames {
			cmark_parser_attach_syntax_extension(parser, cmark_find_syntax_extension(name))
		}

		cmark_parser_feed(parser, markdown, markdown.utf8.count)

		guard let document = cmark_parser_finish(parser) else {
			return ""
		}
		defer { cmark_node_free(document) }

		let extensions = cmark_parser_get_syntax_extensions(parser)
		guard let html = cmark_render_html(document, CMARK_OPT_DEFAULT, extensions) else {
			return ""
		}

		let result = String(cString: html)
		cmark_get_default_mem_allocator()?.pointee.free(UnsafeMutableRawPointer(html))
		return result
	}

	// MARK: - Documents
	static func document(_ markdown: String, baseURL: URL? = nil, imageBaseURL: URL? = nil) -> String {
		var body = fragment(markdown)
		if let imageBaseURL {
			body = resolvingRelativeImageSources(in: body, against: imageBaseURL)
		}
		return document(body: body, baseURL: baseURL, highlightsCode: body.contains("<code"))
	}

	static func codeDocument(_ code: String, language: String, fontSize: Double = 12) -> String {
		let language = escapeAttribute(language.lowercased())
		let languageClass = language.isEmpty ? "" : " class=\"language-\(language)\""
		let body = "<pre><code\(languageClass)>\(escapeHTML(code))</code></pre>"
		return document(body: body, baseURL: nil, highlightsCode: true, codeFontSize: fontSize)
	}

	private static func document(
		body: String,
		baseURL: URL?,
		highlightsCode: Bool,
		codeFontSize: Double? = nil
	) -> String {
		let base = baseURL.map { "<base href=\"\($0.absoluteString)\">" } ?? ""
		let themes = highlightsCode ? "<style>\(highlightThemes)</style>" : ""
		let script = highlightsCode ? "<script>\(highlightScript)</script>" : ""
		let codeFont = codeFontSize.map { ".markdown-body pre code { font-size: \($0)px; }" } ?? ""
		return """
			<!DOCTYPE html>
			<html>
			<head>
			<meta charset="utf-8">
			<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
			\(base)
			<style>
			\(stylesheet)
			</style>
			\(themes)
			<style>
			html, body { background: transparent; }
			body { margin: 0; padding: 0; }
			.markdown-body {
				box-sizing: border-box;
				min-width: 0;
				max-width: 100%;
				padding: 0;
				font-size: 16px;
				background: transparent;
			}
			.markdown-body img { max-width: 100%; height: auto; }
			.markdown-body pre { overflow-x: auto; }
			.markdown-body table { display: block; overflow-x: auto; }
			\(codeFont)
			</style>
			</head>
			<body>
			<article class="markdown-body">
			\(body)
			</article>
			\(script)
			</body>
			</html>
			"""
	}

	// MARK: - Bundled assets
	private static let stylesheet = resource("github-markdown", "css")
	private static let highlightScript = resource("highlight.min", "js")

	private static let highlightThemes = {
		let light = resource("highlight-github.min", "css")
		let dark = resource("highlight-github-dark.min", "css")
		return "@media (prefers-color-scheme: light) { \(light) }\n@media (prefers-color-scheme: dark) { \(dark) }"
	}()

	private static func resource(_ name: String, _ extension: String) -> String {
		guard let url = Bundle.module.url(forResource: name, withExtension: `extension`),
			let contents = try? String(contentsOf: url, encoding: .utf8)
		else {
			return ""
		}
		return contents
	}

	// MARK: - Helpers
	private static func escapeHTML(_ string: String) -> String {
		string.replacingOccurrences(of: "&", with: "&amp;")
			.replacingOccurrences(of: "<", with: "&lt;")
			.replacingOccurrences(of: ">", with: "&gt;")
	}

	private static func escapeAttribute(_ string: String) -> String {
		escapeHTML(string).replacingOccurrences(of: "\"", with: "&quot;")
	}

	private static func resolvingRelativeImageSources(in html: String, against base: URL) -> String {
		let base = base.absoluteString.hasSuffix("/") ? base.absoluteString : base.absoluteString + "/"
		var result = html
		var searchStart = result.startIndex

		while let marker = result.range(of: "src=\"", range: searchStart..<result.endIndex) {
			let valueStart = marker.upperBound
			guard let valueEnd = result[valueStart...].firstIndex(of: "\"") else {
				break
			}
			let value = String(result[valueStart..<valueEnd])

			if value.contains("://") || value.hasPrefix("data:") || value.hasPrefix("#") {
				searchStart = valueEnd
				continue
			}

			let absolute = base + (value.hasPrefix("/") ? String(value.dropFirst()) : value)
			result.replaceSubrange(valueStart..<valueEnd, with: absolute)
			searchStart = result.index(valueStart, offsetBy: absolute.count)
		}
		return result
	}
}
