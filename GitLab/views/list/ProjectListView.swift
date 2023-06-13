//
//  RepositoriesView.swift
//  GitLab
//
//  Created by Felix Schindler on 30.10.21.
//

import SwiftUI
import MarkdownUI

struct ProjectListView: View {
	@State var projects: [Project]
	
	var body: some View {
		if (projects.isEmpty) {
			Text("There are no projects")
		} else {
			ForEach(projects, id: \.id) { project in
				SmallProjectView(project: project)
			}
		}
	}
}

struct ProjectListView_Previews: PreviewProvider {
	static var previews: some View {
		List {
			ProjectListView(projects: [])
		}
	}
}
