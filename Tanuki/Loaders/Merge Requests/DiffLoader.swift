//
//  DiffLoader.swift
//  Tanuki
//
//  Created by Felix Schindler on 07.04.24.
//

import SwiftUI

struct Diff: Codable {
	/// Old path of the file.
	let oldPath: String
	/// New path of the file.
	let newPath: String
	///Old file mode of the file.
	let aMode: String?
	///New file mode of the file.
	let bMode: String?
	/// Diff representation of the changes made to the file.
	let diff: String
	/// Indicates if the file has just been added.
	let newFile: Bool
	/// Indicates if the file has been renamed.
	let renamedFile: Bool
	/// Indicates if the file has been removed.
	let deletedFile: Bool
	/// Indicates if the file is marked as generated. Introduced in GitLab 16.9.
	var generatedFile: Bool?
}

struct DiffLoader: View {
	private let projectId: Int
	private let mrIid: Int?
	private let commitSha: String?

	@Environment(\.colorScheme)
	private var colorScheme: ColorScheme

	@State
	private var diffs: [Diff]? = nil

	@State
	private var loadFailed = false

	@AppStorage("diff_unified")
	private var unidiff = false

	init(projectId: Int, mrIid: Int? = nil, commitSha: String? = nil) {
		self.projectId = projectId
		self.mrIid = mrIid
		self.commitSha = commitSha

		if mrIid == nil && commitSha == nil {
			fatalError("Either IID or SHA needs to be provided")
		}
	}

	private func loadDiffs() async {
		if let iid = self.mrIid {
			self.diffs = await API.get(
				type: [Diff].self,
				endpoint: "projects/\(self.projectId)/merge_requests/\(iid)/diffs",
				query: [
					"unidiff": String(self.unidiff)
				]
			)
		} else if let sha = self.commitSha {
			self.diffs = await API.get(
				type: [Diff].self,
				endpoint: "projects/\(self.projectId)/repository/commits/\(sha)/diff",
				query: [
					"unidiff": String(self.unidiff)
				]
			)
		} else {
			self.diffs = nil
		}
		loadFailed = self.diffs == nil
	}

	var body: some View {
		List {
			Section {
				Toggle("Unified diff", isOn: $unidiff)
					.onChange(of: unidiff) { _ in
						Task {
							await loadDiffs()
							#if os(iOS)
								Haptics.shared.play(.soft)
							#endif
						}
					}
			}

			if let diffs = self.diffs {
				if diffs.isEmpty {
					Text("There are no changes")
				} else {
					ForEach(diffs, id: \.oldPath) { diff in
						Section(
							content: {
								VStack(alignment: .leading) {
									if diff.aMode != diff.bMode {
										Text(
											"Mode changed: \(diff.aMode ?? "null") → \(diff.bMode ?? "null")"
										)
										.padding(.bottom)
									}
									CodeTextView(
										diff.diff,
										language: "diff",
										colorScheme: self.colorScheme,
										fontSize: 12
									)
								}
							},
							header: {
								HStack {
									if diff.newFile {
										Image(systemName: "plus.square")
											.foregroundStyle(.green)
									} else if diff.renamedFile {
										Image(systemName: "arrow.right.square")
											.foregroundStyle(.blue)
									} else if diff.deletedFile {
										Image(systemName: "minus.square")
											.foregroundStyle(.red)
									} else if diff.generatedFile ?? false {
										Image(systemName: "gear.circle")
											.foregroundStyle(.purple)
									} else {
										Image(systemName: "dot.square")
											.foregroundStyle(.orange)
									}

									ScrollView(.horizontal) {
										if diff.renamedFile {
											Text("\(diff.oldPath) → \(diff.newPath)")
										} else {
											Text(diff.newPath)
										}
									}
								}
							})
					}
				}
			} else {
				VStack {
					Image(systemName: "plusminus")
						.resizable()
						.scaledToFit()
						.foregroundStyle(.gray)
						.frame(width: 50, height: 50)
					if loadFailed {
						Text(failedToLoad)
					} else {
						ProgressView("Loading diffs")
					}
				}.frame(maxWidth: .infinity, minHeight: 100)
			}
		}.onAppear {
			Task {
				await loadDiffs()
			}
		}.refreshable {
			await loadDiffs()
		}
		#if os(iOS)
			.listStyle(.grouped)
		#endif
		.headerProminence(.increased)
		.navigationTitle("Diffs")
	}
}

#Preview {
	NavigationStack {
		DiffLoader(
			projectId: 33_025_310,
			mrIid: 1
		)
	}
}
