//
//  MergeView.swift
//  GitLab
//
//  Created by Felix Schindler on 31.10.21.
//

import SwiftUI
import MarkdownUI

struct MergeView: View {
	@State var mergeRequest: MergeRequest
	
	@State var showNewNote = false
	
	var body: some View {
		List {
			Section {
				Text(mergeRequest.title.emojized())
					.font(.title)
					.fontWeight(.semibold)
				
				if (mergeRequest.description != "") {
					Markdown(mergeRequest.description.emojized())
				}
				
				HStack {
					HStack(spacing: 2) {
						Image(systemName: "exclamationmark.circle")
						Text(String(mergeRequest.iid))
					}
					Spacer()
					HStack(spacing: 2) {
						Image(systemName: "person")
						Text(mergeRequest.author.name)
					}
					Spacer()
					HStack(spacing: 2) {
						Image(systemName: "clock")
						Text(mergeRequest.createdAt.toString(.short))
					}
				}
				
				HStack {
					HStack(spacing: 2) {
						Image(systemName: "hand.thumbsup")
						Text(String(mergeRequest.upvotes))
					}
					HStack(spacing: 2) {
						Image(systemName: "hand.thumbsdown")
						Text(String(mergeRequest.downvotes))
					}
				}
			}
			
			Section("Details") {
				if (mergeRequest.assignees != nil && !(mergeRequest.assignees!.isEmpty)) {
					HStack {
						Image(systemName: "person.circle")
						ScrollView(.horizontal) {
							ForEach(mergeRequest.assignees!, id: \.id) { assignee in
								HStack {
									Text(assignee.name)
								}
							}
						}
					}
				}
				if (mergeRequest.labels != nil && !(mergeRequest.labels!.isEmpty)) {
					HStack {
						Image(systemName: "tag.circle")
						ScrollView(.horizontal) {
							HStack {
								LabelListView(labels: mergeRequest.labels!)
							}
						}
					}
				}
				if (mergeRequest.milestone != nil) {
					HStack {
						Image(systemName: "signpost.right.and.left")
						Text(mergeRequest.milestone!.title.emojized())
					}
				}
			}
			
			Section("Notes") {
				Button("Add new note") {
					showNewNote = true
				}
				NotesLoader(id: mergeRequest.projectId, iid: mergeRequest.iid, type: discussionType.Merge)
			}
		}.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				Text(mergeRequest.state.firstCapitalized)
					.font(.footnote)
					.padding(.horizontal, 6)
					.padding(.vertical, 4)
					.background((mergeRequest.state == "merged") ? .blue : (mergeRequest.state == "closed") ? .red : .green)
					.foregroundStyle(.white)
					.cornerRadius(10)
				AsyncButton(systemImage: "square.and.arrow.up") {
					await URL(string: mergeRequest.webUrl)!.share()
				}
			}.sheet(isPresented: $showNewNote) {
				NewNoteView(id: mergeRequest.projectId, iid: mergeRequest.iid, type: discussionType.Merge)
			}
	}
}

struct MergeView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationView {
			MergeView(mergeRequest: MergeRequest(id: 199059114, iid: 9414, projectId: 7898047, title: "epan: Allow nested dependent packets", description: "Save all dependent frames when there are multiple levels\nof reassembly.\n\nThis is a retry of !6329, combined with the fix in !6509 which\nwere reverted in !6545.\n\nepan: fix a segfault, introduced in !6329\n\n\n(cherry picked from commit f870c6085dc3d34c68eae36b5d6de860c6a7b11a)", state: "merged", createdAt: Date(), mergedBy: UserSmall(id: 9005085, name: "Felix", username: "felix-schindler", avatarUrl: "https://gitlab.com/uploads/-/system/user/avatar/9005085/avatar.png"), mergeUser: UserSmall(id: 9005085, name: "Felix", username: "felix-schindler", avatarUrl: "https://gitlab.com/uploads/-/system/user/avatar/9005085/avatar.png"), mergedAt: Date(), closedBy: nil, closedAt: nil, targetBranch: "release-4.0", sourceBranch: "cherry-pick-f870c608", userNotesCount: 6, upvotes: 0, downvotes: 0, author: UserSmall(id: 9005085, name: "Felix", username: "felix-schindler", avatarUrl: "https://gitlab.com/uploads/-/system/user/avatar/9005085/avatar.png"), assignees: [UserSmall(id: 9005085, name: "Felix", username: "felix-schindler", avatarUrl: "https://gitlab.com/uploads/-/system/user/avatar/9005085/avatar.png")], reviewers: [], labels: [APILabel(id: 2, name: "bug", description: "", color: "#d9534f", textColor: "#FFFFFF")], draft: false, workInProgress: false, milestone: Milestone(id: 2337336, iid: 2, title: "Wireshark release 4.0", description: "Issues and merge requests for the 4.0.0 release, which is currently unscheduled. Major changes include:\r\n\r\n* Dropping support for 32-bit Windows.\r\n* Shipping our Windows and macOS packages with Qt 6.\r\n* Display filter syntax fixes and enhancements.\r\n* Conversation UI updates.\r\n* Various build requirement updates.", state: "active", startDate: nil, dueDate: nil, expired: false, webUrl: "https://gitlab.com/felix-schindler/gitlab-ios/-/milestones/2"), mergeWhenPipelineSucceeds: false, mergeStatus: "can_be_merged", detailedMergeStatus: "not_open", references: Reference(short: "!9414", full: "wireshark/wireshark!9114"), webUrl: "https://gitlab.com/wireshark/wireshark/-/merge_requests/9414", pipeline: Pipeline(id: 788804086, ref: "refs/merge-requests/9414/head", status: "success", source: "merge_request_event", createdAt: Date()), mergeError: nil))
		}
	}
}
