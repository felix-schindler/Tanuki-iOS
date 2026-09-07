//
//  GroupMilestonesLoader.swift
//  Tanuki
//
//  Created by Felix Schindler on 07.03.24.
//

import GitLabAPI
import SwiftUI

#if SKIP_BRIDGE
	private typealias PlatformNavigationView = NavigationStack
#else
	private typealias PlatformNavigationView = NavigationView
#endif

enum MilestoneQueryType {
	case group,
		project
}

struct MilestonesLoader: View {
	private let id: Int
	private let fullPath: String
	private let queryType: MilestoneQueryType

	@State var milestones: Result<[Milestone], Error>? = nil

	@State var showFilters = false

	@State var loadTask: Task<Void, Never>?

	// MARK: - Filter
	@State var searchTitle: String? = nil
	@State var state: MilestoneStateEnum? = .active
	@State var includeAncestors = false

	init(fullPath: String, id: Int, queryType: MilestoneQueryType) {
		self.fullPath = fullPath
		self.id = id
		self.queryType = queryType
	}

	private func loadMilestones() {
		self.loadTask?.cancel()
		self.loadTask = Task {
			do {
				switch self.queryType {
				case .group:
					let filter = GroupMilestonesFilter(
						state: self.state,
						searchTitle: self.searchTitle,
						includeAncestors: self.includeAncestors
					)
					let milestones = try await Network.shared.service.fetchGroupMilestones(fullPath: self.fullPath, filter: filter)
					if !Task.isCancelled {
						self.milestones = .success(milestones)
					}
				case .project:
					let filter = ProjectMilestonesFilter(
						state: self.state,
						searchTitle: self.searchTitle,
						includeAncestors: self.includeAncestors
					)
					let milestones = try await Network.shared.service.fetchProjectMilestones(fullPath: self.fullPath, filter: filter)
					if !Task.isCancelled {
						self.milestones = .success(milestones)
					}
				}
			} catch {
				if !Task.isCancelled {
					self.milestones = .failure(error)
					Notify.status(.error)
				}
			}
		}
	}

	private func reloadMilestones() async {
		do {
			switch self.queryType {
			case .group:
				let filter = GroupMilestonesFilter(
					state: self.state,
					searchTitle: self.searchTitle,
					includeAncestors: self.includeAncestors
				)
				let milestones = try await Network.shared.service.fetchGroupMilestones(fullPath: self.fullPath, filter: filter)
				self.milestones = .success(milestones)

			case .project:
				let filter = ProjectMilestonesFilter(
					state: self.state,
					searchTitle: self.searchTitle,
					includeAncestors: self.includeAncestors
				)
				let milestones = try await Network.shared.service.fetchProjectMilestones(fullPath: self.fullPath, filter: filter)
				self.milestones = .success(milestones)
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
						ForEach(milestones, id: \.iid) { milestone in
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
			self.milestones = nil
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
			PlatformNavigationView {
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
