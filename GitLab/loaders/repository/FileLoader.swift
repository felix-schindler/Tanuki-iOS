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
	/// Mark: - Load config
	let url: HttpUrl
	let fileName: String
	
	/// Mark: - View config
	/// Whether the file is shown inline (true) or full screen (false)
	@State var inline: Bool = false
	/// Whether to show loading / error
	@State var showNotFound: Bool = false
	
	public init(id: Int, filePath: String, refName: String, inline: Bool = false, showNotFound: Bool = false) {
		self.url = HttpUrl(
			host: API.domain,
			path: [
				"projects",
				String(id),
				"repository",
				"files"
			],
			resource: filePath,
			suffix: "/raw"
		)
		
		self.fileName = filePath
		self.inline = inline
		self.showNotFound = showNotFound
	}
	
	public init(rawUrl: String, inline: Bool = true, showNotFound: Bool = false) {
		self.url = HttpUrl(string: rawUrl)!

		self.fileName = self.url.url.pathComponents[self.url.url.pathComponents.endIndex - 1]
		self.inline = inline
		self.showNotFound = showNotFound
	}
	
	/// Mark: - Load state
	/// File content (loaded from API)
	@State var content: String? = nil
	@State var loadFailed: Bool = false
	
	
	var body: some View {
		VStack {
			if (content != nil) {
				if (inline) {
					FileView(fileName: fileName, content: content!)
				} else {
					FileView(fileName: fileName, content: content!)
						.padding(.horizontal)
						.navigationTitle(fileName)
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
