//
//  NewProject.swift
//  GitLab
//
//  Created by Felix Schindler on 04.05.23.
//

import SwiftUI

struct Project: Codable {
	let id: Int
	let name: String
	let visibility: String
}

enum ProjectVisibility: String {
	case NAME = "visibility"
	case `public` = "public"
	case
		`internal` = "internal"
	case
		`private` = "private"
	case
		all
}

struct NewProjectView: View {
	@Environment(\.presentationMode)
	var presentationMode: Binding<PresentationMode>

	@State private var projectName = ""
	@State private var visibility = ProjectVisibility.private
	@State private var readme = false
	@State private var defaultBranch = "main"

	private func dismiss() {
		self.presentationMode.wrappedValue.dismiss()
	}

	private func createProject() async {
		var projectDict = [
			"name": projectName,
			"visibility": visibility.rawValue,
		]

		if readme {
			projectDict["initialize_with_readme"] = "true"
			projectDict["default_branch"] = defaultBranch
		}

		do {
			let project = try await API.req(
				type: Project.self,
				method: .post,
				endpoint: "projects",
				body: projectDict
			)

			Notify.status(.success, "Project \(project.name) created.")
			self.dismiss()
		} catch let error {
			Notify.status(.error, error.localizedDescription)
		}
	}

	var body: some View {
		Form {
			VStack(alignment: .leading) {
				TextField("Project name", text: $projectName)
				Text(
					"Must start with a lowercase or uppercase letter, digit, emoji, or underscore. Can also contain dots, pluses, dashes, or spaces."
				)
				.foregroundStyle(.secondary)
				.font(.footnote)
			}

			Picker("Visibility Level", selection: $visibility) {
				Label("Private", systemImage: "lock")
					.tag(ProjectVisibility.private)
				Label("Public", systemImage: "globe")
					.tag(ProjectVisibility.public)
				Label("Internal", systemImage: "shield.lefthalf.filled")
					.tag(ProjectVisibility.internal)
			}

			Toggle("Initialize with README", isOn: $readme)
			if readme {
				VStack(alignment: .leading) {
					TextField("Default branch", text: $defaultBranch)
						.autocorrectionDisabled()
						.textInputAutocapitalization(.never)
					Text("Default branch")
						.foregroundStyle(.secondary)
						.font(.footnote)
				}
			}
		}.toolbar {
			AsyncButton("Create Project", systemImage: "checkmark") {
				await createProject()
			}.tint(.accentColor)
		}
		.navigationTitle("New Project")
		.modifier(ScrollDismissIfAvailable())
	}
}

#Preview {
	NavigationView {
		NewProjectView()
	}
}
