//
//  HomeView.swift
//  GitLab
//
//  Created by Felix Schindler on 30.10.21.
//

import SwiftUI

struct HomeView: View {
    @State var starredProjects: [Project]? = nil
    @State var progress: Double = 0

    @State var showNewIssue: Bool = false
    @State var showEvents: Bool = false

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Your work")) {
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
                }.headerProminence(.increased)
                Section(header: Text("Starred projects")) {
                    if (starredProjects != nil && !(starredProjects!.isEmpty)) {
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
                            } // TODO (un)star swipe
                        }
                    } else {
                        if (progress == 100) {
                            Text("No starred projects")
                        } else {
                            ProgressView(value: progress, total: 100)
                        }
                    }
                }.headerProminence(.increased)
            }.onAppear {
                Task.init {
                    await getStarredProjects()
                }
            }.navigationBarTitle("Home")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button (action: {showEvents = true}) {
                        Image(systemName: "bell.circle")
                    }
                }
            }.sheet(isPresented: $showEvents) {
                EventsView()
            }
        }
    }

    private func getStarredProjects() async -> Void {
        progress = 10
        do {
            let apiData: Data? = API.GET(endpoint: "projects?starred=true")
            progress = 40
            if (apiData != nil) {
                progress = 60
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                progress = 70
                starredProjects = try decoder.decode([Project].self, from: apiData!)
                progress = 90
            }
        } catch let jsonError as NSError {
            print("JSON error \(jsonError.localizedDescription)")
        }
        progress = 100
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
