//
//  NewMilestoneView.swift
//  Tanuki
//
//  Created by Felix Schindler on 21.09.25.
//

import HighlightedTextEditor
import SwiftUI

struct NewMilestoneView: View {
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

	private func dismiss() {
		self.presentationMode.wrappedValue.dismiss()
	}

	private func createMilestone() async {
		var newMilestone = [
			"title": title
		]

		if !desc.isEmpty {
			newMilestone["description"] = desc
		}

		if setDates {
			let inputFormatter = DateFormatter()
			inputFormatter.dateFormat = "yyyyMMdd"

			newMilestone["start_date"] = inputFormatter.string(from: startDate)
			newMilestone["due_date"] = inputFormatter.string(from: dueDate)
		}

		do {
			_ = try await API.req(
				type: RestAPIMilestone.self,
				method: .post,
				endpoint: (id != 0 ? "projects/\(id)/milestones" : "groups/\(groupId)/milestones"),
				body: newMilestone
			)

			self.dismiss()
		} catch let error {
			Notify.status(.error, error.localizedDescription)
		}
	}

	public var body: some View {
		NavigationStack {
			Form {
				TextField("Title", text: $title)

				Section("Dates") {
					Toggle("Set dates", isOn: $setDates)

					if setDates {
						DatePicker("Start Date", selection: $startDate)
						DatePicker("Due Date", selection: $dueDate)
					}
				}

				Section("Description (optional)") {
					HighlightedTextEditor(text: $desc, highlightRules: .markdown)
						.frame(minHeight: 100)
				}
			}.toolbar {
				AsyncButton("Create milestone", systemImage: "checkmark") {
					await createMilestone()
				}.tint(.accentColor)
			}.navigationTitle("New Milestone")
		}
	}
}

#Preview {
	NewMilestoneView(id: 33_025_310, groupId: 0)
}
