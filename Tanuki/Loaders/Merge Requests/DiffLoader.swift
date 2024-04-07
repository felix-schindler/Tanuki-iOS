//
//  DiffLoader.swift
//  Tanuki
//
//  Created by Felix Schindler on 07.04.24.
//

import CodeHighlighter
import SwiftUI

struct Diff: Codable {
	/// Old path of the file.
	let oldPath: String
	/// New path of the file.
	let newPath: String
	///Old file mode of the file.
	let aMode: String
	///New file mode of the file.
	let bMode: String
	/// Diff representation of the changes made to the file.
	let diff: String
	/// Indicates if the file has just been added.
	let newFile: Bool
	/// Indicates if the file has been renamed.
	let renamedFile: Bool
	/// Indicates if the file has been removed.
	let deletedFile: Bool
	/// Indicates if the file is marked as generated. Introduced in GitLab 16.9.
	let generatedFile: Bool
}

struct DiffLoader: View {
	private let projectId: Int
	private let iid: Int

	@State
	private var diffs: [Diff]? = nil

	@State
	private var loadFailed = false

	@AppStorage("mr_diff_unified")
	private var unidiff = false

	@AppStorage("mr_list_style")
	private var listStyle = 1

	init(projectId: Int, iid: Int) {
		self.projectId = projectId
		self.iid = iid
	}

	private func loadDiffs() async {
		self.diffs = await API.get(
			type: [Diff].self,
			endpoint: "projects/\(self.projectId)/merge_requests/\(self.iid)/diffs",
			query: [
				"unidiff": String(self.unidiff)
			]
		)
		loadFailed = self.diffs == nil
	}

	var body: some View {
		List {
			Section {
				Toggle("Unified diff", isOn: $unidiff)
					.onChange(of: unidiff) { _ in
						Task {
							await loadDiffs()
							Haptics.shared.play(.soft)
						}
					}
			}

			if let diffs = self.diffs {
				ForEach(diffs, id: \.oldPath) { diff in
					Section(
						content: {
							VStack(alignment: .leading) {
								if diff.aMode != diff.bMode {
									Text("Mode changed: \(diff.aMode) → \(diff.bMode)")
										.padding(.bottom)
								}
								CodeTextView(
									diff.diff,
									language: "diff"
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
								} else if diff.generatedFile {
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
		.listStyle(.grouped)
		.headerProminence(.increased)
		.navigationTitle("Diffs")
	}
}

#Preview {
	NavigationStack {
		DiffLoader(
			projectId: 33_025_310,
			iid: 1
		)
	}
}
