//
//  Home.swift
//  Tanuki
//
//  Created by Felix Schindler on 27.02.24.
//

import GitLabAPI
import SwiftUI
import Toast
import UIKit

struct HomeView: View {
	@State
	private var starredProjects: Result<[SmallProject?], Error>?

	@State
	private var path: [AnyHashable] = []

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

	private func getIconName() -> String {
		if #available(iOS 18.0, *) {
			"arrow.right.page.on.clipboard"
		} else {
			"arrow.right"
		}
	}

	private func jumpToClipboard() {
		let pasted =
			UIPasteboard.general.string
			?? UIPasteboard.general.url?.absoluteString

		guard let pasted, pasted.isNotEmpty else {
			Notify.status(.warning, "Nothing to open", "Copy a GitLab link first.", systemImage: "doc.on.clipboard")
			return
		}

		do {
			path.append(try JumpURL.parse(pasted, host: API.host))
		} catch let error as JumpURLError {
			Notify.status(
				.warning, "Can't open that link", error.errorDescription,
				systemImage: "exclamationmark.triangle")
		} catch {
			Notify.status(.error, "Can't open that link", error.localizedDescription)
		}
	}

	public var body: some View {
		NavigationStack(path: $path) {
			list
				.navigationDestination(for: JumpTarget.self) { target in
					switch target {
					case .project(let fullPath):
						ProjectLoader(fullPath: fullPath, path: $path)
					case .group(let fullPath):
						GroupLoader(fullPath: fullPath)
					case .projectRoute(let fullPath, let route):
						ProjectLoader(fullPath: fullPath, path: $path, jumpTo: route)
					}
				}
				.navigationDestination(for: ResolvedProjectRoute.self) { route in
					switch route {
					case .issues(let fullPath):
						ProjectIssuesLoader(fullPath: fullPath)
					case .mergeRequests(let fullPath):
						ProjectMergeLoader(fullPath: fullPath)
					case .tree(let projectId, let fullPath, let ref):
						TreeLoader(projectId: projectId, fullPath: fullPath, refName: ref)
					case .releases(let fullPath, let projectId):
						ProjectReleasesLoader(fullPath: fullPath, projectId: projectId)
					}
				}
		}
	}

	private var list: some View {
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
		}.task {
			loadStarredProjects()
		}.refreshable {
			await reloadStarredProjects()
		}.toolbar {
			ToolbarItem(placement: .topBarLeading) {
				Button("Jump", systemImage: getIconName()) {
					jumpToClipboard()
				}.tint(.accentColor)
			}
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
	NavigationStack {
		HomeView()
	}
}
