//
//  NewMilestone.swift
//  GitLab
//
//  Created by Felix Schindler on 04.05.23.
//

import SwiftUI

struct NewMilestone: View {
	@Environment(\.presentationMode)
	var presentationMode: Binding<PresentationMode>
	
	/// Project ID
	@State var id: Int
	/// Group ID
	@State var groupId: Int
	
	@State var title = ""
	@State var desc = ""
	
	@State var setDates = true
	@State var startDate = Date()
	@State var dueDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: Date())!
	
	@State var showError = false
	
	var body: some View {
		NavigationView {
			Form {
				TextField("Title", text: $title)
				
				Section("Dates") {
					Toggle("Set dates", isOn: $setDates)

					if (setDates) {
						DatePicker("Start Date", selection: $startDate)
						DatePicker("Due Date", selection: $dueDate)
					}
				}
				
				Section("Description") {
					TextEditor(text: $desc)
				}
				
				Section("Actions") {
					AsyncButton("Create milestone") {
						await createMilestone()
					}
					Button("Cancel", role: .destructive, action: dismiss)
				}
			}.navigationTitle("New Milestone")
				.alert("Failed to create milestone", isPresented: $showError, actions: {
					Button("OK") {
						showError = false
					}
				})
		}
	}
	
	func dismiss() -> Void {
		self.presentationMode.wrappedValue.dismiss()
	}

	func createMilestone() async -> Void {
		var milestoneDic = [
			"title": title
		]
		
		if (!desc.isEmpty) {
			milestoneDic["description"] = desc
		}
		
		if (setDates) {
			let inputFormatter = DateFormatter()
			inputFormatter.dateFormat = "yyyyMMdd"

			milestoneDic["start_date"] = inputFormatter.string(from: startDate)
			milestoneDic["due_date"] = inputFormatter.string(from: dueDate)
		}
		
		let temp = await API.req(
			type: Milestone.self,
			method: .post,
			endpoint: (id != 0 ? "projects/\(id)/milestones" : "groups/\(groupId)/milestones"),
			body: milestoneDic
		)

		if (temp == nil) {
			showError = true
		} else {
			self.dismiss()
		}
	}
}

struct NewMilestone_Previews: PreviewProvider {
	static var previews: some View {
		NewMilestone(id: 33025310, groupId: 0)
	}
}
