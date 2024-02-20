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
		VStack {
			Form {
				Section {
					VStack(alignment: .leading) {
						TextField("Project name", text: $projectName)
						Text("Must start with a lowercase or uppercase letter, digit, emoji, or underscore. Can also contain dots, pluses, dashes, or spaces.")
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
					if (readme) {
						VStack(alignment: .leading) {
							TextField("Default branch", text: $defaultBranch)
								.disableAutocorrection(true)
							Text("Default branch")
								.foregroundStyle(.secondary)
								.font(.footnote)
						}
					}
				}.presentationDetents([.large, .fraction(0.6)])
			}
			
			VStack {
				AsyncButton(action: {
					await createProject()
				}, label: {
					Text("Create Project")
						.frame(maxWidth: .infinity)
				}).tint(.green)
					.buttonStyle(.bordered)
					.controlSize(.large)

				Button(role: .cancel,
					   action: {
					self.presentationMode.wrappedValue.dismiss()
				}, label: {
					Text("Cancel")
						.frame(maxWidth: .infinity)
				}).foregroundStyle(.secondary)
					.buttonStyle(.bordered)
					.controlSize(.large)
			}.padding()
		}.alert("Failed to create project", isPresented: $showError, actions: {
			Button("OK") {
				showError = false
			}
		})
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
		@State var presented = true
		
		NavigationStack {
		}.sheet(isPresented: $presented) {
			NewProject()
		}
	}
}
