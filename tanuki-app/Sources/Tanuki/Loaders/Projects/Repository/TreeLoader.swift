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

	@State var refName: String

	// MARK: - Loaded by API
	@State var tree: Result<RepoTreePayload, Error>? = nil

	@State var branches: [Branch]? = nil

	init(projectId: Int, fullPath: String, refName: String, folderPath: String? = nil) {
		self.projectId = projectId
		self.fullPath = fullPath
		self.refName = refName
		self.folderPath = folderPath
	}

	private func loadTree() {
		let filter = RepoTreeFilter(ref: refName, path: folderPath)
		Task {
			do {
				let payload = try await Network.shared.service.fetchRepoTree(fullPath: self.fullPath, filter: filter)
				self.tree = .success(payload)
			} catch let error {
				self.tree = .failure(error)
				Notify.status(.error, error.localizedDescription)
			}
		}
	}

	private func reloadTree() async {
		let filter = RepoTreeFilter(ref: refName, path: folderPath)
		do {
			let payload = try await Network.shared.service.fetchRepoTree(fullPath: self.fullPath, filter: filter)
			self.tree = .success(payload)
			Notify.status(.success)
		} catch let error {
			self.tree = .failure(error)
			Notify.status(.error)
		}
	}

	private func loadBranches() async {
		do {
			self.branches = try await API.get(
				type: [Branch].self,
				endpoint: "projects/\(self.projectId)/repository/branches"
			)
		} catch let error {
			Notify.status(.error, error.localizedDescription)
		}
	}

	public var body: some View {
		List {
			if self.folderPath == nil {
				Section {
					if let branches {
						HStack {
							Picker("Branch", selection: $refName) {
								ForEach(branches, id: \.name) { branch in
									Text(branch.name).tag(branch.name)
								}
							}
							.pickerStyle(.menu)
							.onChange(of: refName) { _ in
								loadTree()
							}
						}
					}
				}
			}

			Section("Tree") {
				if let tree {
					switch tree {
					case .success(let payload):
						if let tree = payload.repository?.tree {
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
						}
					case .failure(let error):
						FailedView(error)
					}
				} else {
					LoadingView("Loading file tree", systemImage: "folder")
				}
			}
		}.onAppear {
			loadTree()
			Task {
				await loadBranches()
			}
		}.refreshable {
			await reloadTree()
			if folderPath == nil {
				await loadBranches()
			}
		}.navigationTitle(folderPath ?? "Files")
	}
}

#Preview {
	NavigationView {
		TreeLoader(
			projectId: 33_025_310,
			fullPath: "felix-schindler/gitlab-ios",
			refName: "main"
		)
	}
}
