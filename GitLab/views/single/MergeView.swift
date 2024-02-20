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
	@State private var newNoteContent = ""
	
	//Mark: - Merge options
	@State private var showMergeOptions: Bool = false
	@State private var mergeCommitMessage: String = ""					// Custom merge commit message.
	@State private var mergeWhenPipelineSucceeds: Bool = false	// If true, the merge request is merged when the pipeline succeeds.
	@State private var sha: String = ""														// If present, then this SHA must match the HEAD of the source branch, otherwise the merge fails.
	@State private var shouldRemoveSourceBranch: Bool = false	// If true, removes the source branch.
	@State private var squashCommitMessage: String = ""					// Custom squash commit message.
	@State private var squash: Bool = false												// If true, the commits are squashed into a single commit on merge.
	
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
				if (!(mergeRequest.assignees?.isEmpty ?? true)) {
					HStack {
						Image(systemName: "person.circle")
						ScrollView(.horizontal) {
							HStack {
								ForEach(mergeRequest.assignees!, id: \.id) { assignee in
									Text(assignee.name)
								}
							}
						}
					}
				}
				if (!(mergeRequest.labels?.isEmpty ?? true)) {
					HStack {
						Image(systemName: "tag.circle")
						ScrollView(.horizontal) {
							HStack {
								ForEach(mergeRequest.labels!, id: \.self) { label in
									PillView(label.emojized())
								}
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
			
			DisclosureGroup(content: {
				NavigationLink("Commits", destination: NotesLoader(id: mergeRequest.projectId, iid: mergeRequest.iid, type: discussionType.Merge))
				NavigationLink("Changes", destination: NotesLoader(id: mergeRequest.projectId, iid: mergeRequest.iid, type: discussionType.Merge))
				NavigationLink("Diffs", destination: NotesLoader(id: mergeRequest.projectId, iid: mergeRequest.iid, type: discussionType.Merge))
			}, label: {
				Label("Manage", systemImage: "person.2")
					.foregroundStyle(.primary)
			})
			
			Section("Actions") {
				if (mergeRequest.state != "merged" &&
					mergeRequest.state != "closed") {
					Button("Merge this requqest", systemImage: "arrow.triangle.pull") {
						showMergeOptions = true
					}
				}
				
				if (mergeRequest.state == "opened" || mergeRequest.state == "closed") {
					let name: String = (mergeRequest.state == "opened" ? "Close MR" : "Reopen MR")
					let icon: String = (mergeRequest.state == "opened" ? "minus.circle" : "arrow.triangle.pull")
					AsyncButton(action: {
						await changeState()
					}) {
						Label(name, systemImage: icon)
					}.foregroundStyle(
						(mergeRequest.state == "opened" ? .blue : .green)
					)
				}
				
				AsyncButton(action: {
					await deleteMR()
				}, role: .destructive) {
					Label("Delete MR", systemImage: "trash")
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
				NotesLoader(id: mergeRequest.projectId, iid: mergeRequest.iid, type: discussionType.Merge)
			}
		}.toolbar {
			PillView(
				mergeRequest.state.firstCapitalized,
				bgColor: (mergeRequest.state == "merged") ? .blue : (mergeRequest.state == "closed") ? .red : .green,
				fgColor: .white
			).font(.footnote)
			AsyncButton(systemImage: "square.and.arrow.up") {
				await URL(string: mergeRequest.webUrl)!.share()
			}
		}.sheet(isPresented: $showMergeOptions) {
			VStack {
				Form {
					Section("Merge Settings - All options are optional") {
						TextField("Custom merge commit message", text: $mergeCommitMessage)
						
						// If true, the merge request is merged when the pipeline succeeds.
						Toggle("Only merge when the pipeline succeeds", isOn: $mergeWhenPipelineSucceeds)
						
						// SHA must match the HEAD of the source branch, otherwise the merge fails
						TextField("SHA", text: $sha)
						
						Toggle("Should remove source branch", isOn: $shouldRemoveSourceBranch)
						
						Toggle("Squash commits", isOn: $squash)
						if (squash) {
							TextField("Custom squash commit message", text: $squashCommitMessage)
						}
					}.presentationDetents([.large, .medium])
				}
				
				VStack {
					AsyncButton(action: {
						await merge()
					}, label: {
						Text("Confirm Merge")
							.frame(maxWidth: .infinity)
					}).tint(.green)
						.buttonStyle(.bordered)
					
					Button(role: .cancel,
						   action: {
						showMergeOptions = false
					}, label: {
						Text("Cancel")
							.frame(maxWidth: .infinity)
					}
					).foregroundStyle(.secondary)
						.buttonStyle(.bordered)
				}.padding(.horizontal)
			}
		}.navigationBarTitleDisplayMode(.inline)
			.scrollDismissesKeyboard(.interactively)
	}
	
	
	// TODO: Import MergeModel file into project
	private func changeState() async -> Void {
		// TODO: Do sth with the res; Handle errors
		_ = await MergeModel.changeState(mergeRequest.iid, projectId: mergeRequest.projectId, state: mergeRequest.state)
	}
	
	private func deleteMR() async -> Void {
		// TODO: Do sth with the res; Handle errors
		_ = await MergeModel.deleteMR(mergeRequest.iid, projectId: mergeRequest.projectId)
	}
	
	private func saveNewNote() async -> Void {
		// TODO: Do sth with the res; Handle errors
		if (!newNoteContent.trim().isEmpty) {
			if let _ = await API.req(type: Note.self, method: .post, endpoint: "projects/\(mergeRequest.projectId)/merge_requests/\(mergeRequest.iid)/notes", query: ["body": newNoteContent]) {
				newNoteContent = ""
			} else {
				// TODO: Maybe show another toast?
			}
		} else {
			// TODO: Maybe show toast?
		}
	}
	
	private func merge() async -> Void {
		var body: Dictionary<String, String> = [:]
		
		if (mergeCommitMessage.isNotEmpty) {
			body["merge_commit_message"] = mergeCommitMessage
		}
		if (mergeWhenPipelineSucceeds) {
			body["merge_when_pipeline_succeeds"] = "true"
		}
		if (sha.isNotEmpty) {
			body["sha"] = sha
		}
		if (shouldRemoveSourceBranch) {
			body["should_remove_source_branch"] = "true"
		}
		if (squashCommitMessage.isNotEmpty) {
			body["squash_commit_message"] = squashCommitMessage
		}
		if (squash) {
			body["squash"] = "true"
		}
		
		if let res = await API.req(
			type: MergeRequest.self,
			method: .put,
			endpoint: "projects/\(mergeRequest.projectId)/merge_requests/\(mergeRequest.iid)/merge",
			body: [
				"": ""
			]
		) {
			mergeRequest = res
		} else {
		}
	}
}

#Preview {
	NavigationStack {
		MergeView(mergeRequest: MergeRequest(
			id: 199059114,
			iid: 9414,
			projectId: 7898047,
			title: "epan: Allow nested dependent packets",
			description: "Save all dependent frames when there are multiple levels\nof reassembly.\n\nThis is a retry of !6329, combined with the fix in !6509 which\nwere reverted in !6545.\n\nepan: fix a segfault, introduced in !6329\n\n\n(cherry picked from commit f870c6085dc3d34c68eae36b5d6de860c6a7b11a)",
			state: "opened",
			createdAt: Date(),
			mergedBy: UserSmall(
				id: 9005085,
				name: "Felix",
				username: "felix-schindler",
				avatarUrl: "https://gitlab.com/uploads/-/system/user/avatar/9005085/avatar.png"
			),
			mergeUser: UserSmall(
				id: 9005085,
				name: "Felix",
				username: "felix-schindler",
				avatarUrl: "https://gitlab.com/uploads/-/system/user/avatar/9005085/avatar.png"
			),
			mergedAt: Date(),
			closedBy: nil,
			closedAt: nil,
			targetBranch: "release-4.0",
			sourceBranch: "cherry-pick-f870c608",
			userNotesCount: 6,
			upvotes: 0,
			downvotes: 0,
			author: UserSmall(
				id: 9005085,
				name: "Felix",
				username: "felix-schindler",
				avatarUrl: "https://gitlab.com/uploads/-/system/user/avatar/9005085/avatar.png"
			),
			assignees: [UserSmall(
				id: 9005085,
				name: "Felix",
				username: "felix-schindler",
				avatarUrl: "https://gitlab.com/uploads/-/system/user/avatar/9005085/avatar.png"
			)],
			reviewers: [],
			labels: [
				"bug"
			],
			draft: false,
			workInProgress: false,
			milestone: Milestone(
				id: 2337336,
				iid: 2,
				title: "Wireshark release 4.0",
				description: "Issues and merge requests for the 4.0.0 release, which is currently unscheduled. Major changes include:\r\n\r\n* Dropping support for 32-bit Windows.\r\n* Shipping our Windows and macOS packages with Qt 6.\r\n* Display filter syntax fixes and enhancements.\r\n* Conversation UI updates.\r\n* Various build requirement updates.",
				state: "active",
				startDate: nil,
				dueDate: nil,
				expired: false,
				webUrl: "https://gitlab.com/felix-schindler/gitlab-ios/-/milestones/2"
			),
			mergeWhenPipelineSucceeds: false,
			mergeStatus: "can_be_merged",
			detailedMergeStatus: "not_open", references: Reference(
				short: "!9414",
				full: "wireshark/wireshark!9114"
			),
			webUrl: "https://gitlab.com/wireshark/wireshark/-/merge_requests/9414",
			pipeline: Pipeline(
				id: 788804086,
				ref: "refs/merge-requests/9414/head",
				status: "success",
				source: "merge_request_event",
				createdAt: Date()
			),
			mergeError: nil)
		)
	}
}
