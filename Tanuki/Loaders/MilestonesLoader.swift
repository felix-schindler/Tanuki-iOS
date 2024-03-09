//
//  GroupMilestonesLoader.swift
//  Tanuki
//
//  Created by Felix Schindler on 07.03.24.
//

import GitLabAPI
import MarkdownUI
import SwiftUI

enum MilestoneQueryType {
	case group,
		project
}

struct MilestonesLoader: View {
	private let fullPath: String
	private let queryType: MilestoneQueryType

	@State
	private var milestones: [Milestone?]? = nil

	@State
	private var loadFailed = false

	init(fullPath: String, queryType: MilestoneQueryType) {
		self.fullPath = fullPath
		self.queryType = queryType
	}

	private func loadMilestones() {
		if self.queryType == .group {
			Network.shared.apollo.fetch(query: GroupMilestonesQuery(fullPath: self.fullPath)) {
				result in
				switch result {
				case .success(let graphQLResult):
					print("Success! Setting milestones...")
					milestones = graphQLResult.data?.group?.milestones?.nodes
				case .failure(let error):
					print("Failure! Error: \(error)")
					loadFailed = true
				}
			}
		} else {
			Network.shared.apollo.fetch(query: ProjectMilestonesQuery(fullPath: self.fullPath)) {
				result in
				switch result {
				case .success(let graphQLResult):
					print("Success! Setting milestones...")
					milestones = graphQLResult.data?.project?.milestones?.nodes
				case .failure(let error):
					print("Failure! Error: \(error)")
					loadFailed = true
				}
			}
		}
	}

	var body: some View {
		List {
			if let milestones = self.milestones {
				if milestones.isEmpty {
					Text("There are no milestones")
				} else {
					ForEach(milestones, id: \.?.iid) { maybeStone in
						if let milestone = maybeStone {
							Label(
								title: {
									VStack {
										Text(milestone.title.emojized())

										if let description = milestone.description?.emojized() {
											Markdown(description)
												.markdownTheme(.gitLab)
										}
									}
								},
								icon: {
									Image(systemName: "flag.circle")
										.foregroundStyle(
											milestone.state == .closed
												? .red
												: (milestone.expired
													? .orange
													: .green)
										)
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
						ProgressView("Loading milestones")
					}
				}.frame(maxWidth: .infinity, minHeight: 100)
			}
		}.onAppear {
			loadMilestones()
		}.refreshable {
			loadMilestones()
		}.navigationTitle("Milestones")
	}
}

#Preview {
	NavigationStack {
		MilestonesLoader(fullPath: "gitlab-org", queryType: .group)
	}
}
