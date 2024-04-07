//
//  TreeLoader.swift
//  GitLab
//
//  Created by Felix Schindler on 23.01.22.
//

import GitLabAPI
import SwiftUI

struct TreeLoader: View {
	// MARK: - Initialized
	private let projectId: Int
	private let fullPath: String

	private let folderPath: String?

	@State
	private var refName: String

	// MARK: - Loaded by API
	@State
	private var repo: RepoTreeQuery.Data.Project.Repository? = nil

	@State
	private var branches: [Branch]? = nil

	@State
	private var loadFailed: Bool = false

	init(projectId: Int, fullPath: String, refName: String, folderPath: String? = nil) {
		self.projectId = projectId
		self.fullPath = fullPath
		self.refName = refName
		self.folderPath = folderPath
	}

	private func loadTree() {
		let ref: GraphQLNullable<String>
		let path: GraphQLNullable<String>

		ref = .some(refName)

		if let filePath = self.folderPath {
			path = .some(filePath)
		} else {
			path = .none
		}

		Network.shared.apollo.fetch(
			query: RepoTreeQuery(
				fullPath: self.fullPath,
				ref: ref,
				path: path
			)
		) {
			result in
			switch result {
			case .success(let graphQLResult):
				print("Success! Setting file tree...")
				self.repo = graphQLResult.data?.project?.repository
			case .failure(let error):
				print("Failure! Error: \(error)")
				self.loadFailed = true
			}
		}
	}

	private func getBranches() async {
		branches = await API.get(
			type: [Branch].self,
			endpoint: "projects/\(self.projectId)/repository/branches"
		)
	}

	public var body: some View {
		List {
			if self.folderPath == nil {
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
								// Show loading state
								self.repo = nil
								loadTree()
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

			Section("Tree") {
				if let tree = self.repo?.tree {
					if let folders = tree.trees.nodes {
						ForEach(folders, id: \.?.path) { maybeFolder in
							if let folder = maybeFolder {
								NavigationLink(
									destination: TreeLoader(
										projectId: self.projectId,
										fullPath: self.fullPath,
										refName: self.refName,
										folderPath: folder.path
									),
									label: {
										Label(folder.name, systemImage: "folder")
									}
								)
							}
						}
					}

					if let files = tree.blobs.nodes {
						ForEach(files, id: \.?.path) { maybeFile in
							if let file = maybeFile {
								NavigationLink(
									destination: FileLoader(
										id: projectId,
										filePath: file.path,
										refName: self.refName
									),
									label: {
										Label(file.name, systemImage: "doc.text")
									}
								)
							}
						}
					}
				} else {
					VStack {
						if loadFailed {
							Text(failedToLoad)
						} else {
							ProgressView("Loading file tree")
						}
					}.frame(maxWidth: .infinity, minHeight: 100)
				}
			}
		}.onAppear {
			loadTree()
			Task {
				await getBranches()
			}
		}.refreshable {
			loadTree()
			if folderPath == nil {
				await getBranches()
			}
		}.navigationTitle(folderPath != nil ? folderPath! : "Files")
	}
}

#Preview {
	NavigationStack {
		TreeLoader(
			projectId: 33_025_310,
			fullPath: "felix-schindler/gitlab-ios",
			refName: "main"
		)
	}
}
