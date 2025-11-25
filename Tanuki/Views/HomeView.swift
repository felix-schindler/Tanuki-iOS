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

	private func loadStarredProjects() {
		do {
			let responses = try Network.shared.apollo.fetch(
				query: CurrentUserStarredProjectsQuery(), cachePolicy: .cacheAndNetwork)

			Task {
				for try await response in responses {
					if let projects = response.data?.currentUser?.starredProjects?.nodes {
						starredProjects = .success(projects)
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
								Image("git-mr.symbols")
									.resizable()
									.scaledToFit()
									.foregroundStyle(.blue)
							})
					})

				NavigationLink(
					destination: ProjectsLoader(membership: true),
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
					destination: GroupsLoader(allAvailable: false),
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
			}

			Section("Starred projects") {
				if let starredProjects {
					switch starredProjects {
					case .success(let projects):
						if projects.isEmpty {
							NoContentView(
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
						FailedView(error)
							.frame(maxWidth: .infinity, minHeight: 100)
					}
				} else {
					LoadingView("Loading starred Projects", systemImage: "star", color: .yellow)
				}
			}
		}.onAppear {
			loadStarredProjects()
		}.refreshable {
			await reloadStarredProjects()
		}.toolbar {
			ToolbarItemGroup(placement: .topBarTrailing) {
				NavigationLink(destination: EventsLoader()) {
					Label("Activity", systemImage: "bell")
				}.tint(.accentColor)
				NavigationLink(destination: NewProjectView()) {
					Label("New project", systemImage: "plus")
				}.tint(.accentColor)
			}
		}
		.listStyle(.sidebar)
		.headerProminence(.increased)
		.navigationTitle("Home")
	}
}

#Preview {
	NavigationView {
		HomeView()
	}
}
