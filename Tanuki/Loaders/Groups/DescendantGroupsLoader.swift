//
//  DescendantGroupsLoader.swift
//  Tanuki
//
//  Created by Felix Schindler on 29.02.24.
//

import GitLabAPI
import SwiftUI

struct DescendantGroupsLoader: View {
	private var fullPath: String

	@State
	private var groups: Result<[DescendantGroupsQuery.Data.Group.DescendantGroups.Node?], Error>? =
		nil

	init(fullPath: String) {
		self.fullPath = fullPath
	}

	private func loadGroups() {
		do {
			let responses = try Network.shared.apollo.fetch(
				query: DescendantGroupsQuery(fullPath: self.fullPath), cachePolicy: .cacheAndNetwork
			)

			Task {
				for try await response in responses {
					if let groups = response.data?.group?.descendantGroups?.nodes {
						self.groups = .success(groups)
					} else if let errors = response.errors {
						for error in errors {
							Notify.status(.error, error.localizedDescription)
						}
					}
				}
			}
		} catch let error {
			self.groups = .failure(error)
			Notify.status(.error)
		}
	}

	private func reloadGroups() async {
		do {
			let response = try await Network.shared.apollo.fetch(
				query: DescendantGroupsQuery(fullPath: self.fullPath), cachePolicy: .networkOnly)

			if let groups = response.data?.group?.descendantGroups?.nodes {
				self.groups = .success(groups)
			}

			Notify.status(.success)
		} catch let error {
			self.groups = .failure(error)
			Notify.status(.error)
		}
	}

	public var body: some View {
		List {
			if let groups {
				switch groups {
				case .success(let groups):
					if groups.isEmpty {
						NoContentView(
							"There are no descendant groups of \(self.fullPath)",
							systemImage: "scale.3d")
					} else {
						ForEach(groups, id: \.self?.fullPath) { maybeGroup in
							if let group = maybeGroup {
								NavigationLink(
									destination: GroupLoader(
										fullPath: group.fullPath),
									label: {
										HStack {
											if let url = URL.fromAvatar(
												group.avatarUrl ?? "")
											{
												AvatarImage(url, size: .medium)
											}

											VStack(alignment: .leading) {
												HStack {
													if let visibility = group.visibility {
														VisibilityIcon(visibility)
													}
													if let name = group.name?.emojized() {
														Text(name)
													}
												}

												HStack(spacing: 10) {
													HStack(spacing: 2) {
														Image(
															systemName: "person.2")
														Text(
															String(
																group
																	.groupMembersCount
															))
													}

													HStack(spacing: 2) {
														Image(
															systemName:
																"app.gift.fill")
														Text(
															String(
																group.projectsCount)
														)
													}
												}.font(.footnote)
											}

											if let accessLevel = group
												.maxAccessLevel.stringValue?
												.rawValue
											{
												Spacer()
												PillView(accessLevel.lowercased().capitalized)
													.font(.footnote)
											}
										}
									})
							}
						}
					}
				case .failure(let error):
					FailedView(error)
				}
			} else {
				LoadingView(
					"Loading descendant Groups of \(self.fullPath)", systemImage: "scale.3d")
			}
		}.onAppear {
			loadGroups()
		}.refreshable {
			await reloadGroups()
		}.navigationTitle("Groups")
	}
}

#Preview {
	NavigationView {
		DescendantGroupsLoader(fullPath: "gitlab-org")
	}
}
