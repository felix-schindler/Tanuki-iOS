//
//  IssueView.swift
//  GitLab
//
//  Created by Felix Schindler on 30.10.21.
//

import SwiftUI
import MarkdownUI
import SwiftHttp

enum ActiveSheet {
	case newIssue, newNote
}

struct IssueView: View {
	@Environment(\.presentationMode)
	var presentationMode: Binding<PresentationMode>
	
	/// Issue that's being displayed
	@State var issue: Issue
	
	/// Controls whether to show "new" sheets
	@State var showNewIssue = false
	
	/// New Note things
	@State var newNoteContent = ""
	@State var newNoteError = false
	
	/// Controlls the alert after an error occured while changing state
	@State var stateError = false
	
	/// Controlls the alert after issue was deleted
	@State var deletion = false
	@State var deletionError = false
	
	var body: some View {
		List {
			Section {
				Text(issue.title.emojized())
					.font(.title)
					.fontWeight(.semibold)
				
				HStack {
					HStack {
						Image(systemName: "number.circle")
						Text(String(issue.iid))
							.textSelection(.enabled)
					}
					Spacer()
					HStack {
						Image(systemName: "person")
						Text(issue.author.name)
					}
					Spacer()
					HStack {
						Image(systemName: "clock")
						Text(issue.createdAt.toString(.short))
					}
				}
				
				if (issue.description != "") {              // Description is "" and NOT nil when not set
					Markdown(issue.description.emojized())
						.frame(maxWidth: .infinity, alignment: .leading)
				}
				
				HStack {
					HStack(spacing: 2) {
						Image(systemName: "hand.thumbsup")
						Text(String(issue.upvotes))
					}
					HStack(spacing: 2) {
						Image(systemName: "hand.thumbsdown")
						Text(String(issue.downvotes))
					}
					if (issue.confidential) {
						HStack(spacing: 2) {
							Image(systemName: "lock")
								.foregroundStyle(.orange)
							Text("Confidential")
						}
					}
				}
			}
			
			let showAssignees = (issue.assignees != nil && !(issue.assignees!.isEmpty))
			let showLabels = (issue.labels != nil && !(issue.labels!.isEmpty))
			let showMilestone = (issue.milestone != nil)
			let showDueDate = (issue.dueDate != nil)
			
			if (showAssignees || showLabels || showMilestone || showDueDate) {
				Section("Details") {
					if (showAssignees) {
						HStack {
							Image(systemName: "person.circle")
							VStack(alignment: .leading) {
								ForEach(issue.assignees!, id: \.id) { assignee in
									Text(assignee.name)
								}
							}
						}
					}
					
					if (showLabels) {
						HStack {
							Image(systemName: "tag.circle")
							ScrollView(.horizontal) {
								HStack(spacing: 4) {
									LabelListView(labels: issue.labels!, showDescription: false)
								}
							}
						}
					}
					
					if (showMilestone) {
						HStack {
							Image(systemName: "signpost.right.and.left")
							Text(issue.milestone!.title.emojized())
						}
					}
					
					if (showDueDate) {
						HStack {
							Image(systemName: "calendar.badge.clock")
							Text(Date.fromToString(issue.dueDate!))
						}
					}
				}
			}
			
			Section("Actions") {
				let name: String = (issue.state == "opened" ? "Close issue" : "Reopen issue")
				let icon: String = (issue.state == "opened" ? "minus.circle" : "smallcircle.circle")
				
				AsyncButton(action: {
					await changeState()
				}) {
					Label(name, systemImage: icon)
				}.foregroundStyle(
					(issue.state == "opened" ? .blue : .green)
				)
				
				AsyncButton(action: {
					await deleteIssue()
				}, role: .destructive) {
					Label("Delete issue", systemImage: "trash")
				}.foregroundStyle(.red)
			}
			
			Section("Notes") {
				HStack {
					TextField(
						"New note",
						text: $newNoteContent,
						axis: .vertical
					)
					AsyncButton(systemImage: "arrow.up") {
						await saveNewNote()
					}.buttonStyle(.bordered)
						.clipShape(Circle())
				}
				NotesLoader(id: issue.projectId, iid: issue.iid, type: discussionType.Issue)
			}
		}.toolbar {
			PillView(
				issue.state.firstCapitalized,
				bgColor: issue.state == "opened" ? .green : .blue,
				fgColor: .white
			)
			ShareButton(URL(string: issue.webUrl)!)
			RoundIconButton("New Issue", icon: "plus") {
				showNewIssue = true
			}
		}.sheet(isPresented: $showNewIssue) {
			NewIssueView(id: issue.projectId)
		}.alert("Failed to change issue state", isPresented: $stateError, actions: {
			Button("OK") {
				stateError = false
			}
		}).alert("Issue has been deleted", isPresented: $deletion, actions: {
			Button("OK") {
				deletion = false
				self.presentationMode.wrappedValue.dismiss()
			}
		}).alert("Failed to delete issue", isPresented: $deletionError, actions: {
			Button("OK") {
				deletionError = false
			}
		}).navigationBarTitleDisplayMode(.inline)
			.scrollDismissesKeyboard(.interactively)
	}
	
	private func changeState() async -> Void {
		if let res = await IssueModel.changeState(issue.iid, projectId: issue.projectId, state: issue.state) {
			issue = res
		} else {
			stateError = true
		}
	}
	
	private func deleteIssue() async -> Void {
		deletion = await IssueModel.deleteIssue(issue.iid, projectId: issue.projectId)
		deletionError = !deletion
	}
	
	private func saveNewNote() async -> Void {
		// TODO: Do sth with the res; Handle errors
		if (!newNoteContent.trim().isEmpty) {
			if let _ = await API.req(type: Note.self, method: .post, endpoint: "projects/\(issue.projectId)/issues/\(issue.iid)/notes", query: ["body": newNoteContent]) {
				newNoteContent = ""
			} else {
				// TODO: Maybe show another toast?
			}
		} else {
			// TODO: Maybe show toast?
		}
	}
}

struct IssueView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationStack {
			IssueView(issue: Issue(id: 119029091, iid: 21, projectId: 33025310, title: "Pipeline in Live Activities", description: "Should be shown of the latest project (with repository) in the latest branch that was viewed", createdAt: Date(), state: "opened", labels: [APILabel(id: 1, name: "enhancement", description: "", color: "#5cb85c", textColor: "#FFFFFF"), APILabel(id: 2, name: "bug", description: "", color: "#d9534f", textColor: "#FFFFFF"), APILabel(id: 3, name: "documentation", description: "", color: "#f0ad4e", textColor: "#FFFFFF")], milestone: Milestone(id: 1, iid: 1, title: "v1.0.1", description: "", state: "active", startDate: nil, dueDate: nil, expired: false, webUrl: "https://gitlab.com/felix-schindler/gitlab-ios/-/milestones/2"), assignees: [UserSmall(id: 9005085, name: "Felix", username: "felix-schindler", avatarUrl: "https://gitlab.com/uploads/-/system/user/avatar/9005085/avatar.png")], author: UserSmall(id: 9005085, name: "Felix", username: "felix-schindler", avatarUrl: "https://gitlab.com/uploads/-/system/user/avatar/9005085/avatar.png"), type: "ISSUE", userNotesCount: 0, upvotes: 1, downvotes: 0, dueDate: "2022-04-01", confidential: true, webUrl: "https://gitlab.com/felix-schindler/gitlab-ios/-/issues/21", references: Reference(short: "#21", full: "felix-schindler/gitlab-ios#21")))
		}
	}
}
