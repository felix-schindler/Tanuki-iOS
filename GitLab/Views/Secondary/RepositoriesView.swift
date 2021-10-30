//
//  RepositoriesView.swift
//  GitLab
//
//  Created by Felix Schindler on 30.10.21.
//

import SwiftUI

struct RepositoriesView: View {
    @State var projects: [Project]? = nil
    @State var noConnection: Bool = false

    var body: some View {
        if (projects != nil) {
            List(projects!, id: \.id) { project in
            // NavigationLink(destination: IssueView(issue: issue)) {
            Text(project.name)
                .swipeActions {
                    Button {
                        if (starProject(id: project.id)) {
                            print("Implement start project")
                        }
                    } label: {
                        Image(systemName: "star")
                    }.tint(.yellow)
                }
            // }
            }
        } else {
            Text("An error orcurred")
                .foregroundColor(.red)
        }
    }

    private func starProject(id: Int) -> Bool {
        // TODO implement
        return false
    }
}

struct RepositoriesView_Previews: PreviewProvider {
    static var previews: some View {
        RepositoriesView(projects: [Project]([Project(id: 1, description: "Test", name: "Test", nameWithNamespace: "test", httpUrlToRepo: "test", sshUrlToRepo: "test", forksCount: 0, starCount: 0)]))
    }
}
