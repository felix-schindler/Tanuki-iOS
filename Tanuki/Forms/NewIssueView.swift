//
//  NewIssueView.swift
//  Tanuki
//
//  Created by Felix Schindler on 10.09.25.
//

import HighlightedTextEditor
import SwiftUI

enum IssueType: String, CaseIterable {
	case issue = "issue"
	case incident = "incident"
	case test_case = "test_case"
	case task = "task"
}

struct NewIssueView: View {
	@Environment(\.presentationMode)
	var presentationMode: Binding<PresentationMode>

	private let id: Int

	init(id: Int) {
		self.id = id
	}

	@State private var title = ""
	@State private var description = ""
	@State private var selectedAssignees = ""
	@State private var type = IssueType.issue
	@State private var confidential = false
	@State private var setDueDate = false
	@State private var dueDate = Date()
	@State private var selectedLabels = ""
	@State private var selectedMilestone = ""
	@State private var weight = -1

	private func dismiss() {
		self.presentationMode.wrappedValue.dismiss()
	}

	private func createIssue() async {
		var body: [String: String] = [:]
		
		if title.isEmpty {
			Notify.status(.error, "Please enter a title.")
			return
		} else {
			body["title"] = title
		}
		
		body["type"] = type.rawValue
		
		if description.isNotEmpty {
			body["description"] = description
		}
		
		if selectedAssignees.isNotEmpty {
			// maybe use "assignee_ids"?
			body["assignee_id"] = selectedAssignees
		}
		
		if confidential {
			body["confidential"] = "true"
		}
		
		if setDueDate {
			let inputFormatter = DateFormatter()
			inputFormatter.dateFormat = "yyyyMMdd"
			
			body["due_date"] = inputFormatter.string(from: dueDate)
		}
		
		if selectedLabels.isNotEmpty {
			body["labels"] = selectedLabels
		}
		
		if selectedMilestone.isNotEmpty {
			body["milestone_id"] = selectedMilestone
		}
		
		if weight >= 0 {
			body["weight"] = String(weight)
		}
		
		do {
			_ = try await API.req(
				type: RestAPIIssue.self,
				method: .post,
				endpoint: "projects/\(self.id)/issues",
				body: body
			)
			
			self.dismiss()
		} catch let error {
			Notify.status(.error, "Failed to create new issue", error.localizedDescription)
		}
	}

	var body: some View {
		Form {
			TextField("Title (required)", text: $title)
			
			Section("Description (Markdown supported)") {
				HighlightedTextEditor(text: $description, highlightRules: .markdown)
					.frame(minHeight: 100)
			}
			
			Section {
				Picker("Assignees", selection: $selectedAssignees) {
					Text("Not implemented")
						.tag("test_123")
				}
			}
			
			Section {
				Picker("Type", selection: $type) {
					ForEach(IssueType.allCases, id: \.rawValue) { type in
						Text(type.rawValue.capitalized.replacing("_", with: " "))
							.tag(type)
					}
				}
				VStack(alignment: .leading) {
					Toggle("Confidential", isOn: $confidential)
					Text("Limit visibility to project members with at least the Planner role.")
						.foregroundStyle(.secondary)
						.font(.footnote)
				}
				VStack(alignment: .leading) {
					Toggle("Set due date", isOn: $setDueDate)
					if setDueDate {
						DatePicker("Due date", selection: $dueDate, displayedComponents: .date)
					}
				}
				Picker("Labels", selection: $selectedLabels) {
					Text("Not implemented")
						.tag("test_123")
				}
				Picker("Milestone", selection: $selectedMilestone) {
					Text("Not implemented")
						.tag("test_123")
				}
				Stepper("Weight: \(weight < 0 ? "none" : String(weight))", value: $weight)
			}
		}.toolbar {
			AsyncButton("Create issue", systemImage: "checkmark") {
				await createIssue()
			}.tint(.accentColor)
		}
		.navigationTitle("New Issue")
		.modifier(ScrollDismissIfAvailable())
	}
}

#Preview {
	NavigationView {
		NewIssueView(id: 278_964)
	}
}
