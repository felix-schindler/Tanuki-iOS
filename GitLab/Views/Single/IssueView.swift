//
//  IssueView.swift
//  GitLab
//
//  Created by Felix Schindler on 30.10.21.
//

import SwiftUI
import MarkdownUI

enum ActiveSheet {
	case newIssue, newNote
}

struct IssueView: View {
	@State var issue: Issue
	
	@State var showNewIssue = false
	@State var showNewNote = false
	
	var body: some View {
		List {
			Section("Info") {
				Text(issue.title.emojized())
					.font(.title)
					.fontWeight(.semibold)
					.padding(.bottom, 1)
					.frame(maxWidth: .infinity, alignment: .leading)

				if (issue.description != "") {              // Description is "" and NOT nil when not set
					Markdown(issue.description.emojized())
						.frame(maxWidth: .infinity, alignment: .leading)
				}

				HStack {
					HStack {
						Image(systemName: "smallcircle.circle")
							.foregroundColor(.green)
						Text(issue.references.full)
					}
					Spacer()
					HStack {
						Image(systemName: "person")
						Text(issue.author.name)
					}
				}.foregroundColor(.secondary)

				HStack {
					if (issue.confidential) {
						Image(systemName: "lock")
							.foregroundColor(.orange)
					}
					HStack(spacing: 1) {
						Image(systemName: "hand.thumbsup")
						Text(String(issue.upvotes))
					}
					HStack(spacing: 1) {
						Image(systemName: "hand.thumbsdown")
						Text(String(issue.downvotes))
					}
					if (issue.dueDate != nil) {
						HStack(spacing: 1) {
							Image(systemName: "calendar")
							Text(Date.formToString(issue.dueDate!))
						}
					}
				}.frame(maxWidth: .infinity, alignment: .leading)
					.padding(.top, 2)
			}
			
			Section("Details") {
				if (issue.assignees != nil && !(issue.assignees!.isEmpty)) {
					Section("Assignees") {
						ForEach(issue.assignees!, id: \.id) { assignee in
							HStack {
								Text(assignee.name)
								Spacer()
								Text(assignee.username)
									.foregroundColor(.secondary)
							}
						}
					}
				}
				if (issue.labels != nil && !(issue.labels!.isEmpty)) {
					LabelListView(labels: issue.labels!)
				}
				if (issue.milestone != nil) {
					Text(issue.milestone!.title.emojized())
				}
			}
			Section("Notes") {
				Button("Add new note", action: {
					showNewNote = true
				})
				NotesLoader(id: issue.projectId, iid: issue.iid, type: discussionType.Issue)
			}
		}.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItemGroup(placement: .navigationBarTrailing) {
					Text(issue.state.firstCapitalized)
						.font(.footnote)
						.padding(.horizontal, 6)
						.padding(.vertical, 4)
						.background(issue.state == "opened" ? .green : .blue)
						.foregroundColor(.white)
						.cornerRadius(10)
					Button(action: {
						showNewIssue = true
					}) {
						Image(systemName: "plus.circle")
					}
				}
			}.sheet(isPresented: $showNewIssue) {
				NewIssueView(id: issue.projectId)
			}.sheet(isPresented: $showNewNote) {
				NewNoteView(id: issue.projectId, iid: issue.iid, type: discussionType.Issue)
			}
		/* This does not work because the option "with_labels_details" is missing for single issues
		 .refreshable {
		 let temp = await API.get(type: Issue.self, endpoint: "projects/\(issue.projectId)/issues/\(issue.iid)", query: ["with_labels_details": "true"])
		 if (temp != nil) {
		 issue = temp!
		 }
		 } */
	}
}

struct IssueView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationView {
			IssueView(issue: Issue(id: 119029091, iid: 21, projectId: 33025310, title: "View Pipeline in Live Activities", description: "Should be shown of the latest project (with repository) in the latest branch that was viewed", createdAt: Date(), state: "opened", labels: [APILabel(id: 1, name: "enhancement", color: "#5cb85c", textColor: "#FFFFFF"), APILabel(id: 2, name: "bug", color: "#d9534f", textColor: "#FFFFFF"), APILabel(id: 3, name: "documentation", color: "#f0ad4e", textColor: "#FFFFFF")], milestone: nil, assignees: nil, author: UserSmall(id: 9005085, name: "Felix", username: "felix-schindler", avatarUrl: "https://gitlab.com/uploads/-/system/user/avatar/9005085/avatar.png"), type: "ISSUE", userNotesCount: 0, upvotes: 5, downvotes: 2, confidential: false, references: Reference(short: "#21", full: "felix-schindler/gitlab-ios#21")))
		}
	}
}
