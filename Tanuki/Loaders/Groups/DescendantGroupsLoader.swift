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
	private var groups:
		[DescendantGroupsQuery.Data.Group.DescendantGroups.Node?]?

	@State
	private var loadFailed = false

	init(fullPath: String) {
		self.fullPath = fullPath
	}

	private func loadGroups() {
		Network.shared.apollo.fetch(
			query: DescendantGroupsQuery(fullPath: self.fullPath)
		) { result in
			switch result {
			case .success(let graphQLResult):
				print("Success! Setting groups...")
				groups = graphQLResult.data?.group?.descendantGroups?.nodes
			case .failure(let error):
				print("Failure! Error: \(error)")
				loadFailed = true
			}
		}
	}

	#if !os(macOS)
		public var body: some View {
			main.navigationBarTitleDisplayMode(.large)
		}
	#else
		public var body: some View {
			main
		}
	#endif

	var main: some View {
		List {
			if let groups = self.groups {
				if groups.isEmpty {
					Text("There are no descendant groups of \(self.fullPath)")
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
												if let visibility = group
													.visibility
												{
													VisibilityIcon(visibility)
												}
												Text(group.name.emojized())
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
											PillView(
												accessLevel.lowercased()
													.firstCapitalized
											)
											.font(.footnote)
										}
									}
								})
						}
					}
				}
			} else {
				VStack(alignment: .center) {
					Image(systemName: "scale.3d")
						.resizable()
						.scaledToFit()
						.foregroundStyle(.red)
						.frame(width: 50, height: 50)
					if loadFailed {
						Text(LOAD_FAILED)
					} else {
						ProgressView("Loading groups")
					}
				}.frame(maxWidth: .infinity, minHeight: 100)
			}
		}.onAppear {
			loadGroups()
		}.refreshable {
			loadGroups()
		}.navigationTitle("Descendant groups")
	}
}

#Preview {
	NavigationStack {
		DescendantGroupsLoader(fullPath: "gitlab-org")
	}
}
