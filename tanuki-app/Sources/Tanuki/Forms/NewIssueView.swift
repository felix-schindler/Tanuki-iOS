//
//  NewIssueView.swift
//  Tanuki
//
//  Created by Felix Schindler on 10.09.25.
//

import GitLabAPI
import SwiftUI

enum IssueType: String, CaseIterable {
	case issue = "issue"
	case incident = "incident"
	case test_case = "test_case"
	case task = "task"
}

struct NewIssueView: View {
	@Environment(\.dismiss) var dismiss

	private let id: Int
	private let fullPath: String

	init(id: Int, fullPath: String) {
		self.id = id
		self.fullPath = fullPath
	}

	@State var tags: [Tag]? = nil
	@State var memberships: Result<[Member], Error>? = nil
	@State var milestones: [Milestone]? = nil
	@State var labels: [MyLabel]? = nil

	@State var title = ""
	@State var description = ""
	@State var selectedAssignees: Set<String> = []
	@State var type = IssueType.issue
	@State var confidential = false
	@State var setDueDate = false
	@State var dueDate = SwiftUI.Date()
	@State var selectedLabels: Set<String> = []
	@State var selectedMilestone = ""
	@State var weight = -1

	private func loadMembers() async {
		do {
			let response = try await Network.shared.service.fetchProjectMembers(fullPath: self.fullPath)
			let members = response.projectMembers?.nodes?.map { node -> MemberStruct in
				MemberStruct(
					id: node.id ?? "",
					createdAt: node.createdAt,
					expiresAt: node.expiresAt,
					_accessLevel: node.accessLevel?.stringValue,
					_user: node.user.map { MyAuthor(avatarUrl: $0.avatarUrl, name: $0.name ?? $0.username ?? "", username: $0.username ?? "") },
					_createdBy: node.createdBy.map { MyAuthor(avatarUrl: $0.avatarUrl, name: $0.name ?? $0.username ?? "", username: $0.username ?? "") }
				)
			} ?? []
			self.memberships = .success(members)
		} catch let error {
			self.memberships = .failure(error)
		}
	}

	private func loadMilestones() async {
		do {
			let filter = ProjectMilestonesFilter(
				includeAncestors: false
			)
			let milestones = try await Network.shared.service.fetchProjectMilestones(fullPath: self.fullPath, filter: filter)
			self.milestones = milestones
		} catch let error {
			Notify.status(
				.error,
				"Couldn't load milestones",
				error.localizedDescription,
				systemImage: "exclamationmark.triangle"
			)
		}
	}

	private func loadLabels() async {
		do {
			let labels = try await Network.shared.service.fetchProjectLabels(fullPath: self.fullPath)
			self.labels = labels
		} catch let error {
			Notify.status(
				.error,
				"Couldn't load labels",
				error.localizedDescription,
				systemImage: "exclamationmark.triangle"
			)
		}
	}

	private func createIssue() async {
		var body: [String: EncodableValue] = [:]

		if title.isEmpty {
			Notify.status(.error, "Please enter a title.")
			return
		} else {
			body["title"] = .string(title)
		}

		body["type"] = .string(type.rawValue)

		if description.isNotEmpty {
			body["description"] = .string(description)
		}

		if selectedAssignees.isNotEmpty {
			let ids =
				selectedAssignees.map { id in
					return id.toIntId()
				}.filter { $0 != nil } as! [Int]

			if ids.isNotEmpty {
				body["assignee_id"] = .int(ids.first!)
				body["assignee_ids"] = .intArray(ids)
			}
		}

		if confidential {
			body["confidential"] = .boolean(true)
		}

		if setDueDate {
			let inputFormatter = DateFormatter()
			inputFormatter.dateFormat = "yyyyMMdd"

			body["due_date"] = .string(inputFormatter.string(from: dueDate))
		}

		if selectedLabels.isNotEmpty {
			body["labels"] = .array(Array(selectedLabels))
		}

		if selectedMilestone.isNotEmpty {
			body["milestone_id"] = .string(selectedMilestone)
		}

		if weight >= 0 {
			body["weight"] = .string(String(weight))
		}

		do {
			let temp = try await API.req(
				type: RestAPIIssue.self,
				method: .post,
				endpoint: "projects/\(self.id)/issues",
				body: body
			)

			Notify.status(.success, "Issue #\(temp.iid) created")
			self.dismiss()
		} catch let error {
			Notify.status(.error, "Failed to create new issue", error.localizedDescription)
		}
	}

	var body: some View {
		Form {
			TextField("Title (required)", text: $title)

			Section("Description (Markdown supported)") {
				TextEditor(text: $description)
					.frame(minHeight: 100)
			}

			Section {
				if let memberships {
					switch memberships {
					case .success(let memberships):
						if memberships.isEmpty {
							NoContentView("There are no project members", systemImage: "person.2")
						} else {
							Menu("Select Assignees") {
								ForEach(memberships, id: \.id) { member in
									Button {
										if selectedAssignees.contains(member.id) {
											selectedAssignees.remove(member.id)
										} else {
											selectedAssignees.insert(member.id)
										}
									} label: {
										if selectedAssignees.contains(member.id) {
											if let username = member._user?.username {
												Label("@\(username)", systemImage: "checkmark")
											} else {
												Label(member.id, systemImage: "checkmark")
											}
										} else {
											if let username = member._user?.username {
												Text("@\(username)")
											} else {
												Text(member.id)
											}
										}
									}
								}
							}
						}
					case .failure(let error):
						FailedView(error)
					}
				} else {
					LoadingView("Loading project members", systemImage: "person.2")
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

				if let labels, labels.isNotEmpty {
					Menu("Select Labels") {
						ForEach(labels, id: \.title) { label in
							Button {
								if selectedLabels.contains(label.title) {
									selectedLabels.remove(label.title)
								} else {
									selectedLabels.insert(label.title)
								}
							} label: {
								if selectedLabels.contains(label.title) {
									Label(label.title.emojized(), systemImage: "checkmark")
								} else {
									Text(label.title.emojized())
								}
							}
						}
					}
				} else {
					Text("There are no Labels")
				}

				if let milestones, milestones.isNotEmpty {
					Picker("Milestone", selection: $selectedMilestone) {
						ForEach(milestones, id: \.iid) { milestone in
							Text(milestone.title)
								.tag(milestone.iid)
						}
					}
				} else {
					Text("There are no Milestones")
				}
				Stepper("Weight: \(weight < 0 ? "none" : String(weight))", value: $weight)
			}
		}.toolbar {
			AsyncButton("Create issue", systemImage: "checkmark") {
				await createIssue()
			}.tint(.accentColor)
		}.onAppear {
			Task {
				await loadMembers()
				await loadMilestones()
				await loadLabels()
			}
		}.refreshable {
			await loadMembers()
			await loadMilestones()
			await loadLabels()
		}
		.navigationTitle("New Issue")
		.modifier(ScrollDismissIfAvailable())
	}
}
