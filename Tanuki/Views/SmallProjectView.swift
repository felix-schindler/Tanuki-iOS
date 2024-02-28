//
//  SmallProjectView.swift
//  Tanuki
//
//  Created by Felix Schindler on 28.02.24.
//

import SwiftUI

protocol SmallProject {
	var avatarUrl: String? { get }
	var nameWithNamespace: String { get }
	var visibility: String? { get }
	var fullPath: String { get }
}

struct SmallProjectView: View {
	private var project: SmallProject
	
	init(_ project: SmallProject) {
		self.project = project
	}
	
	var body: some View {
		NavigationLink(destination: ProjectLoader(fullPath: project.fullPath), label: {
			HStack {
				if let url = URL.fromAvatar(project.avatarUrl) {
					AvatarImage(url, size: .small)
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
