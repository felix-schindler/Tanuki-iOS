//
//  MergeRequestsView.swift
//  GitLab
//
//  Created by Felix Schindler on 30.10.21.
//

import SwiftUI

struct MergeListView: View {
	@State var mergeRequests: [MergeRequest]
	@State var updateFunction: () async -> [MergeRequest]?
	
	@State var showRef = false
	
	var body: some View {
		if (mergeRequests.isEmpty) {
			Text("You're all caught up, there are no open merge requests! 🥳")
		} else {
			List(mergeRequests, id: \.id) { mr in
				NavigationLink(destination: MergeView(mergeRequest: mr)) {
					HStack {
						Image(systemName: "exclamationmark.circle")
							.foregroundColor(.blue)
						VStack(alignment: .leading) {
							if (showRef || UIDevice.current.userInterfaceIdiom == .pad) {
								Text(mr.references.full)
									.font(.caption)
									.foregroundColor(.secondary)
							} else {
								Text(mr.references.short)
									.font(.caption)
									.foregroundColor(.secondary)
							}
							VStack(alignment: .leading, spacing: 2) {
								Text(mr.title.emojized())
									.fontWeight(.medium)
								HStack {
									HStack(spacing: 2) {
										Image(systemName: "text.bubble")
										Text(String(mr.userNotesCount))
									}
									HStack(spacing: 2) {
										Image(systemName: "hand.thumbsup")
										Text(String(mr.upvotes))
									}
									HStack(spacing: 2) {
										Image(systemName: "clock")
										Text(mr.createdAt.toDateString(.short))
									}
									HStack(spacing: 2) {
										Image(systemName: "person")
										Text(mr.author.name)
									}
								}.font(.footnote)
							}
						}
					}
				}
			}.refreshable {
				let temp = await updateFunction()
				if (temp != nil) {
					mergeRequests = temp!
				}
			}
		}
	}
}

struct MergeListView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationView {
			MergeListView(mergeRequests: [MergeRequest(id: 199059114, iid: 9414, projectId: 7898047, title: "epan: Allow nested dependent packets", description: "Save all dependent frames when there are multiple levels\nof reassembly.\n\nThis is a retry of !6329, combined with the fix in !6509 which\nwere reverted in !6545.\n\nepan: fix a segfault, introduced in !6329\n\n\n(cherry picked from commit f870c6085dc3d34c68eae36b5d6de860c6a7b11a)", state: "merged", createdAt: Date(), mergedBy: UserSmall(id: 9005085, name: "Felix", username: "felix-schindler", avatarUrl: "https://gitlab.com/uploads/-/system/user/avatar/9005085/avatar.png"), mergeUser: UserSmall(id: 9005085, name: "Felix", username: "felix-schindler", avatarUrl: "https://gitlab.com/uploads/-/system/user/avatar/9005085/avatar.png"), mergedAt: Date(), closedBy: nil, closedAt: nil, targetBranch: "release-4.0", sourceBranch: "cherry-pick-f870c608", userNotesCount: 6, upvotes: 0, downvotes: 0, author: UserSmall(id: 9005085, name: "Felix", username: "felix-schindler", avatarUrl: "https://gitlab.com/uploads/-/system/user/avatar/9005085/avatar.png"), assignees: [UserSmall(id: 9005085, name: "Felix", username: "felix-schindler", avatarUrl: "https://gitlab.com/uploads/-/system/user/avatar/9005085/avatar.png")], reviewers: [], labels: [APILabel(id: 2, name: "bug", color: "#d9534f", textColor: "#FFFFFF")], draft: false, workInProgress: false, milestone: Milestone(id: 2337336, iid: 2, title: "Wireshark release 4.0", description: "Issues and merge requests for the 4.0.0 release, which is currently unscheduled. Major changes include:\r\n\r\n* Dropping support for 32-bit Windows.\r\n* Shipping our Windows and macOS packages with Qt 6.\r\n* Display filter syntax fixes and enhancements.\r\n* Conversation UI updates.\r\n* Various build requirement updates."), mergeWhenPipelineSucceeds: false, mergeStatus: "can_be_merged", detailedMergeStatus: "not_open", references: Reference(short: "!9414", full: "wireshark/wireshark!9114"), webUrl: "https://gitlab.com/wireshark/wireshark/-/merge_requests/9414", pipeline: Pipeline(id: 788804086, ref: "refs/merge-requests/9414/head", status: "success", source: "merge_request_event", createdAt: Date()), mergeError: nil)], updateFunction: { nil }, showRef: true)
		}
	}
}
