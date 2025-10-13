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

	@State
	private var showFilters = false

	// MARK: - Filter
	@State private var searchTitle: String? = nil
	@State private var state: MilestoneStateEnum? = .active
	@State private var includeAncestors = false

	init(fullPath: String, id: Int, queryType: MilestoneQueryType) {
		self.fullPath = fullPath
		self.id = id
		self.queryType = queryType
	}

	private var groupQuery: GroupMilestonesQuery {
		return GroupMilestonesQuery(
			fullPath: self.fullPath,
			state: GraphFilter.toFilterEnum(self.state),
			searchTitle: GraphFilter.toFilter(self.searchTitle),
			includeAncestors: .some(self.includeAncestors)
		)
	}

	private var projectQuery: ProjectMilestonesQuery {
		return ProjectMilestonesQuery(
			fullPath: self.fullPath,
			state: GraphFilter.toFilterEnum(self.state),
			searchTitle: GraphFilter.toFilter(self.searchTitle),
			includeAncestors: .some(self.includeAncestors)
		)
	}

	private func loadMilestones() {
		do {
			switch self.queryType {
			case .group:
				let responses = try Network.shared.apollo.fetch(
					query: self.groupQuery,
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
					query: self.projectQuery,
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
					query: self.groupQuery, cachePolicy: .networkOnly)

				if let milestones = response.data?.group?.milestones?.nodes {
					self.milestones = .success(milestones)
				}

				break
			case .project:
				let response = try await Network.shared.apollo.fetch(
					query: self.projectQuery,
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
						NoContentView("There are no milestones", systemImage: "diamond")
					} else {
						ForEach(milestones, id: \.?.iid) { milestone in
							if let milestone {
								VStack(alignment: .leading, spacing: 10) {
									Label(
										title: {
											Text(milestone.title.emojized())
										},
										icon: {
											Image(systemName: "diamond")
												.foregroundStyle(
													milestone.state == .closed
														? .red
														: (milestone.expired
															? .orange
															: .green)
												)
										}
									)

									if let description = milestone.description?.emojized(),
										description.isNotEmpty
									{
										Markdown(description)
											.markdownTheme(.gitLab)
									}
								}
							}
						}
					}
				case .failure(let error):
					FailedView(error)
				}
			} else {
				LoadingView("Loading Milestones", systemImage: "diamond")
			}
		}.onAppear {
			loadMilestones()
		}.refreshable {
			await reloadMilestones()
		}.searchable(
			text: Binding(get: { self.searchTitle ?? "" }, set: { self.searchTitle = $0.isNotEmpty ? $0 : nil }),
			prompt: "Title"
		).onChange(of: searchTitle) { _ in
			self.milestones = nil  // Show loading state
			loadMilestones()
		}.toolbar {
			HStack {
				Button("Filter", systemImage: "line.3.horizontal.decrease") {
					showFilters = true
				}
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
			}
		}.sheet(isPresented: $showFilters, onDismiss: { self.showFilters = false }) {
			NavigationView {
				Form {
					Picker("State", selection: $state) {
						Text("Any").tag(nil as MilestoneStateEnum?)
						ForEach(MilestoneStateEnum.allCases, id: \.self) { state in
							Text(state.rawValue.capitalized).tag(state)
						}
					}
					VStack(alignment: .leading) {
						Toggle("Include Ancestors", isOn: $includeAncestors)
						Text("Also return milestones in the project's parent group and its ancestors.")
							.foregroundStyle(.secondary)
							.font(.footnote)
					}
				}.toolbar {
					AsyncButton("Apply filter", systemImage: "checkmark") {
						await reloadMilestones()
						showFilters = false
					}
				}
				.navigationBarTitleDisplayMode(.inline)
				.navigationTitle("Milestones Filter")
			}
		}.navigationTitle("Milestones")
	}
}

#Preview {
	NavigationView {
		MilestonesLoader(fullPath: "gitlab-org", id: 278_964, queryType: .group)
	}
}
