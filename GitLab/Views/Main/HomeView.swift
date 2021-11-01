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
                Section (header: Text("Your work")) {
                    NavigationLink(destination: AllIssuesLoader()) {
                        HStack {
                            Image(systemName: "square.on.square")
                            Text("Issues")
                        }
                    }
                    NavigationLink(destination: AllMergeLoader()) {
                        HStack {
                            Image(systemName: "arrow.merge")
                            Text("Merge Requests")
                        }
                    }
                    NavigationLink(destination: MemberProjectsLoader()) {
                        HStack {
                            Image(systemName: "folder")
                            Text("Projects")
                        }
                    }
                }.headerProminence(.increased)
                Section (header: Text("Starred projects")) {
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
                        Text("No starred projects")
                    }
                }.headerProminence(.increased)
            }.onAppear {
                Task.init {
                    await getStarredProjects()
                }
            }
            .navigationBarTitle("Home")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button (action: {showEvents = true}) {
                        Image(systemName: "bell.circle")
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {showNewIssue = true}) {
                        Image(systemName: "plus.circle")
                    }
                }
            }.sheet(isPresented: $showNewIssue) {
                NewIssueView()
            }.sheet(isPresented: $showEvents) {
                EventsView()
            }
        }
    }
    
    private func getStarredProjects() async -> Void {
        do {
            let apiData: Data? = API.GET(endpoint: "projects?starred=true")
            if (apiData != nil) {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                starredProjects = try decoder.decode([Project].self, from: apiData!)
            }
        } catch let jsonError as NSError {
            print("JSON error \(jsonError.localizedDescription)")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
