//
//  ProjectView.swift
//  GitLab
//
//  Created by Felix Schindler on 31.10.21.
//

import SwiftUI
// import MarkdownUI

struct ProjectView: View {
    @State var project: Project
    
    @State var showNewIssue: Bool = false
    @State var showCommits: Bool = false
    @State var showBranches: Bool = false

    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    HStack {
                        VStack {
                            Text("Project ID: \(project.id)")
                                .font(.callout)
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            if (!project.tagList.isEmpty) {
                                HStack {
                                    Image(systemName: "tag")
                                    ForEach(project.tagList, id: \.hashValue) { tag in
                                        Text(tag)
                                            .font(.caption)
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 4)
                                            .background(Color(.systemGray3))
                                            .cornerRadius(10)
                                    }
                                }.frame(maxWidth: .infinity, alignment: .leading)
                            }
                            if (project.description != nil) {
                                // Markdown(project.description!.emojized())
                                Text(project.description!.emojized())
                                   .multilineTextAlignment(.leading)
                                   .padding(.bottom)
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
                        HStack {
                            if (project.owner != nil) {
                                Image(systemName: "person")
                            } else {
                                Image(systemName: "person.3")
                            }
                            Text(project.namespace.name)
                        }.frame(maxWidth: .infinity, alignment: .leading)
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
                                Text("\(project.starCount) stars")
                            }
                            Text(" · ")
                            if let url = URL(string: "\(API.domain)/\(project.pathWithNamespace)/-/forks/new") {    // If valid link, show fork link
                                HStack {
                                    Image(systemName: "arrow.branch")
                                    Link("\(project.forksCount) forks", destination: url)
                                }
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
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }.foregroundColor(.primary)
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.roundedRectangle)
                        .controlSize(.large)
                    }
                    NavigationLink(destination: TreeLoader(id: project.id, refName: project.defaultBranch ?? "")) {
                        HStack {
                            Image(systemName: "chevron.left.forwardslash.chevron.right")
                                .foregroundColor(.pink)
                            Text("Files")
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }.foregroundColor(.primary)
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.roundedRectangle)
                    .controlSize(.large)
                    NavigationLink(destination: PipelineLoader(id: project.id, branch: "", onlyStatus: false)) {
                        HStack {
                            Text("🚀")
                            Text("Pipelines")
                            Spacer()
                            if (project.defaultBranch != nil) {
                                PipelineLoader(id: project.id, branch: project.defaultBranch!)
                            }
                        }
                    }.foregroundColor(.primary)
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.roundedRectangle)
                    .controlSize(.large)
                }
            }.padding(.horizontal)
            // NewFileLoader(id: project.id, filePath: "README.md", refName: project.defaultBranch ?? "")
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
        ProjectView(project: Project(id: Int(), description: String(), name: "No project", nameWithNamespace: "", pathWithNamespace: "", defaultBranch: "", forksCount: 0, starCount: 0, namespace: Namespace(name: "", path: ""), visibility: "", owner: UserSmall(id: 0, name: "", username: "", avatarUrl: ""), issuesEnabled: false, mergeRequestsEnabled: false, permissions: Permissions(projectAccess: Access(accessLevel: 0, notificationLevel: 3))))
    }
}
