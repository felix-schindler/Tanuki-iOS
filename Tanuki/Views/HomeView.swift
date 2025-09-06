//
//  Home.swift
//  Tanuki
//
//  Created by Felix Schindler on 27.02.24.
//

import GitLabAPI
import SwiftUI
import Toast

struct HomeView: View {
	@State
	private var starredProjects: Result<[SmallProject?], Error>?

	@State
	private var isLoading = false

	private func loadStarredProjects() {
		isLoading = true

		defer {
			isLoading = false
		}

		do {
			let responses = try Network.shared.apollo.fetch(
				query: CurrentUserStarredProjectsQuery(), cachePolicy: .cacheAndNetwork)

			Task {
				for try await response in responses {
					if let projects = response.data?.currentUser?.starredProjects?.nodes {
						starredProjects = .success(projects)
						Notify.status(.success)
					} else if let errors = response.errors {
						for error in errors {
							Notify.status(.error, error.localizedDescription)
						}
					}
				}
			}
		} catch let error {
			starredProjects = .failure(error)
			Notify.status(.error)
		}
	}

	private func reloadStarredProjects() async {
		do {
			let response = try await Network.shared.apollo.fetch(
				query: CurrentUserStarredProjectsQuery(), cachePolicy: .networkOnly)

			if let projects = response.data?.currentUser?.starredProjects?.nodes {
				starredProjects = .success(projects)
			}

			Notify.status(.success)
		} catch let error {
			starredProjects = .failure(error)
			Notify.status(.error)
		}
	}

	public var body: some View {
		List {
			Section("Your work") {
				NavigationLink(
					destination: UserIssuesLoader(),
					label: {
						Label(
							title: {
								Text("Issues")
							},
							icon: {
								Image(systemName: "smallcircle.circle")
									.foregroundStyle(.green)
							})
					})

				DisclosureGroup(
					content: {
						NavigationLink(
							"Assigned", destination: UserMergeLoader(.assgined))
						NavigationLink(
							"Authored", destination: UserMergeLoader(.authored))
						NavigationLink(
							"Review requested",
							destination: UserMergeLoader(.reviewRequested))
					},
					label: {
						Label(
							title: {
								Text("Merge Requests")
							},
							icon: {
								Image(systemName: "arrow.triangle.pull")
									.foregroundStyle(.blue)
							})
					})

				NavigationLink(
					destination: UserProjectsLoader(),
					label: {
						Label(
							title: {
								Text("Projects")
							},
							icon: {
								Image(systemName: "app.gift.fill")
									.foregroundStyle(.gray)
							})
					}
				)

				NavigationLink(
					destination: UserSnippetsLoader(),
					label: {
						Label(
							title: {
								Text("Snippets")
							},
							icon: {
								Image(systemName: "scissors")
									.foregroundStyle(.purple)
							})
					}
				)

				NavigationLink(
					destination: UserGroupsLoader(),
					label: {
						Label(
							title: {
								Text("Groups")
							},
							icon: {
								Image(systemName: "scale.3d")
									.foregroundStyle(.red)
							})
					}
				)

				NavigationLink(
					destination: CurrentUserTodosLoader(),
					label: {
						Label("Todos", systemImage: "checkmark.square")
					}
				)
			}

			Section("Starred projects") {
				if isLoading {
					ProgressView("Loading starred projects...")
						.frame(maxWidth: .infinity, minHeight: 100)
				} else if let starredProjects {
					switch starredProjects {
					case .success(let projects):
						if projects.isEmpty {
							ContentUnavailableView(
								"There are no starred projects",
								systemImage: "star.square.on.square.fill")
						} else {
							ForEach(projects, id: \.?.fullPath) { maybeProject in
								if let project = maybeProject {
									SmallProjectView(project)
								}
							}
						}
					case .failure(let error):
						FailedView(error.localizedDescription)
							.frame(maxWidth: .infinity, minHeight: 100)
					}
				}
			}
		}.onAppear {
			loadStarredProjects()
		}.refreshable {
			await reloadStarredProjects()
		}.toolbar {
			RoundIconButton("New project", icon: "plus") {
				// TODO: Implement
				#if os(iOS)
					Haptics.shared.play(.light)
				#endif
			}
		}
		.listStyle(.sidebar)
		.headerProminence(.increased)
		.navigationTitle("Home")
	}
}

#Preview {
	NavigationStack {
		HomeView()
	}
}
