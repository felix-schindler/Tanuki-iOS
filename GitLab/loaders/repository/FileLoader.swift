//
//  FileLoader.swift
//  GitLab
//
//  Created by Felix Schindler on 02.11.21.
//

import SwiftUI
import SwiftHttp
import MarkdownUI

struct FileLoader: View {
	
	// MARK: - Load config
	public let url: HttpUrl
	public let filePath: String
	
	// MARK: - View config
	/// Whether the file is shown inline (true) or full screen (false)
	public let inline: Bool
	/// Whether to show loading / error
	public let showNotFound: Bool
	
	// MARK: - Load state
	/// File content (loaded from API)
	@State private var content: String? = nil
	@State private var loadFailed = false
	
	public init(
		id: Int,
		filePath: String,
		refName: String,
		inline: Bool = false,
		showNotFound: Bool = false
	) {
		self.url = HttpUrl(
			host: API.domain,
			path: [
				"api",
				"v4",
				"projects",
				String(id),
				"repository",
				"files"
			],
			resource: filePath,
			suffix: "/raw",
			query: ["ref": refName]
		)
		
		self.filePath = filePath
		self.inline = inline
		self.showNotFound = showNotFound
	}
	
	public init(
		rawUrl: String,
		filePath: String,
		inline: Bool = true,
		showNotFound: Bool = true
	) {
		self.url = HttpUrl(string: rawUrl)!
		
		self.filePath = filePath
		self.inline = inline
		self.showNotFound = showNotFound
	}
	
	var body: some View {
		VStack {
			if (content != nil) {
				FileView(filePath: filePath, content: content!)
					.if(!inline) { view in
						view
							.padding(.horizontal)
							.navigationTitle(filePath)
					}
			} else if (showNotFound) {
				if (loadFailed) {
					Text(Messages.failedToLoad)
				} else {
					ProgressView("Loading")
				}
			}
		}.onAppear {
			Task {
				await getFile()
			}
		}
	}
	
	private func getFile() async -> Void {
		do {
			let res = try await API.raw(method: .get, url: self.url)
			content = res.utf8String
		} catch {
			loadFailed = true
		}
		
		loadFailed = (content == nil)
	}
}

#Preview {
	NavigationStack {
		FileLoader(
			id: 33025310,
			filePath: "GitLab/GitLabApp.swift",
			refName: "main",
			inline: false
		)
	}
}
