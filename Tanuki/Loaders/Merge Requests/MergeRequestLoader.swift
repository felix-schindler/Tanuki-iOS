//
//  MergeRequest.swift
//  Tanuki
//
//  Created by Felix Schindler on 27.02.24.
//

import GitLabAPI
import MarkdownUI
import SwiftUI

struct MergeRequestLoader: View {
	private let fullPath: String
	private let iid: String

	@State
	private var project: GitLabAPI.MergeRequestQuery.Data.Project? = nil

	@State
	private var loadFailed = false

	@State
	private var newNoteContent = ""

	@State
	private var newNoteError = false

	@State
	private var showMergeStatus = false

	init(fullPath: String, iid: String) {
		self.fullPath = fullPath
		self.iid = iid
	}

	private func loadMergeRequest() {
		Network.shared.apollo.fetch(
			query: MergeRequestQuery(fullPath: self.fullPath, iid: self.iid)
		) { result in
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

	private var main: some View {
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
							Text(Date.fromToString(mr.createdAt))
						}.font(.footnote)
							.padding(.bottom, 1)

						Text(mr.title.emojized())
							.font(.title3)
							.fontWeight(.medium)
							.padding(.bottom, 1)

						ScrollView(.horizontal) {
							HStack(spacing: 5) {
								if let author = mr._author {
									ScrollView(.horizontal) {
										AuthorView(author)
									}
								}

								if mr.sourceProject?.fullPath == self.fullPath
									|| mr.sourceProject?.fullPath == nil
								{
									PillView(
										mr.sourceBranch,
										bgColor: .blue,
										fgColor: .white,
										cornerRadius: 5
									)
									.monospaced()
									.textSelection(.enabled)
								} else {
									NavigationLink(
										destination: ProjectLoader(
											fullPath: mr.sourceProject!.fullPath),
										label: {
											PillView(
												"\(mr.sourceProject!.fullPath)/\(mr.sourceBranch)",
												bgColor: .blue,
												fgColor: .white,
												cornerRadius: 5
											)
											.monospaced()
											.textSelection(.enabled)
										})
								}

								Image(systemName: "arrow.right")

								PillView(
									mr.targetBranch,
									bgColor: .blue,
									fgColor: .white,
									cornerRadius: 5
								)
								.monospaced()
								.textSelection(.enabled)
							}
						}.font(.footnote)

						if mr.author != nil || mr.diffStatsSummary != nil {
							ScrollView(.horizontal) {
								HStack(spacing: 5) {
									if let diffStats = mr.diffStatsSummary {
										PillView(
											"\(diffStats.fileCount) files",
											icon: "doc.text",
											cornerRadius: 5
										)
										PillView(
											"+\(diffStats.additions)",
											fgColor: .green,
											cornerRadius: 5
										).monospaced()
										PillView(
											"-\(diffStats.deletions)",
											fgColor: .red,
											cornerRadius: 5
										).monospaced()
									}
								}
							}
							.font(.footnote)
							.monospacedDigit()
						}

						if mr.description?.isNotEmpty ?? false {
							Markdown(mr.description!.emojized())
								.markdownTheme(.gitLab)
						}

						HStack {
							Button(
								action: {
									// TODO: Toggle like
								},
								label: {
									HStack(spacing: 5) {
										Image(systemName: "hand.thumbsup")
										Text(String(mr.upvotes))
									}
								})
							Button(
								action: {
									// TODO: Toggle like
								},
								label: {
									HStack(spacing: 5) {
										Image(systemName: "hand.thumbsdown")
										Text(String(mr.downvotes))
									}
								})
						}
						.controlSize(.small)
						.buttonStyle(.bordered)
						.font(.footnote)
						.foregroundStyle(.primary)
					}

					Section("Details") {
						let assgineeCount = mr.assignees?.nodes?.count ?? 0
						DisclosureGroup(
							content: {
								if assgineeCount > 0 {
									ForEach(mr.assignees!.nodes!, id: \.self) {
										maybeUser in
										if let user = maybeUser {
											NavigationLink(
												destination: UserLoader(
													username: user.username),
												label: {
													HStack {
														if let url =
															URL.fromAvatar(
																user.avatarUrl)
														{
															AvatarImage(
																url,
																size: .small)
														}
														Text(user.username)
													}
												}
											)
										}
									}
								} else {
									Text("There are no assignees")
								}
							},
							label: {
								Label(
									title: {
										Text("Assignees")
										Spacer()
										Text(String(assgineeCount))
									},
									icon: {
										Image(systemName: "person.crop.circle")
									})
							}
						)

						let reviewerCount = mr.reviewers?.nodes?.count ?? 0
						DisclosureGroup(
							content: {
								if reviewerCount > 0 {
									ForEach(mr.reviewers!.nodes!, id: \.self) {
										maybeUser in
										if let user = maybeUser {
											NavigationLink(
												destination: UserLoader(
													username: user.username),
												label: {
													HStack {
														if let url =
															URL.fromAvatar(
																user.avatarUrl)
														{
															AvatarImage(
																url,
																size: .small)
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
								Label(
									title: {
										Text("Reviewers")
										Spacer()
										Text(String(reviewerCount))
									},
									icon: {
										Image(
											systemName:
												"person.line.dotted.person.fill"
										)
									})
							}
						)

						DisclosureGroup(
							content: {
								NavigationLink(
									"Commits",
									destination: MrCommitsLoader(
										fullPath: self.fullPath,
										iid: self.iid
									)
								)
								NavigationLink(
									"Diff stats",
									destination: DiffsStatsLoader(
										fullPath: self.fullPath,
										iid: self.iid
									)
								)

								let projectId = project.id.toIntId()
								let iid = self.iid.toIntId()
								NavigationLink(
									"Diffs",
									destination: DiffLoader(
										projectId: projectId ?? 0,
										iid: iid ?? 0
									)
								).disabled(projectId == nil || iid == 0)
							},
							label: {
								Label(
									"Details",
									systemImage: "filemenu.and.selection")
							}
						)

						if (mr.labels?.nodes?.count ?? 0) > 0 {
							Label(
								title: {
									ScrollView(.horizontal) {
										HStack {
											ForEach(
												mr.labels!.nodes!, id: \.self
											) { maybeLabel in
												if let label = maybeLabel {
													PillView(
														label.title,
														bgColor: Color(
															hex: label.color),
														fgColor: Color(
															hex: label.textColor
														)
													)
												}
											}
										}
									}
								},
								icon: {
									Image(systemName: "tag")
								})
						}

						if let milestone = mr.milestone {
							Label(
								milestone.title,
								systemImage: "signpost.right.and.left")
						}

						if mr.humanTimeEstimate != nil
							|| mr.humanTotalTimeSpent != nil
						{
							Label(
								title: {
									HStack {
										Text(
											"Estimate: \(mr.humanTimeEstimate ?? "none")"
										)
										Spacer()
										Text(
											"Spent: \(mr.humanTotalTimeSpent ?? "none")"
										)
									}
								},
								icon: {
									Image(systemName: "hourglass")
								})
						}
					}

					let showMergeSection =
						(mr.userPermissions.canApprove
							|| mr.userPermissions.canMerge
							|| mr.userPermissions.updateMergeRequest)
					if showMergeSection {
						Section("Actions") {
							if mr.userPermissions.canMerge
								&& mr.mergeStatusEnum != nil
							{
								Button(
									action: {
										if mr.mergeStatusEnum != .canBeMerged {
											showMergeStatus = true
											Haptics.shared.play(.light)
										} else {
											// TODO: Show OPTIONS for merge
										}
									},
									label: {
										MergeStatus(mr.mergeStatusEnum!)
									}
								).sheet(isPresented: $showMergeStatus) {
									VStack(alignment: .leading) {
										PopupHeader(
											title: "Detailed merge status",
											onClose: {
												showMergeStatus = false
											})

										if mr.conflicts {
											Label(
												title: {
													Text(
														"Merge conflicts must be resolved."
													)
												},
												icon: {
													Image(
														systemName:
															"minus.circle.fill"
													)
													.foregroundStyle(.red)
												})
										}

										if let detailedMergeStatus = mr
											.detailedMergeStatus
										{
											DetailedMergeStatusView(
												detailedMergeStatus)
										}
									}
									.padding()
									.presentationDetents([.fraction(0.2)])
								}
							}

							if mr.userPermissions.canApprove {
								if mr.approved {
									Button(
										"Revoke approval",
										systemImage: "person.fill.xmark"
									) {
										// TODO: Implement
										Haptics.shared.notify(.error)
									}.tint(.red)
								} else {
									Button(
										"Approve",
										systemImage: "person.fill.checkmark"
									) {
										// TODO: Implement
										Haptics.shared.notify(.error)
									}.tint(.green)
								}
							}

							if mr.userPermissions.updateMergeRequest {
								if mr.state == .opened {
									Button(
										action: {
											// TODO: Implement
											Haptics.shared.notify(.error)
										},
										label: {
											Label(
												"Close MR",
												systemImage:
													"arrow.triangle.swap")
										}
									).tint(.blue)
								} else if mr.state == .closed {
									Button(
										action: {
											// TODO: Implement
											Haptics.shared.notify(.error)
										},
										label: {
											Label(
												"Reopen MR",
												systemImage:
													"arrow.triangle.swap")
										}
									).tint(.green)
								}

								Button("Delete MR", systemImage: "trash") {
									// TODO: Implement
									Haptics.shared.notify(.error)
								}.tint(.red)
							}
						}
					}

					let noteCount = mr.notes.nodes?.count ?? 0
					if mr.userPermissions.createNote || noteCount > 0 {
						Section("Notes (\(mr.userNotesCount ?? 0))") {
							if mr.userPermissions.createNote {
								HStack {
									TextField(
										"New note",
										text: $newNoteContent,
										axis: .vertical
									)
									RoundIconButton("Comment", icon: "arrow.up") {
										// TODO: Save note
										if newNoteContent.isEmpty {
											Haptics.shared.notify(.error)
											newNoteError = true
										} else {
											Haptics.shared.notify(.success)
											newNoteContent = ""
										}
									}.alert(
										"Failed to create new note",
										isPresented: $newNoteError,
										actions: {
											Button("OK") {
												newNoteError = false
											}
										})
								}
							}

							if noteCount > 0 {
								ForEach(mr.notes.nodes!, id: \.self?.id) {
									maybeNote in
									if let note = maybeNote {
										NoteView(note)
									}
								}
							}
						}
					}
				}
			} else if loadFailed {
				VStack {
					Text(failedToLoad)
				}.frame(maxWidth: .infinity, minHeight: 100)
			} else {
				VStack {
					ProgressView("Loading merge request")
				}.frame(maxWidth: .infinity, minHeight: 100)
			}
		}.onAppear {
			loadMergeRequest()
		}.refreshable {
			loadMergeRequest()
		}.toolbar {
			if let state = self.project?.mergeRequest?.state {
				PillView(
					state.rawValue.firstCapitalized,
					icon: MergeStateHelper.getIconByState(state),
					bgColor: MergeStateHelper.getColorByState(state),
					fgColor: .white,
					cornerRadius: 5
				)
				.labelStyle(.titleAndIcon)
				.font(.footnote)
			}

			if let url = project?.mergeRequest?.webUrl {
				ShareButton(URL(string: url)!)
			}
		}.scrollDismissesKeyboard(.immediately)
	}
}

#Preview {
	NavigationStack {
		MergeRequestLoader(fullPath: "felix-schindler/gitlab-ios", iid: "1")
	}
}
