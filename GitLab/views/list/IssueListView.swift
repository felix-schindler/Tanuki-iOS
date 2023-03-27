//
//  IssuesView.swift
//  GitLab
//
//  Created by Felix Schindler on 30.10.21.
//

import SwiftUI

struct IssueListView: View {
	@State var issues: [Issue]
	@State var updateFunction: () async -> [Issue]?
	
	@State var showRef: Bool = false
	
	@State var stateError: Bool = false
	@State var deleteError: Bool = false
	
	var body: some View {
		List {
			if (issues.isEmpty) {
				Text("You're all caught up, there are no issues! 🚀")
			} else {
				ForEach(issues, id: \.id) { issue in
					NavigationLink(destination: IssueView(issue: issue)) {
						VStack(alignment: .leading) {
							HStack {
								VStack(spacing: 3) {
									if (issue.type == "INCIDENT") {
										Image(systemName: "exclamationmark.circle")
											.foregroundColor(.red)
									} else {
										if (issue.state == "opened") {
											Image(systemName: "smallcircle.circle")
												.foregroundColor(.green)
										} else {
											Image(systemName: "minus.circle")
												.foregroundColor(.blue)
										}
									}
									if (issue.confidential) {
										Image(systemName: "lock")
											.foregroundColor(.orange)
									}
								}
								VStack(alignment: .leading) {
									if (showRef || UIDevice.current.userInterfaceIdiom == .pad) {
										Text(issue.references.full)
											.font(.caption)
											.foregroundColor(.secondary)
									} else {
										Text(issue.references.short)
											.font(.caption)
											.foregroundColor(.secondary)
									}
									VStack(alignment: .leading, spacing: 2) {
										Text(issue.title.emojized())
											.fontWeight(.medium)
										HStack {
											HStack(spacing: 2) {
												Image(systemName: "text.bubble")
												Text(String(issue.userNotesCount))
											}
											HStack(spacing: 2) {
												Image(systemName: "hand.thumbsup")
												Text(String(issue.upvotes))
											}
											HStack(spacing: 2) {
												Image(systemName: "clock")
												Text(issue.createdAt.toDateString(.short))
											}
											HStack(spacing: 2) {
												Image(systemName: "person")
												Text(issue.author.name)
											}
										}.font(.footnote)
									}
								}
							}
						}
					}.swipeActions {
						AsyncButton(action: {
							// TODO: Remove issue from list when (filter.state != .all)
							let removedIssue = await IssueModel.changeState(issue.iid, projectId: issue.projectId, state: issue.state)
							stateError = (removedIssue == nil)
						}, label: {
							if (issue.state == "opened") {
								Label("Close issue", systemImage: "minus.circle")
							} else {
								Label("Reopen issue", systemImage: "circle.circle")
							}
						}).alert(isPresented: $stateError, content: {
							Alert(title: Text("Error"), message: Text("Failed to change the state of the issue"), dismissButton: .default(Text("OK")))
						}).tint(.blue)
						Button(role: .destructive,
									 action: {
							Task.init {
								// TODO: Remove issue from list
								deleteError = await IssueModel.deleteIssue(issue.iid, projectId: issue.projectId)
							}
						}, label: {
							Label("Delete issue", systemImage: "trash")
						}).alert(isPresented: $deleteError, content: {
							Alert(title: Text("Error"), message: Text("Failed delete issue"), dismissButton: .default(Text("OK")))
						})
						Button(action: {
							URL(string: issue.webUrl)!.share()
						}, label: {
							Label("Share", systemImage: "square.and.arrow.up")
						})
					}
				}
			}
		}.refreshable {
			let temp = await updateFunction()
			if (temp != nil) {
				issues = temp!
			}
		}
	}
}

struct IssueListView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationView {
			IssueListView(issues: [
				Issue(id: 119029091, iid: 21, projectId: 33025310, title: "View Pipeline in Live Activities", description: "Should be shown of the latest project (with repository) in the latest branch that was viewed", createdAt: Date(), state: "opened", labels: [APILabel(id: 1, name: "enhancement", description: "", color: "#5cb85c", textColor: "#FFFFFF"), APILabel(id: 2, name: "bug", description: "", color: "#d9534f", textColor: "#FFFFFF"), APILabel(id: 3, name: "documentation", description: "", color: "#f0ad4e", textColor: "#FFFFFF")], milestone: Milestone(id: 1, iid: 1, title: "v1.0.1", description: "", state: "active", startDate: nil, dueDate: nil, webUrl: "https://gitlab.com/felix-schindler/gitlab-ios/-/milestones/2"), assignees: [UserSmall(id: 9005085, name: "Felix", username: "felix-schindler", avatarUrl: "https://gitlab.com/uploads/-/system/user/avatar/9005085/avatar.png")], author: UserSmall(id: 9005085, name: "Felix", username: "felix-schindler", avatarUrl: "https://gitlab.com/uploads/-/system/user/avatar/9005085/avatar.png"), type: "ISSUE", userNotesCount: 0, upvotes: 1, downvotes: 0, dueDate: "2022-04-01", confidential: true, webUrl: "https://gitlab.com/felix-schindler/gitlab-ios/-/issues/21", references: Reference(short: "#21", full: "felix-schindler/gitlab-ios#21")),
				Issue(id: 119029092, iid: 22, projectId: 33025310, title: "View Pipeline in Live Activities", description: "Should be shown of the latest project (with repository) in the latest branch that was viewed", createdAt: Date(), state: "opened", labels: [APILabel(id: 1, name: "enhancement", description: "", color: "#5cb85c", textColor: "#FFFFFF"), APILabel(id: 2, name: "bug", description: "", color: "#d9534f", textColor: "#FFFFFF"), APILabel(id: 3, name: "documentation", description: "", color: "#f0ad4e", textColor: "#FFFFFF")], milestone: Milestone(id: 1, iid: 1, title: "v1.0.1", description: "", state: "active", startDate: nil, dueDate: nil, webUrl: "https://gitlab.com/felix-schindler/gitlab-ios/-/milestones/2"), assignees: [UserSmall(id: 9005085, name: "Felix", username: "felix-schindler", avatarUrl: "https://gitlab.com/uploads/-/system/user/avatar/9005085/avatar.png")], author: UserSmall(id: 9005085, name: "Felix", username: "felix-schindler", avatarUrl: "https://gitlab.com/uploads/-/system/user/avatar/9005085/avatar.png"), type: "ISSUE", userNotesCount: 0, upvotes: 3, downvotes: 0, dueDate: "2022-04-01", confidential: false, webUrl: "https://gitlab.com/felix-schindler/gitlab-ios/-/issues/22", references: Reference(short: "#21", full: "felix-schindler/gitlab-ios#21")),
				Issue(id: 119029093, iid: 23, projectId: 33025310, title: "View Pipeline in Live Activities", description: "Should be shown of the latest project (with repository) in the latest branch that was viewed", createdAt: Date(), state: "opened", labels: [APILabel(id: 1, name: "enhancement", description: "", color: "#5cb85c", textColor: "#FFFFFF"), APILabel(id: 2, name: "bug", description: "", color: "#d9534f", textColor: "#FFFFFF"), APILabel(id: 3, name: "documentation", description: "", color: "#f0ad4e", textColor: "#FFFFFF")], milestone: Milestone(id: 1, iid: 1, title: "v1.0.1", description: "", state: "active", startDate: nil, dueDate: nil, webUrl: "https://gitlab.com/felix-schindler/gitlab-ios/-/milestones/2"), assignees: [UserSmall(id: 9005085, name: "Felix", username: "felix-schindler", avatarUrl: "https://gitlab.com/uploads/-/system/user/avatar/9005085/avatar.png")], author: UserSmall(id: 9005085, name: "Felix", username: "felix-schindler", avatarUrl: "https://gitlab.com/uploads/-/system/user/avatar/9005085/avatar.png"), type: "ISSUE", userNotesCount: 0, upvotes: 0, downvotes: 0, dueDate: "2022-04-01", confidential: true, webUrl: "https://gitlab.com/felix-schindler/gitlab-ios/-/issues/23", references: Reference(short: "#21", full: "felix-schindler/gitlab-ios#21"))
			], updateFunction: { return [] }, showRef: false)
		}
	}
}
