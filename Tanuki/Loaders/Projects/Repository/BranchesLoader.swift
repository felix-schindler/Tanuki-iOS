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
	private var branches: [Branch]? = nil

	@State
	private var loadFailed: Bool = false

	init(_ projectId: Int) {
		self.projectId = projectId
	}

	public var body: some View {
		List {
			if branches != nil {
				if branches!.isEmpty {
					Text("You'll see your branches after you pushed them")
				} else {
					ForEach(branches!, id: \.name) { branch in
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
							// PipelineLoader(id: id, branch: branch.name)
						}
					}
				}
			} else {
				if loadFailed {
					Text(failedToLoad)
						.foregroundStyle(.red)
				} else {
					ProgressView()
				}
			}
		}.onAppear {
			Task {
				await getBranches()
			}
		}.refreshable {
			await getBranches()
		}.navigationBarTitle("Branches")
	}

	private func getBranches() async {
		branches = await API.get(
			type: [Branch].self, endpoint: "projects/\(projectId)/repository/branches")
		loadFailed = branches == nil
	}
}

#Preview {
	NavigationStack {
		BranchesLoader(33_025_310)
	}
}
