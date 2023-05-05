//
//  HomeView.swift
//  GitLab
//
//  Created by Felix Schindler on 30.10.21.
//

import SwiftUI

struct HomeView: View {
	@State var starredProjects: [Project]? = nil
	
	@State var showNewIssue = false
	@State var showEvents = false
	@State var showNewProject = false
	
	var body: some View {
		NavigationView {
			List {
				Section("Your work") {
					NavigationLink(destination: IssuesLoader(scope: .createdByMe)) {
						Label(
							title: {
								Text("Issues")
							},
							icon: {
								Image(systemName: "smallcircle.circle")
									.foregroundColor(.green)
							}
						)
					}

					NavigationLink(destination: MergeLoader()) {
						Label(
							title: {
								Text("Merge Requests")
							},
							icon: {
								Image(systemName: "arrow.triangle.pull")
									.foregroundColor(.blue)
							}
						)
					}

					NavigationLink(destination: ProjectsLoader(membership: true, orderBy: .updatedAt)) {
						Label(
							title: {
								Text("Projects")
							},
							icon: {
								Image(systemName: "appclip")
									.foregroundColor(.gray)
							}
						)
					}
					
					NavigationLink(destination: MemberGroupsLoader()) {
						Label(
							title: {
								Text("Groups")
							},
							icon: {
								Image(systemName: "person.3")
									.foregroundColor(.red)
							}
						)
					}
				}

				Section("Starred projects") {
					if (starredProjects != nil) {
						if (starredProjects!.isEmpty) {
							Text("You have no starred projects")
						} else {
							ForEach(starredProjects!, id: \.id) { project in
								NavigationLink(destination: ProjectView(project: project)) {
									HStack {
										Text(project.nameWithNamespace)
											.frame(maxWidth: .infinity, alignment: .leading)
										if (project.visibility == "private") {
											Image(systemName: "lock")
										} else if (project.visibility == "internal") {
											Image(systemName: "shield.lefthalf.filled")
										} else if (project.visibility == "public") {
											Image(systemName: "globe")
										}
									}
								}
							}
						}
					} else {
						ProgressView()
					}
				}
			}
			.headerProminence(.increased)
			.listStyle(.sidebar)
			.navigationBarTitle("Home")
			.refreshable {
				await getStarredProjects()
			}
			.onAppear {
				Task {
					await getStarredProjects()
				}
			}.toolbar {
				Button (action: {showEvents = true}) {
					Image(systemName: "bell.circle")
				}
				Button (action: {showNewProject = true}) {
					Image(systemName: "plus.circle")
				}
			}.sheet(isPresented: $showEvents) {
				EventsView()
			}.sheet(isPresented: $showNewProject) {
				NewProject()
			}
		}
	}
	
	private func getStarredProjects() async -> Void {
		starredProjects = await API.get(type: [Project].self, endpoint: "projects", query: ["starred": "true"])
	}
}

struct HomeView_Previews: PreviewProvider {
	static var previews: some View {
		HomeView()
	}
}
