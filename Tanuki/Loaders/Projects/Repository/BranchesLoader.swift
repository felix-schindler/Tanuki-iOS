//
//  BranchesLoader.swift
//  GitLab
//
//  Created by Felix Schindler on 02.11.21.
//

import SwiftUI

struct BranchesLoader: View {
	private var projectId: Int

	@Environment(\.presentationMode)
	private var presentationMode: Binding<PresentationMode>

	@State
	private var branches: Result<[Branch], Error>? = nil

	init(_ projectId: Int) {
		self.projectId = projectId
	}

	private func loadBranches() async {
		do {
			let temp = try await API.get(
				type: [Branch].self, endpoint: "projects/\(projectId)/repository/branches")

			self.branches = .success(temp)
		} catch let error {
			self.branches = .failure(error)
			Notify.status(.error)
		}
	}

	public var body: some View {
		List {
			if let branches {
				switch branches {
				case .success(let branches):
					if branches.isEmpty {
						NoContentView(
							"You'll see your branches after you pushed them",
							systemImage: "chevron.left.forwardslash.chevron.right")
					} else {
						ForEach(branches, id: \.name) { branch in
							HStack {
								VStack(alignment: .leading) {
									HStack {
										if branch.protected {
											Image(systemName: "lock")
										}
										Text(branch.name.emojized())
											.font(.headline)
									}

									VStack(alignment: .leading) {
										HStack {
											Text(branch.commit.shortId)
												.font(.system(.footnote, design: .monospaced))
											Text(branch.commit.authoredDate.toString())
										}
										Text(branch.commit.title.emojized())
									}.font(.footnote)
								}
								Spacer()
								// TODO: PipelineLoader(id: id, branch: branch.name)
							}
						}
					}
				case .failure(let error):
					FailedView(error)
				}
			} else {
				LoadingView(
					"Loading Branches", systemImage: "chevron.left.forwardslash.chevron.right")
			}
		}.onAppear {
			Task {
				await loadBranches()
			}
		}.refreshable {
			await loadBranches()
		}.navigationTitle("Branches")
	}
}

#Preview {
	NavigationView {
		BranchesLoader(33_025_310)
	}
}
