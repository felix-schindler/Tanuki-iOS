//
//  Namespace.swift
//  Tanuki
//
//  Created by Felix Schindler on 27.02.24.
//

import SwiftUI
import GitLabAPI
import MarkdownUI

struct Namespace: View {
	private var fullPath: String
	
	@State
	private var namespace: GitLabAPI.NamespaceQuery.Data.Namespace? = nil
	
	@State
	private var loadFailed = false
	
	init(fullPath: String) {
		self.fullPath = fullPath
	}
	
	private func loadNamespace() {
		Network.shared.apollo.fetch(query: NamespaceQuery(fullPath: self.fullPath)) { result in
			switch result {
			case .success(let graphQLResult):
				print("Success! Setting issues...")
				namespace = graphQLResult.data?.namespace
			case .failure(let error):
				print("Failure! Error: \(error)")
				loadFailed = true
			}
		}
	}
	
	var body: some View {
		List {
			if let namespace = self.namespace {
				let showDetails = (
					namespace.fullName != namespace.name ||
					!(namespace.description?.isEmpty ?? true)
				)
				
				if (showDetails) {
					VStack {
						if (namespace.fullName != namespace.name) {
							Text(namespace.name)
								.font(.title)
								.fontWeight(.bold)
						}
						if let description = namespace.description {
							Markdown(description)
						}
					}.navigationTitle(namespace.fullName)
				}
				
				if ((namespace.projects.nodes?.count ?? 0) > 0) {
					Section("Projects") {
						ForEach(namespace.projects.nodes!, id: \.self) { maybeProject in
							if let project = maybeProject {
								NavigationLink(destination: Project(fullPath: project.fullPath), label: {
									HStack {
										if let url = URL.fromAvatar(project.avatarUrl) {
											AvatarImage(url: url, size: .small)
										}
										Text(project.nameWithNamespace)
										Spacer()
										if let visibility = project.visibility {
											VisibilityIcon(visibility)
										}
									}
								})
							}
						}
					}
				}
			}
		}.onAppear {
			loadNamespace()
		}.refreshable {
			loadNamespace()
		}.navigationTitle(fullPath)
	}
}

#Preview {
	NavigationStack {
		Namespace(fullPath: "felix-schindler")
	}
}
