//
//  ProjectView.swift
//  GitLab
//
//  Created by Felix Schindler on 31.10.21.
//

import SwiftUI

struct ProjectView: View {
    @State var project: Project
    
    var body: some View {
        Text(project.nameWithNamespace)
    }
}

struct ProjectView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectView(project: Project(id: 0, description: "", name: "No project", nameWithNamespace: "", httpUrlToRepo: "", sshUrlToRepo: "", forksCount: 0, starCount: 0))
    }
}
