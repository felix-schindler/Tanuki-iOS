//
//  HomeView.swift
//  GitLab
//
//  Created by Felix Schindler on 30.10.21.
//

import SwiftUI

struct HomeView: View {
    @State var starredProjects: [Project]? = nil

    @State var showNewIssue: Bool = false
    @State var showEvents: Bool = false

    var body: some View {
        NavigationView {
            List {
                Section("Your work") {
                    NavigationLink(destination: AllIssuesLoader()) {
                        HStack {
                            Image(systemName: "smallcircle.circle")
                                .foregroundColor(.green)
                            Text("Issues")
                        }
                    }
                    NavigationLink(destination: AllMergeLoader()) {
                        HStack {
                            Image(systemName: "arrow.triangle.pull")
                                .foregroundColor(.blue)
                            Text("Merge Requests")
                        }
                    }
                    NavigationLink(destination: MemberProjectsLoader()) {
                        HStack {
                            Image(systemName: "appclip")
                                .foregroundColor(.gray)
                            Text("Projects")
                        }
                    }
                    NavigationLink(destination: MemberGroupsLoader()) {
                        HStack {
                            Image(systemName: "person.3")
                                .foregroundColor(.red)
                            Text("Groups")
                        }
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
            .refreshable {
                await getStarredProjects()
            }
            .onAppear {
                Task.init {
                    await getStarredProjects()
                }
            }.toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button (action: {showEvents = true}) {
                        Image(systemName: "bell.circle")
                    }
                }
            }.sheet(isPresented: $showEvents) {
                EventsView()
            }.headerProminence(.increased)
            .listStyle(.sidebar)
            .navigationBarTitle("Home")
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
