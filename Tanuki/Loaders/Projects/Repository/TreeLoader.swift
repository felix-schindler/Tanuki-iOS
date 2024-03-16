//
//  TreeLoader.swift
//  GitLab
//
//  Created by Felix Schindler on 23.01.22.
//

import SwiftUI

struct TreeFile: Codable {
	let id: String
	let name: String
	let type: String
	let path: String
}

struct TreeLoader: View {
	// MARK: - Initialized
	private let id: Int
	private var filePath: String?

	@State
	private var refName: String

	// MARK: - Loaded by API
	@State
	private var tree: [TreeFile]? = nil

	@State
	private var branches: [Branch]? = nil

	@State
	private var loadFailed: Bool = false

	init(id: Int, refName: String, filePath: String? = nil) {
		self.id = id
		self.refName = refName
		self.filePath = filePath
	}

	public var body: some View {
		List {
			if self.filePath == nil {
				Section {
					if let branches = self.branches {
						HStack {
							Picker("Branch: ", selection: $refName) {
								ForEach(branches, id: \.name) { branch in
									Text(branch.name).tag(branch.name)
								}
							}
							.pickerStyle(.menu)
							.onChange(of: refName) { _ in
								Task {
									await getTree()
								}
							}
						}
					} else {
						VStack(alignment: .leading) {
							if loadFailed {
								Text(failedToLoad)
							} else {
								ProgressView("Loading branches")
							}
						}.frame(maxWidth: .infinity)
					}
				}
			}

			Section("Files") {
				if let tree = self.tree {
					if tree.isEmpty {
						Text(
							"There are no files yet. You'll see them after you pushed them to branch \(refName)"
						)
					} else {
						ForEach(tree, id: \.id) { file in
							if file.type == "tree" {
								NavigationLink(
									destination: TreeLoader(
										id: self.id,
										refName: self.refName,
										filePath: file.path
									),
									label: {
										Label(file.name, systemImage: "folder")
									}
								)
							} else {
								NavigationLink(
									destination: FileLoader(
										id: self.id,
										filePath: file.path,
										refName: self.refName
									),
									label: {
										Label(file.name, systemImage: "doc.text")
									})
							}
						}
					}
				} else {
					VStack {
						if loadFailed {
							Text(failedToLoad)
						} else {
							ProgressView("Loading file tree on branch \(refName)")
						}
					}.frame(maxWidth: .infinity, minHeight: 100)
				}
			}
		}.onAppear {
			Task {
				await getTree()
				await getBranches()
				loadFailed = (tree == nil) || (branches == nil)
			}
		}.refreshable {
			await getTree()
			if filePath == nil {
				await getBranches()
			}
		}.navigationTitle(filePath ?? "Files")
	}

	private func getTree() async {
		tree = await API.get(
			type: [TreeFile].self, endpoint: "projects/\(id)/repository/tree",
			query: ["ref": refName, "path": filePath ?? "", "per_page": String(100)])
	}

	private func getBranches() async {
		branches = await API.get(
			type: [Branch].self, endpoint: "projects/\(id)/repository/branches")
	}
}

struct TreeLoader_Previews: PreviewProvider {
	static var previews: some View {
		TreeLoader(id: 33_025_310, refName: "main")
	}
}
