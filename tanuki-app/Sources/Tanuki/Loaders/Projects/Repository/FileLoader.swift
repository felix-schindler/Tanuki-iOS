//
//  FileLoader.swift
//  GitLab
//
//  Created by Felix Schindler on 02.11.21.
//

//import MarkdownUI
import SwiftUI

#if canImport(AVKit)
	import AVKit
#endif

struct FileLoader: View {
	private let projectId: Int
	private let filePath: String
	private let fileExtension: String
	private let refName: String

	@Environment(\.colorScheme) var colorScheme: ColorScheme

	@State var file: Result<Data, Error>? = nil
	@State var videoURL: URL? = nil

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

			guard let data = res.data else {
				throw APIError.emptyResponse
			}

			self.file = .success(data)
			self.videoURL =
				Formats.videoFormats.contains(fileExtension)
				? FileLoader.writeTemporaryVideo(data, fileExtension: fileExtension) : nil
		} catch let error {
			self.file = .failure(error)
			self.videoURL = nil
			Notify.status(.error)
		}
	}

	private static func writeTemporaryVideo(_ data: Data, fileExtension: String) -> URL? {
		#if canImport(AVKit)
			let url = FileManager.default.temporaryDirectory
				.appendingPathComponent("tanuki-\(UUID().uuidString).\(fileExtension)")
			do {
				try data.write(to: url)
				return url
			} catch {
				return nil
			}
		#else
			return nil
		#endif
	}

	public var body: some View {
		ScrollView {
			VStack(alignment: .leading) {
				if Formats.audioFormats.contains(fileExtension) {
					unavailable("Can't preview this \(fileExtension) audio file", systemImage: "play")
				} else if Formats.videoFormats.contains(fileExtension) {
					videoPreview
				} else if Formats.imageFormats.contains(fileExtension) {
					imagePreview
				} else if Formats.binaryFormats.contains(fileExtension) {
					unavailable("Can't preview this \(fileExtension) file", systemImage: "doc.zipper")
				} else {
					textPreview
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

	@ViewBuilder
	private var imagePreview: some View {
		if let file {
			switch file {
			case .success(let data):
				if let image = UIImage(data: data) {
					Image(uiImage: image)
						.resizable()
						.scaledToFit()
						.cornerRadius(10)
				} else {
					unavailable("Can't preview this \(fileExtension) file", systemImage: "photo")
				}
			case .failure(let error):
				FailedView(error)
			}
		} else {
			LoadingView("Loading file", systemImage: "photo")
		}
	}

	@ViewBuilder
	private var videoPreview: some View {
		#if canImport(AVKit)
			if let videoURL {
				VideoPlayer(player: AVPlayer(url: videoURL))
			} else if let file {
				switch file {
				case .success:
					unavailable("Can't preview this \(fileExtension) video file", systemImage: "play")
				case .failure(let error):
					FailedView(error)
				}
			} else {
				LoadingView("Loading file", systemImage: "play")
			}
		#else
			unavailable("Can't preview this \(fileExtension) video file", systemImage: "play")
		#endif
	}

	@ViewBuilder
	private var textPreview: some View {
		if let file {
			switch file {
			case .success(let data):
				if let content = String(data: data, encoding: .utf8) {
					if fileExtension == "md" {
						Markdown(content)
					} else {
						CodeTextView(
							content,
							language: self.fileExtension,
							colorScheme: self.colorScheme,
							fontSize: 12
						)
					}
				} else {
					unavailable("Can't preview this \(fileExtension) file", systemImage: "document")
				}
			case .failure(let error):
				FailedView(error)
			}
		} else {
			LoadingView("Loading file", systemImage: "document")
		}
	}

	private func unavailable(_ message: String, systemImage: String) -> some View {
		VStack {
			Image(systemName: systemImage)
				.resizable()
				.scaledToFit()
				.foregroundStyle(.gray)
				.frame(width: 50, height: 50)
			Text(message)
		}
	}
}
