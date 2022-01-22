//
//  SingleProjectIssuesView.swift
//  GitLab
//
//  Created by Felix Schindler on 31.10.21.
//

import SwiftUI

struct ProjectIssuesLoader: View {
    @State var id: Int
    @State var showNewIssue: Bool = false

    @State var issues: [Issue]? = nil
    @State var noConnection: Bool = false
    
    @State var type = 0
    
    var body: some View {
        VStack {
            if (issues != nil) {
                Picker("State", selection: $type) {
                    Text("Open").tag(0)
                    Text("Closed").tag(1)
                    Text("All").tag(2)
                }.pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .onChange(of: type, perform: { type in
                    Task.init {
                        await getIssues()
                    }
                })
                IssueListView(issues: issues!, updateFunction: getIssues)
                    .toolbar {
                        ToolbarItemGroup(placement: .navigationBarTrailing) {
                            Button(action: {showNewIssue = true}) {
                                Image(systemName: "plus.circle")
                            }
                        }
                    }
            } else {
                if (noConnection) {
                    Text("Failed to load, please check your internet connection and your token")
                } else {
                    Spacer()
                    ProgressView("Loading")
                    Spacer()
                }
            }
        }.onAppear {
            Task.init {
                await getIssues()
            }
        }.navigationTitle("Issues")
        .sheet(isPresented: $showNewIssue) {
            NewIssueView(id: id)
        }
    }
        
    private func getIssues() async -> Void {
        do {
            var state: String = ""
            if (type == 0) {
                state = "state=opened&"
            } else if (type == 1) {
                state = "state=closed&"
            }
            let apiData: Data? = API.GET(endpoint: "projects/" + String(id) + "/issues?\(state)with_labels_details=true")
            if (apiData != nil) {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .custom(iso8601Decoder())
                issues = try decoder.decode([Issue].self, from: apiData!)
            } else {
                noConnection = true
            }
        } catch let jsonError as NSError {
            print("JSON error \(jsonError.localizedDescription)")
        }
    }
}

struct ProjectIssuesLoader_Previews: PreviewProvider {
    static var previews: some View {
        ProjectIssuesLoader(id: Int(0))
    }
}
