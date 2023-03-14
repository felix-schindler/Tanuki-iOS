//
//  IssuesView.swift
//  GitLab
//
//  Created by Felix Schindler on 30.10.21.
//

import SwiftUI

struct IssueListView: View {
	@State var issues: [Issue]
	@State var updateFunction: () async -> Void
	
	@State var showRef: Bool = false
	@State var isError: Bool = false
	
	var body: some View {
		if (issues.isEmpty) {
			Text("You're all caught up, there are no issues in this project! 🚀")
		} else {
			List(issues, id: \.id) { issue in
				NavigationLink(destination: IssueView(issue: issue)) {
					VStack(alignment: .leading) {
						HStack {
							VStack(spacing: 3) {
								if (issue.type == "INCIDENT") {
									Image(systemName: "exclamationmark.circle")
										.foregroundColor(.red)
								} else {
									Image(systemName: "smallcircle.circle")
										.foregroundColor(.green)
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
										.fontWeight(Font.Weight.medium)
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
					Button(action: {
						Task.init {
							isError = await !closeIssue(id: issue.iid, projectId: issue.projectId)
						}
					}, label: {
						Label("Close issue", systemImage: "checkmark.circle")
					}).alert(isPresented: $isError, content: {
						Alert(title: Text("Error"), message: Text("Failed to close issue"), dismissButton: .default(Text("OK")))
					}).tint(.purple)
				}
			}.refreshable {
				await updateFunction()
			}
		}
	}
	
	// TODO: remove from array
	private func closeIssue(id: Int, projectId: Int) async -> Bool {
		let removedIssue = await API.req(type: Issue.self, method: .put, endpoint: "projects/\(projectId)/issues/\(id)?state_event=close")
		return removedIssue != nil
	}
}

struct IssueListView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationView {
			IssueListView(issues: [
				Issue(id: 119029091, iid: 21, projectId: 33025310, title: "View Pipeline in Live Activities", description: "Should be shown of the latest project (with repository) in the latest branch that was viewed", createdAt: Date(), state: "opened", labels: [APILabel(id: 1, name: "enhancement", color: "#5cb85c", textColor: "#FFFFFF"), APILabel(id: 2, name: "bug", color: "#d9534f", textColor: "#FFFFFF"), APILabel(id: 3, name: "documentation", color: "#f0ad4e", textColor: "#FFFFFF")], milestone: Milestone(id: 1, iid: 1, title: "v1.0.1", description: ""), assignees: [UserSmall(id: 9005085, name: "Felix", username: "felix-schindler", avatarUrl: "https://gitlab.com/uploads/-/system/user/avatar/9005085/avatar.png")], author: UserSmall(id: 9005085, name: "Felix", username: "felix-schindler", avatarUrl: "https://gitlab.com/uploads/-/system/user/avatar/9005085/avatar.png"), type: "ISSUE", userNotesCount: 0, upvotes: 1, downvotes: 0, dueDate: "2022-04-01", confidential: true, references: Reference(short: "#21", full: "felix-schindler/gitlab-ios#21")),
				Issue(id: 119029092, iid: 22, projectId: 33025310, title: "View Pipeline in Live Activities", description: "Should be shown of the latest project (with repository) in the latest branch that was viewed", createdAt: Date(), state: "opened", labels: [APILabel(id: 1, name: "enhancement", color: "#5cb85c", textColor: "#FFFFFF"), APILabel(id: 2, name: "bug", color: "#d9534f", textColor: "#FFFFFF"), APILabel(id: 3, name: "documentation", color: "#f0ad4e", textColor: "#FFFFFF")], milestone: Milestone(id: 1, iid: 1, title: "v1.0.1", description: ""), assignees: [UserSmall(id: 9005085, name: "Felix", username: "felix-schindler", avatarUrl: "https://gitlab.com/uploads/-/system/user/avatar/9005085/avatar.png")], author: UserSmall(id: 9005085, name: "Felix", username: "felix-schindler", avatarUrl: "https://gitlab.com/uploads/-/system/user/avatar/9005085/avatar.png"), type: "ISSUE", userNotesCount: 0, upvotes: 3, downvotes: 0, dueDate: "2022-04-01", confidential: false, references: Reference(short: "#21", full: "felix-schindler/gitlab-ios#21")),
				Issue(id: 119029093, iid: 23, projectId: 33025310, title: "View Pipeline in Live Activities", description: "Should be shown of the latest project (with repository) in the latest branch that was viewed", createdAt: Date(), state: "opened", labels: [APILabel(id: 1, name: "enhancement", color: "#5cb85c", textColor: "#FFFFFF"), APILabel(id: 2, name: "bug", color: "#d9534f", textColor: "#FFFFFF"), APILabel(id: 3, name: "documentation", color: "#f0ad4e", textColor: "#FFFFFF")], milestone: Milestone(id: 1, iid: 1, title: "v1.0.1", description: ""), assignees: [UserSmall(id: 9005085, name: "Felix", username: "felix-schindler", avatarUrl: "https://gitlab.com/uploads/-/system/user/avatar/9005085/avatar.png")], author: UserSmall(id: 9005085, name: "Felix", username: "felix-schindler", avatarUrl: "https://gitlab.com/uploads/-/system/user/avatar/9005085/avatar.png"), type: "ISSUE", userNotesCount: 0, upvotes: 0, downvotes: 0, dueDate: "2022-04-01", confidential: true, references: Reference(short: "#21", full: "felix-schindler/gitlab-ios#21"))
			], updateFunction: {}, showRef: false)
		}
	}
}
