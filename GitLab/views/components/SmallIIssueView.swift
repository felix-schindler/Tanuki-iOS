//
//  SmallIIssueView.swift
//  GitLab
//
//  Created by Felix Schindler on 13.06.23.
//

import SwiftUI

private struct IconView: View {
	let icon: String
	let color: Color
	
	private static let iconMapping: Dictionary<String, Dictionary<String, (icon: String, color: Color)>> = [
		"INCIDENT": [
			"opened": ("exclamationmark.circle", .red),
			"closed": ("exclamationmark.circle", .blue)
		],
		"TEST_CASE": [
			"opened": ("testtube.2", .green),
			"closed": ("minus.circle", .blue)
		],
		"ISSUE": [
			"opened": ("smallcircle.circle", .green),
			"closed": ("minus.circle", .blue)
		]
	]
	
	public init(_ type: String, _ state: String) {
		if let mapping = IconView.iconMapping[type] {
			let (icon, color) = mapping[state]!
			self.icon = icon
			self.color = color
		} else {	// Maybe in the future more types get added, like tasks
			self.icon = IconView.iconMapping["ISSUE"]![state]!.icon
			self.color = IconView.iconMapping["ISSUE"]![state]!.color
		}
	}
	
	var body: some View {
		Image(systemName: icon)
			.foregroundStyle(color)
	}
}

struct SmallIIssueView: View {
	
	// MARK: - Things to display
	@State var issue: Issue
	@State var showRef: Bool
	
	// MARK: - Error states
	@State var stateError: Bool = false
	@State var deleteError: Bool = false
	
	var body: some View {
		NavigationLink(destination: IssueView(issue: issue)) {
			VStack(alignment: .leading) {
				HStack {
					VStack(spacing: 3) {
						IconView(issue.type, issue.state)
						if (issue.confidential) {
							Image(systemName: "lock")
								.foregroundStyle(.orange)
						}
					}
					VStack(alignment: .leading) {
						if (showRef || UIDevice.current.userInterfaceIdiom == .pad) {
							Text(issue.references.full)
								.font(.caption)
								.foregroundStyle(.secondary)
						} else {
							Text(issue.references.short)
								.font(.caption)
								.foregroundStyle(.secondary)
						}
						VStack(alignment: .leading, spacing: 2) {
							Text(issue.title.emojized())
								.fontWeight(.medium)
							ScrollView(.horizontal) {
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
			}
		}.swipeActions {
			AsyncButton(systemImage: (issue.state == "opened" ? "minus.circle" : "circle.circle")) {
				// TODO: Remove issue from list when (filter.state != .all)
				let removedIssue = await IssueModel.changeState(issue.iid, projectId: issue.projectId, state: issue.state)
				stateError = (removedIssue == nil)
			}.alert(isPresented: $stateError, content: {
				Alert(title: Text("Error"), message: Text("Failed to change the state of the issue"), dismissButton: .default(Text("OK")))
			}).tint(.blue)
			AsyncButton(action: {
				// TODO: Remove issue from list
				deleteError = await IssueModel.deleteIssue(issue.iid, projectId: issue.projectId)
			}, role: .destructive, label: {
				Label("Delete issue", systemImage: "trash")
			}).alert("Failed delete issue", isPresented: $deleteError, actions: {
				Button("OK") {
					deleteError = false
				}
			})
			AsyncButton(systemImage: "square.and.arrow.up") {
				await URL(string: issue.webUrl)!.share()
			}
		}
	}
}

struct SmallIIssueView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationStack {
			SmallIIssueView(issue: Issue(id: 119029091, iid: 21, projectId: 33025310, title: "Pipeline in Live Activities", description: "Should be shown of the latest project (with repository) in the latest branch that was viewed", createdAt: Date(), state: "opened", labels: [APILabel(id: 1, name: "enhancement", description: "", color: "#5cb85c", textColor: "#FFFFFF"), APILabel(id: 2, name: "bug", description: "", color: "#d9534f", textColor: "#FFFFFF"), APILabel(id: 3, name: "documentation", description: "", color: "#f0ad4e", textColor: "#FFFFFF")], milestone: Milestone(id: 1, iid: 1, title: "v1.0.1", description: "", state: "active", startDate: nil, dueDate: nil, expired: false, webUrl: "https://gitlab.com/felix-schindler/gitlab-ios/-/milestones/2"), assignees: [UserSmall(id: 9005085, name: "Felix", username: "felix-schindler", avatarUrl: "https://gitlab.com/uploads/-/system/user/avatar/9005085/avatar.png")], author: UserSmall(id: 9005085, name: "Felix", username: "felix-schindler", avatarUrl: "https://gitlab.com/uploads/-/system/user/avatar/9005085/avatar.png"), type: "ISSUE", userNotesCount: 0, upvotes: 1, downvotes: 0, dueDate: "2022-04-01", confidential: true, webUrl: "https://gitlab.com/felix-schindler/gitlab-ios/-/issues/21", references: Reference(short: "#21", full: "felix-schindler/gitlab-ios#21")), showRef: false)
		}
	}
}
