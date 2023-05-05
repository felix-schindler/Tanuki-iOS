//
//  FileLoader.swift
//  GitLab
//
//  Created by Felix Schindler on 02.11.21.
//

import SwiftUI
import MarkdownUI

struct FileLoader: View {
	/// Project ID
	@State var id: Int
	/// Whether to show loading / error
	@State var showNotFound: Bool = false
	/// Whether the file is shown inline (true) or full screen (false)
	@State var inline: Bool = false
	/// Path / Name
	@State var filePath: String
	/// Branch name
	@State var refName: String

	@State var content: String? = nil
	@State var loadFailed: Bool = false
	
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
		content = await API.raw(method: .get, endpoint: "projects/\(id)/repository/files", resource: filePath, suffix: "/raw", query: ["ref": refName])
		loadFailed = (content == nil)
	}
}

struct FileLoader_Previews: PreviewProvider {
	static var previews: some View {
		FileLoader(id: 33025310, inline: false, filePath: "GitLab/GitLabApp.swift", refName: "main")
	}
}
