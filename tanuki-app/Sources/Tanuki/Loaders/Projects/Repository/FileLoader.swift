//
//  FileLoader.swift
//  GitLab
//
//  Created by Felix Schindler on 02.11.21.
//

import AVKit
import MarkdownUI
import SwiftUI

struct FileLoader: View {
	private let projectId: Int
	private let filePath: String
	private let fileExtension: String
	private let refName: String

	@Environment(\.colorScheme)
	private var colorScheme: ColorScheme

	@State
	private var content: Result<String, Error>? = nil

	init(
		id: Int,
		filePath: String,
		refName: String
	) {
		self.projectId = id
		self.filePath = filePath
		self.refName = refName
		self.fileExtension = filePath.components(separatedBy: ".").last?.lowercased() ?? ""
	}

	private func loadFile() async {
		do {
			let res = try await API.raw(
				method: .get,
				endpoint: "projects/\(projectId)/repository/files",
				resource: filePath,
				suffix: "/raw",
				query: ["ref": refName]
			)
			if let data = res.data, let content = String(data: data, encoding: .utf8) {
				self.content = .success(content)
			}
		} catch let error {
			self.content = .failure(error)
			Notify.status(.error)
		}
	}

	public var body: some View {
		ScrollView {
			VStack(alignment: .leading) {
				if Formats.audioFormats.contains(fileExtension) {
					VStack {
						Image(systemName: "play")
							.resizable()
							.scaledToFit()
							.foregroundStyle(.gray)
							.frame(width: 50, height: 50)
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
								ProgressView()
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
							.resizable()
							.scaledToFit()
							.foregroundStyle(.gray)
							.frame(width: 50, height: 50)
						Text("Can't preview this \(fileExtension) file")
					}
				} else if let content {
					switch content {
					case .success(let content):
						if fileExtension == "md" {
							Markdown(content)
								.markdownTheme(.gitLab)
						} else {
							CodeTextView(
								content,
								language: self.fileExtension,
								colorScheme: self.colorScheme,
								fontSize: 12
							)
						}
					case .failure(let error):
						FailedView(error)
					}
				} else {
					LoadingView("Loading file", systemImage: "document")
				}
				Spacer()
			}
			.padding(.horizontal)
			.frame(maxWidth: .infinity)
		}.onAppear {
			Task {
				await loadFile()
			}
		}.refreshable {
			await loadFile()
		}.navigationTitle(filePath)
	}
}

#Preview {
	VStack {
		FileLoader(
			id: 33_025_310,
			filePath: "GitLab/GitLabApp.swift",
			refName: "main"
		)
		FileLoader(
			id: 45_748_717,
			filePath: "tanuki.svg",
			refName: "main"
		)
	}
}
