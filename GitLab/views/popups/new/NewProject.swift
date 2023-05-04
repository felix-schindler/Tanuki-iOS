//
//  NewProject.swift
//  GitLab
//
//  Created by Felix Schindler on 04.05.23.
//

import SwiftUI

struct NewProject: View {
	@Environment(\.presentationMode)
	var presentationMode: Binding<PresentationMode>
	
	@State var projectName = ""
	@State var visibility = ProjectVisibility.private
	@State var readme = false
	@State var defaultBranch = "main"

	@State var showError = false

	var body: some View {
		NavigationView {
			Form {
				Section {
					VStack(alignment: .leading) {
						TextField("Project name", text: $projectName)
						Text("Must start with a lowercase or uppercase letter, digit, emoji, or underscore. Can also contain dots, pluses, dashes, or spaces.")
							.foregroundColor(.secondary)
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
				}
				
				Section("Configuration") {
					Toggle("Initialize with README", isOn: $readme)
					if (readme) {
						TextField("Default branch", text: $defaultBranch)
							.disableAutocorrection(true)
					}
				}
				
				Section("Actions") {
					AsyncButton("Create project") {
						await createProject()
					}
					Button("Cancel", role: .destructive, action: dismiss)
				}
			}.navigationTitle("New Project")
				.alert("Failed to create project", isPresented: $showError, actions: {
					Button("OK") {
						showError = false
					}
				})
		}
	}
	
	func dismiss() -> Void {
		self.presentationMode.wrappedValue.dismiss()
	}
	
	func createProject() async -> Void {
		var projectDict = [
			"name": projectName,
			"visibility": visibility.rawValue,
		]
		
		if (readme) {
			projectDict["initialize_with_readme"] = "true"
			projectDict["default_branch"] = defaultBranch
		}
		
		let temp = await API.req(
			type: Project.self,
			method: .post,
			endpoint: "projects",
			body: projectDict
		)

		if (temp == nil) {
			showError = true
		} else {
			self.dismiss()
		}
	}
}

struct NewProject_Previews: PreviewProvider {
	static var previews: some View {
		NewProject()
	}
}
