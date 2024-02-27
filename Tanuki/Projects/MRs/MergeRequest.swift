//
//  MergeRequest.swift
//  Tanuki
//
//  Created by Felix Schindler on 27.02.24.
//

import SwiftUI
import GitLabAPI
import MarkdownUI

struct MergeRequest: View {
	private let fullPath: String
	private let iid: String
	
	@State
	private var project: GitLabAPI.MergeRequestQuery.Data.Project? = nil
	
	@State
	private var loadFailed = false
	
	@State
	private var newNoteContent = ""
	
	init(fullPath: String, iid: String) {
		self.fullPath = fullPath
		self.iid = iid
	}
	
	private func loadMergeRequest() {
		Network.shared.apollo.fetch(query: MergeRequestQuery(fullPath: self.fullPath, iid: self.iid)) { result in
			switch result {
			case .success(let graphQLResult):
				print("Success! Setting mergeRequest...")
				project = graphQLResult.data?.project
			case .failure(let error):
				print("Failure! Error: \(error)")
				loadFailed = true
			}
		}
	}
	
#if !os(macOS)
	public var body: some View {
		main.navigationBarTitleDisplayMode(.inline)
	}
#else
	public var body: some View {
		main
	}
#endif
	
	var main: some View {
		List {
			if let project = self.project {
				if let mr = project.mergeRequest {
					VStack(alignment: .leading) {
						HStack(spacing: 5) {
							if let url = URL.fromAvatar(project.avatarUrl) {
								AvatarImage(url, size: .tiny)
							}
							ScrollView(.horizontal) {
								Text(mr.reference)
									.foregroundStyle(.secondary)
							}
							Spacer()
							HStack(spacing: 2) {
								Image(systemName: "clock")
								Text(Date.fromToString(mr.createdAt))
							}
						}.font(.footnote)
							.padding(.bottom, 1)
						
						Text(mr.title)
							.font(.title3)
							.fontWeight(.medium)
							.padding(.bottom, 1)
						
						ScrollView(.horizontal) {
							HStack(spacing: 5) {
								if let author = mr.author {
									ScrollView(.horizontal) {
										NavigationLink(
											destination: Namespace(fullPath: author.username),
											label: {
												Label(title: {
													Text(author.name)
												}, icon: {
													if let url = URL.fromAvatar(author.avatarUrl) {
														AvatarImage(url, size: .tiny)
													} else {
														Image(systemName: "person")
													}
												})
											}
										)
										.buttonStyle(.plain)
										.tint(.primary)
										.padding(.horizontal, 8)
										.padding(.vertical, 3)
										.background(Color(.systemGray5))
										.foregroundStyle(.primary)
										.cornerRadius(5)
									}
								}
								Pill(
									mr.state.rawValue.firstCapitalized,
									icon: MergeStateHelper.getIconByState(mr.state),
									bgColor: MergeStateHelper.getColorByState(mr.state),
									fgColor: .white,
									cornerRadius: 5
								)
								Pill(
									mr.sourceProject?.fullPath == self.fullPath
									? mr.sourceBranch
									: "\(mr.sourceProject?.fullPath ?? "")/\(mr.sourceBranch)",
									bgColor: .blue,
									fgColor: .white,
									cornerRadius: 5
								)
								Image(systemName: "arrow.right")
								Pill(
									mr.targetBranch,
									bgColor: .blue,
									fgColor: .white,
									cornerRadius: 5
								)
							}
						}.font(.footnote)
						
						if (mr.description?.isNotEmpty ?? false) {
							Markdown(mr.description!)
						}
						
						HStack {
							Button(String(mr.upvotes), systemImage: "hand.thumbsup") {
								// TODO: Toggle like
							}.buttonStyle(.bordered)
								.controlSize(.mini)
							Button(String(mr.downvotes), systemImage: "hand.thumbsdown") {
								// TODO: Toggle dislike
							}.buttonStyle(.bordered)
								.controlSize(.mini)
						}
						.font(.footnote)
						.foregroundStyle(.primary)
					}
					
					Section("Merge") {
						DisclosureGroup(
							content: {
								if ((mr.reviewers?.nodes?.count ?? 0) > 0) {
									ForEach(mr.reviewers!.nodes!, id: \.self) { maybeUser in
										if let user = maybeUser {
											NavigationLink(
												destination: Namespace(fullPath: user.username),
												label: {
													HStack {
														if let url = URL.fromAvatar(user.avatarUrl) {
															AvatarImage(url, size: .small)
														}
														Text(user.username)
													}
												}
											)
										}
									}
								} else {
									Text("There are no reviewers")
								}
							},
							label: {
								Label("Reviewers", systemImage: "person.2")
							}
						)
						
						if (mr.userPermissions.canMerge &&
							mr.mergeStatusEnum != nil) {
							VStack {
								Button(action: {
									// TODO: Show merge options
								}, label: {
									MergeStatus(mr.mergeStatusEnum!)
										.frame(maxWidth: .infinity)
								})
								.tint(MergeStatusHelper.getColorByStatus(mr.mergeStatusEnum!))
								.buttonStyle(.bordered)
							}
						}
					}
					
					Section("Notes (\(mr.notes.nodes?.count ?? 0))") {
						if (mr.userPermissions.createNote) {
							HStack {
								TextField(
									"New note",
									text: $newNoteContent,
									axis: .vertical
								)
								RoundIconButton("Comment", icon: "arrow.up") {
									// TODO: Save note
									newNoteContent = ""
								}
							}
						}
						
						if (mr.notes.nodes != nil &&
							mr.notes.nodes!.count > 0) {
							ForEach(mr.notes.nodes!, id: \.self?.id) { maybeNote in
								if let note = maybeNote {
									NoteView(note)
								}
							}
						}
					}
				}
			} else if (loadFailed) {
				VStack {
					Text(LOAD_FAILED)
				}.frame(maxWidth: .infinity, minHeight: 100)
			} else {
				VStack {
					ProgressView("Loading merge requests")
				}.frame(maxWidth: .infinity, minHeight: 100)
			}
		}.onAppear {
			loadMergeRequest()
		}.refreshable {
			loadMergeRequest()
		}.toolbar {
			if let url = project?.mergeRequest?.webUrl {
				ShareButton(URL(string: url)!)
			}
		}.scrollDismissesKeyboard(.immediately)
	}
}

#Preview {
	NavigationStack {
		MergeRequest(fullPath: "felix-schindler/gitlab-ios", iid: "1")
	}
}
