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
    
    var body: some View {
        NavigationView {
            List {
                Section (header: Text("Your work")) {
                    NavigationLink(destination: IssuesView()) {
                        HStack {
                            Image(systemName: "square.on.square")
                            Text("Issues")
                        }
                    }
                    NavigationLink(destination: MergeRequestsView()) {
                        HStack {
                            Image(systemName: "arrow.merge")
                            Text("Merge Requests")
                        }
                    }
                    NavigationLink(destination: MemberReposView()) {
                        HStack {
                            Image(systemName: "folder")
                            Text("Repositories")
                        }
                    }
                }.headerProminence(.increased)
                Section (header: Text("Starred repositories")) {
                    if (starredProjects != nil && !(starredProjects!.isEmpty)) {
                        ForEach(starredProjects!, id: \.id) { project in
                            Text(project.nameWithNamespace)
                        }
                    } else {
                        Text("No starred repositories")
                    }
                }.headerProminence(.increased)
            }.onAppear {
                Task.init {
                    await getStarredProjects()
                }
            }
            .navigationBarTitle("Home")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                        showNewIssue = true
                    }) {
                        Image(systemName: "plus.circle")
                    }
                }
            }.sheet(isPresented: $showNewIssue, content: {
                NewIssueView()
            })
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

struct NewIssueView: View {
    @Environment(\.presentationMode)
    var presentationMode: Binding<PresentationMode>
    
    @State var title: String = ""
    @State var description: String = ""
    
    @State var isError: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                TextField("New GitLab URL", text: $title)
                    .padding()
                    .background(Color(.systemGray5))
                    .cornerRadius(10)
                TextField("Description", text: $description)
                    .frame(maxHeight: 250, alignment: .topLeading)
                    .padding()
                    .background(Color(.systemGray5))
                    .cornerRadius(10)
                Spacer()
                Button("Save new issue") {
                    isError = !saveNewIssue()
                }.alert(isPresented: $isError, content: {
                    Alert(title: Text("Error"), message: Text("Failed to create issue"), dismissButton: .default(Text("OK")))
                })
            }.padding()
            .navigationBarTitle("New issue")
            .navigationBarItems(trailing: Button("Cancel", action: {
                self.presentationMode.wrappedValue.dismiss()
            }))
        }
    }
    
    private func saveNewIssue() -> Bool {
        return false
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
