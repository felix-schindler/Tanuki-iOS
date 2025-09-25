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
	private let id: Int
	private let fullPath: String
	private let queryType: MilestoneQueryType

	@State
	private var milestones: Result<[Milestone?], Error>? = nil

	init(fullPath: String, id: Int, queryType: MilestoneQueryType) {
		self.fullPath = fullPath
		self.id = id
		self.queryType = queryType
	}

	private func loadMilestones() {
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
					cachePolicy: .networkOnly
				)

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
			if let milestones {
				switch milestones {
				case .success(let milestones):
					if milestones.isEmpty {
						if #available(iOS 17.0, *) {
							NoContentView(
								"There are no milestones", systemImage: "calendar.badge.checkmark")
						} else {
							NoContentView("There are no milestones", systemImage: "calendar")
						}
					} else {
						ForEach(milestones, id: \.?.iid) { milestone in
							if let milestone {
								if let description = milestone.description?.emojized(),
									description.isNotEmpty
								{
									Section(
										content: {
											Markdown(description)
												.markdownTheme(.gitLab)
										},
										header: {
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
			} else {
				LoadingView("Loading Milestones", systemImage: "flag.circle")
			}
		}.onAppear {
			loadMilestones()
		}.refreshable {
			await reloadMilestones()
		}.toolbar {
			NavigationLink(
				destination: {
					if self.queryType == .project {
						NewMilestoneView(id: self.id, groupId: 0)
					} else {
						NewMilestoneView(id: 0, groupId: self.id)
					}
				},
				label: {
					Label("Create new milestone", systemImage: "plus")
				}
			).tint(.accentColor)
		}.navigationTitle("Milestones")
	}
}

#Preview {
	NavigationView {
		MilestonesLoader(fullPath: "gitlab-org", id: 278_964, queryType: .group)
	}
}
