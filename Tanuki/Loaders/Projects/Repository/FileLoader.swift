//
//  FileLoader.swift
//  GitLab
//
//  Created by Felix Schindler on 02.11.21.
//

import AVKit
import CodeHighlighter
import MarkdownUI
import SwiftHttp
import SwiftUI

struct FileLoader: View {
	// MARK: - Config
	private let url: HttpUrl
	private let filePath: String
	
	private let fileExtension: String
	private let refName: String
	
	// MARK: - State
	@State
	private var content: String? = nil
	
	@State
	private var loadFailed = false
	
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
		
		self.refName = refName
		self.filePath = filePath
		self.fileExtension = filePath.components(separatedBy: ".").last?.lowercased() ?? ""
	}
	
	public var body: some View {
		ScrollView {
			VStack(alignment: .leading) {
				if let content = self.content {
					if fileExtension == "md" {
						Markdown(content)
							.markdownTheme(.gitLab)
					} else {
						CodeTextView(
							content,
							language: self.fileExtension
						)
					}
				} else if Formats.audioFormats.contains(fileExtension) {
					VStack {
						Image(systemName: "play")
						Text("Can't preview this \(fileExtension) audio file")
					}
				} else if Formats.videoFormats.contains(fileExtension) {
					if let url = URL(string: "") {
						VideoPlayer(player: AVPlayer(url: url))
					}
				} else if Formats.imageFormats.contains(fileExtension) {
					if let url = URL(string: "") {
						AsyncImage(url: url) { phase in
							switch phase {
							case .empty:
								ProgressView("Loading image")
							case .success(let image):
								image
									.resizable()
									.scaledToFit()
									.cornerRadius(10)
							default:
								Image(systemName: "photo")
									.resizable()
									.scaledToFit()
							}
						}
					}
				} else if Formats.binaryFormats.contains(fileExtension) {
					VStack {
						Image(systemName: "doc.zipper")
						Text("Can't preview this \(fileExtension) binary file")
					}
				} else {
					Spacer()
					if loadFailed {
						Text(failedToLoad)
					} else {
						ProgressView("Loading file")
					}
				}
				Spacer()
			}
			.padding(.horizontal)
			.frame(maxWidth: .infinity)
		}.onAppear {
			Task {
				await getFile()
			}
		}.refreshable {
			await getFile()
		}.navigationTitle(filePath)
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
