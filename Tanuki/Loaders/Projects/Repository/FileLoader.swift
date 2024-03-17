//
//  FileLoader.swift
//  GitLab
//
//  Created by Felix Schindler on 02.11.21.
//

import MarkdownUI
import SwiftHttp
import SwiftUI

struct FileLoader: View {

	// MARK: - Load config
	public let url: HttpUrl
	public let filePath: String

	// MARK: - Load state
	/// File content (loaded from API)
	@State private var content: String? = nil
	@State private var loadFailed = false

	init(
		id: Int,
		filePath: String,
		refName: String
	) {
		self.url = HttpUrl(
			host: API.host,
			path: [
				"api",
				"v4",
				"projects",
				String(id),
				"repository",
				"files",
			],
			resource: filePath,
			suffix: "/raw",
			query: ["ref": refName]
		)

		self.filePath = filePath
	}

	init(
		rawUrl: String,
		filePath: String
	) {
		self.url = HttpUrl(string: rawUrl)!

		self.filePath = filePath
	}

	public var body: some View {
		ScrollView {
			VStack(alignment: .leading) {
				if let content = self.content {
					Markdown(
						"""
						```
						\(content)
						```
						"""
					)
					.monospaced()
					.textSelection(.enabled)
					.padding(.horizontal)
					.navigationTitle(filePath)
				} else {
					Spacer()
					if loadFailed {
						Text(failedToLoad)
					} else {
						ProgressView("Loading file")
					}
				}
				Spacer()
			}.frame(maxWidth: .infinity)
		}.onAppear {
			Task {
				await getFile()
			}
		}.refreshable {
			await getFile()
		}
	}

	private func getFile() async {
		do {
			let res = try await API.raw(method: .get, url: self.url)
			content = res.utf8String
			loadFailed = (content == nil)
		} catch {
			loadFailed = true
		}
	}
}

#Preview {
	NavigationStack {
		FileLoader(
			id: 33_025_310,
			filePath: "GitLab/GitLabApp.swift",
			refName: "main"
		)
	}
}
