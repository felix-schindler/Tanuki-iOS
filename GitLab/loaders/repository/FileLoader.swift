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
	let url: HttpUrl
	let filePath: String
	
	// MARK: - View config
	/// Whether the file is shown inline (true) or full screen (false)
	let inline: Bool
	/// Whether to show loading / error
	let showNotFound: Bool
	
	// MARK: - Load state
	/// File content (loaded from API)
	@State var content: String? = nil
	@State var loadFailed: Bool = false
	
	public init(id: Int, filePath: String, refName: String, inline: Bool = false, showNotFound: Bool = false) {
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
	
	public init(rawUrl: String, filePath: String, inline: Bool = true, showNotFound: Bool = true) {
		self.url = HttpUrl(string: rawUrl)!
		
		self.filePath = filePath
		self.inline = inline
		self.showNotFound = showNotFound
	}
	
	var body: some View {
		VStack {
			if (content != nil) {
				if (inline) {
					FileView(fileName: filePath, content: content!)
				} else {
					FileView(fileName: filePath, content: content!)
						.padding(.horizontal)
						.navigationTitle(filePath)
				}
			} else if (showNotFound) {
				if (loadFailed) {
					Text("Failed to load, please check your internet connection and your token")
				} else {
					VStack {
						Spacer()
						ProgressView("Loading")
						Spacer()
					}
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

struct FileLoader_Previews: PreviewProvider {
	static var previews: some View {
		FileLoader(id: 33025310, filePath: "GitLab/GitLabApp.swift", refName: "main", inline: false)
	}
}
