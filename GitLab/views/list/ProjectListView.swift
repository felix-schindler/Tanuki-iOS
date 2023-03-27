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
	@State var updateFunction: () async -> [Project]?
	
	var body: some View {
		List {
			if (projects.isEmpty) {
				Text("There are no projects")
			} else {
				ForEach(projects, id: \.id) { project in
					NavigationLink(destination: ProjectView(project: project)) {
						HStack {
							if (project.avatarUrl != nil || project.namespace.avatarUrl != nil) {
								AsyncImage(url: URL(string: project.avatarUrl ?? API.domain + project.namespace.avatarUrl!)) { phase in
									switch phase {
									case .empty:
										ProgressView()
									case .success(let image):
										image
											.resizable()
											.scaledToFit()
											.cornerRadius(10)
									default:
										Image(systemName: "exclamationmark.icloud")
											.resizable()
											.scaledToFit()
									}
								}.frame(width: 50, height: 50, alignment: .leading)
							}
							VStack(alignment: .leading, spacing: 2) {
								HStack(spacing: 2) {
									if (project.visibility == "private") {
										Image(systemName: "lock")
									} else if (project.visibility == "internal") {
										Image(systemName: "shield.lefthalf.filled")
									} else if (project.visibility == "public") {
										Image(systemName: "globe")
									}
									Text(project.nameWithNamespace)
										.fontWeight(.medium)
									if (project.permissions?.projectAccess != nil) {
										Spacer()
										Text(accessRole(code: project.permissions!.projectAccess!.accessLevel))
											.font(.caption)
											.padding(.horizontal, 6)
											.padding(.vertical, 4)
											.background(Color(.systemGray3))
											.cornerRadius(10)
									}
								}
								if (project.description != nil && project.description != "") {
									Markdown(project.description!.emojized())
								}
								VStack(alignment: .leading, spacing: 2) {
									HStack {
										HStack(spacing: 2) {
											Image(systemName: "star")
											Text(String(project.starCount))
										}
										
										if (project.forksCount != nil) {
											HStack(spacing: 2) {
												Image(systemName: "arrow.branch")
												Text(String(project.forksCount!))
											}
										}
										
										if (project.issuesEnabled && project.openIssuesCount != nil) {
											HStack(spacing: 2) {
												Image(systemName: "smallcircle.circle")
												Text(String(project.openIssuesCount!))
											}
										}
									}.font(.caption)
										.foregroundColor(.secondary)
									if (!project.tagList.isEmpty) {
										ScrollView(.horizontal) {
											HStack {
												ForEach(project.tagList, id: \.hashValue) { tag in
													Text(tag)
														.padding(.horizontal, 6)
														.padding(.vertical, 4)
														.background(Color(.systemGray3))
														.cornerRadius(10)
												}
											}.font(.caption)
										}
									}
								}.padding(.top, 2)
							}
						}
					}
				}
			}
		}.refreshable {
			let temp = await updateFunction()
			if (temp != nil) {
				projects = temp!
			}
		}
	}
	
	func accessRole(code: Int) -> String {
		switch code {
		case 0:
			return "No access"
		case 5:
			return "Minimal access"
		case 10:
			return "Guest"
		case 20:
			return "Reporter"
		case 30:
			return "Developer"
		case 40:
			return "Maintainer"
		case 50:
			return "Owner"
		default:
			return ""
		}
	}
}

struct ProjectListView_Previews: PreviewProvider {
	static var previews: some View {
		ProjectListView(projects: [], updateFunction: { nil })
	}
}
