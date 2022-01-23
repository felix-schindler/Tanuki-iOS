//
//  ProjectView.swift
//  GitLab
//
//  Created by Felix Schindler on 31.10.21.
//

import SwiftUI

struct ProjectView: View {
    @State var project: Project
    
    @State var showNewIssue: Bool = false
    @State var showCommits: Bool = false
    @State var showBranches: Bool = false

    var body: some View {
        ScrollView {
            VStack {
                VStack(alignment: .leading) {
                    HStack {
                        VStack {
                            Text("Project ID: " + String(project.id))
                                .font(.callout)
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            if (project.description != nil) {
                                Text(project.description!)
                                    .padding(.bottom)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        Spacer()
                        if (project.avatarUrl != nil) {
                            AsyncImage(url: URL(string: project.avatarUrl!)) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(10)
                                default:
                                    EmptyView()
                                }
                            }
                        }
                    }.frame(maxWidth: .infinity, alignment: .leading)
                    VStack {
                        if (project.owner != nil) {
                            HStack {
                                Image(systemName: "person")
                                Text(project.owner!.username)
                            }.frame(maxWidth: .infinity, alignment: .leading)
                        }
                        HStack {
                            if (project.visibility == "private") {
                                Image(systemName: "lock")
                            } else if (project.visibility == "internal") {
                                Image(systemName: "shield.lefthalf.filled")
                            } else if (project.visibility == "public") {
                                Image(systemName: "globe")
                            }
                            Text(project.visibility.firstCapitalized)
                        }.frame(maxWidth: .infinity, alignment: .leading)
                        HStack {
                            HStack {
                                Image(systemName: "star")
                                Text(String(project.starCount) + " stars")
                            }
                            Text(" · ")
                            HStack {
                                Image(systemName: "arrow.branch")
                                Text(String(project.forksCount) + " forks")
                            }
                        }.frame(maxWidth: .infinity, alignment: .leading)
                    }.frame(maxWidth: .infinity, alignment: .leading)
                }
                HStack {
                    Button(action: {showCommits = true}) {
                        Text("Commits")
                            .frame(maxWidth: .infinity)
                    }.foregroundColor(.primary)
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.roundedRectangle)
                        .controlSize(.large)
                    Button(action: {showBranches = true}) {
                        Text("Branches")
                            .frame(maxWidth: .infinity)
                    }.foregroundColor(.primary)
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.roundedRectangle)
                        .controlSize(.large)
                }
                VStack {
                    if (project.issuesEnabled) {
                        NavigationLink(destination: ProjectIssuesLoader(id: project.id)) {
                            HStack {
                                Image(systemName: "smallcircle.circle")
                                    .foregroundColor(.green)
                                Text("Issues")
                                Spacer()
                                Text(String(project.openIssuesCount!))
                            }
                        }.foregroundColor(.primary)
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.roundedRectangle)
                        .controlSize(.large)
                    }
                    if (project.mergeRequestsEnabled) {
                        NavigationLink(destination: ProjectMergeLoader(id: project.id)) {
                            HStack {
                                Image(systemName: "arrow.triangle.pull")
                                    .foregroundColor(.blue)
                                Text("Merge Requests")
                                Spacer()
                            }
                        }.foregroundColor(.primary)
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.roundedRectangle)
                        .controlSize(.large)
                    }
                    NavigationLink(destination: TreeLoader(id: project.id, refName: project.defaultBranch ?? "")) {
                        HStack {
                            Image(systemName: "folder.fill")
                                .foregroundColor(.yellow)
                            Text("Files")
                            Spacer()    // TODO: Set width to infinity
                        }
                    }.foregroundColor(.primary)
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.roundedRectangle)
                    .controlSize(.large)
                }
            }.padding(.horizontal)
            FileLoader(id: project.id, filePath: "README.md", refName: project.defaultBranch ?? "", inline: true)
        }.navigationTitle(project.name)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                if (project.issuesEnabled) {
                    Button(action: {showNewIssue = true}) {
                        Image(systemName: "plus.circle")
                    }
                }
            }
        }.sheet(isPresented: $showNewIssue) {
            NewIssueView(id: project.id)
        }.sheet(isPresented: $showCommits) {
            CommitsView(id: project.id, refName: project.defaultBranch ?? "")
        }.sheet(isPresented: $showBranches) {
            BranchesView(id: project.id)
        }
    }
}

struct ProjectView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectView(project: Project(id: Int(), description: String(), name: "No project", nameWithNamespace: "", defaultBranch: "", sshUrlToRepo: "", httpUrlToRepo: "", forksCount: 0, starCount: 0, visibility: "", owner: UserSmall(id: 0, name: "", username: "", avatarUrl: ""), issuesEnabled: false, mergeRequestsEnabled: false, permissions: Permissions(projectAccess: Access(accessLevel: 0, notificationLevel: 3))))
    }
}
