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
	private var milestones: Result<[Milestone?], Error>? = nil

	@State
	private var isLoading = false

	init(fullPath: String, queryType: MilestoneQueryType) {
		self.fullPath = fullPath
		self.queryType = queryType
	}

	private func loadMilestones() {
		isLoading = true

		defer {
			isLoading = false
		}

		do {
			switch self.queryType {
			case .group:
				let responses = try Network.shared.apollo.fetch(
					query: GroupMilestonesQuery(fullPath: self.fullPath),
					cachePolicy: .cacheAndNetwork)

				Task {
					for try await response in responses {
						if let milestones = response.data?.group?.milestones?.nodes {
							self.milestones = .success(milestones)
						} else if let errors = response.errors {
							for error in errors {
								Notify.status(.error, error.localizedDescription)
							}
						}
					}
				}
				break
			case .project:
				let responses = try Network.shared.apollo.fetch(
					query: ProjectMilestonesQuery(fullPath: self.fullPath),
					cachePolicy: .cacheAndNetwork)

				Task {
					for try await response in responses {
						if let milestones = response.data?.project?.milestones?.nodes {
							self.milestones = .success(milestones)
						} else if let errors = response.errors {
							for error in errors {
								Notify.status(.error, error.localizedDescription)
							}
						}
					}
				}
				break
			}
		} catch let error {
			self.milestones = .failure(error)
			Notify.status(.error)
		}
	}

	private func reloadMilestones() async {
		do {
			switch self.queryType {
			case .group:
				let response = try await Network.shared.apollo.fetch(
					query: GroupMilestonesQuery(fullPath: self.fullPath), cachePolicy: .networkOnly)

				if let milestones = response.data?.group?.milestones?.nodes {
					self.milestones = .success(milestones)
				}

				break
			case .project:
				let response = try await Network.shared.apollo.fetch(
					query: ProjectMilestonesQuery(fullPath: self.fullPath),
					cachePolicy: .networkOnly)

				if let milestones = response.data?.project?.milestones?.nodes {
					self.milestones = .success(milestones)
				}

				break
			}

			Notify.status(.success)
		} catch let error {
			self.milestones = .failure(error)
			Notify.status(.error)
		}
	}

	public var body: some View {
		List {
			if isLoading {
				ProgressView("Loading Milestones")
			} else if let milestones {
				switch milestones {
				case .success(let milestones):
					if milestones.isEmpty {
						ContentUnavailableView(
							"There are no milestones", systemImage: "calendar.badge.checkmark")
					} else {
						ForEach(milestones, id: \.?.iid) { milestone in
							if let milestone {
								if let description = milestone.description?.emojized(), description.isNotEmpty {
									Section(content: {
										Markdown(description)
											.markdownTheme(.gitLab)
									}, header: {
										Label(
											title: {
												Text(milestone.title.emojized())
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
									})
								} else {
									Section {
										Label(
											title: {
												Text(milestone.title.emojized())
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
						}
					}
				case .failure(let error):
					FailedView(error)
				}
			}
		}.onAppear {
			loadMilestones()
		}.refreshable {
			await reloadMilestones()
		}.toolbar {
			NavigationLink(destination: NewMilestoneView(id: 1, groupId: 1), label: {
				Label("Create new milestone", systemImage: "plus")
			}).tint(.accentColor)
		}.navigationTitle("Milestones")
	}
}

#Preview {
	NavigationStack {
		MilestonesLoader(fullPath: "gitlab-org", queryType: .group)
	}
}
