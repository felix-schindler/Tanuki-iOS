//
//  Issue.swift
//  Tanuki
//
//  Created by Felix Schindler on 27.02.24.
//

import SwiftUI
import GitLabAPI
import MarkdownUI

struct Issue: View {
	private let fullPath: String
	private let iid: String
	
	@State
	private var project: GitLabAPI.IssueQuery.Data.Project? = nil
	
	@State
	private var loadFailed = false
	
	@State
	private var newNoteContent = ""
	
	init(fullPath: String, iid: String) {
		self.fullPath = fullPath
		self.iid = iid
	}
	
	private func loadIssue() {
		Network.shared.apollo.fetch(query: IssueQuery(fullPath: self.fullPath, iid: self.iid)) { result in
			switch result {
			case .success(let graphQLResult):
				print("Success! Setting issue...")
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
				if let issue = project.issue {
					VStack(alignment: .leading) {
						HStack(spacing: 5) {
							if let url = URL.fromAvatar(project.avatarUrl) {
								AvatarImage(url, size: .tiny)
							}
							ScrollView(.horizontal) {
								Text(issue.reference)
									.foregroundStyle(.secondary)
							}
							Spacer()
							Text(Date.fromToString(issue.createdAt))
						}.font(.footnote)
							.padding(.bottom, 1)
						
						Text(issue.title)
							.font(.title3)
							.fontWeight(.medium)
							.padding(.bottom, 1)
						
						ScrollView(.horizontal) {
							HStack(spacing: 5) {
								Pill(
									issue.state.rawValue.firstCapitalized,
									icon: IssueStateHelper.getIconByState(issue.state),
									bgColor: IssueStateHelper.getColorByState(issue.state),
									fgColor: .white,
									cornerRadius: 5
								)
								NavigationLink(
									destination: Namespace(fullPath: issue.author.username),
									label: {
										Label(
											title: {
												Text(
													issue.author.name.isNotEmpty
													? issue.author.name
													: issue.author.username
												)
											}, icon: {
												if let url = URL.fromAvatar(issue.author.avatarUrl) {
													AvatarImage(url, size: .tiny)
												} else {
													Image(systemName: "person")
												}
											}
										)
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
						}.font(.footnote)
						
						ScrollView(.horizontal) {
							HStack(spacing: 5) {
								if let weight = issue.weight {
									Pill(
										String(weight),
										icon: "scalemass",
										bgColor: .red,
										fgColor: .white,
										cornerRadius: 5
									)
									.monospaced()
									.textSelection(.enabled)
								}
								
								if let dueDate = issue.dueDate {
									Pill(
										Date.fromToString(dueDate),
										icon: "alarm",
										bgColor: .blue,
										fgColor: .white,
										cornerRadius: 5
									)
									.monospaced()
									.textSelection(.enabled)
								}

								if ((issue.blockedByIssues?.nodes?.count ?? 0) > 0) {
									ForEach(issue.blockedByIssues!.nodes!, id: \.self?.iid) { maybeParent in
										if let parent = maybeParent {
											NavigationLink(destination: {
												Issue(fullPath: self.fullPath, iid: parent.iid)
											}, label: {
												Pill(
													"#\(parent.iid)",
													icon: "hand.raised",
													cornerRadius: 5
												)
											})
										}
									}
								}
							}
							.font(.footnote)
							.monospacedDigit()
						}
						
						if (issue.description?.isNotEmpty ?? false) {
							Markdown(issue.description!)
						}
						
						HStack {
							Button(action: {
								// TODO: Toggle like
							}, label: {
								HStack(spacing: 5) {
									Image(systemName: "hand.thumbsup")
									Text(String(issue.upvotes))
								}
							})
							Button(action: {
								// TODO: Toggle like
							}, label: {
								HStack(spacing: 5) {
									Image(systemName: "hand.thumbsdown")
									Text(String(issue.downvotes))
								}
							})
						}
						.controlSize(.small)
						.buttonStyle(.bordered)
						.font(.footnote)
						.foregroundStyle(.primary)
					}
					
					Section("Details") {
						let assgineeCount = issue.assignees?.nodes?.count ?? 0
						DisclosureGroup(
							content: {
								if (assgineeCount > 0) {
									ForEach(issue.assignees!.nodes!, id: \.self) { maybeUser in
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
									Text("There are no assignees")
								}
							},
							label: {
								Label(title: {
									Text("Assignees")
									Spacer()
									Text(String(assgineeCount))
								}, icon: {
									Image(systemName: "person.crop.circle")
								})
							}
						)
						
						if ((issue.labels?.nodes?.count ?? 0) > 0) {
							Label(title: {
								ScrollView(.horizontal) {
									HStack {
										ForEach(issue.labels!.nodes!, id: \.self) { maybeLabel in
											if let label = maybeLabel {
												Pill(
													label.title,
													bgColor: Color(hex: label.color),
													fgColor: Color(hex: label.textColor)
												)
											}
										}
									}
								}
							}, icon: {
								Image(systemName: "tag")
							})
						}
						
						if let milestone = issue.milestone {
							Label(milestone.title, systemImage: "signpost.right.and.left")
						}
						
						if (issue.humanTimeEstimate != nil || issue.humanTotalTimeSpent != nil) {
							Label(title: {
								HStack {
									Text("Estimate: \(issue.humanTimeEstimate ?? "none")")
									Spacer()
									Text("Spent: \(issue.humanTotalTimeSpent ?? "none")")
								}
							}, icon: {
								Image(systemName: "hourglass")
							})
						}
					}
					
					if (issue.userPermissions.updateIssue) {
						Section("Actions") {
							Button(action: {
								// TODO: Implement
							}, label: {
								Label("Close MR", systemImage: "arrow.triangle.swap")
							}).tint(.blue)
						}
					}
					
					Section("Notes (\(issue.userNotesCount))") {
						if (issue.userPermissions.createNote) {
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
						
						if ((issue.notes.nodes?.count ?? 0) > 0) {
							ForEach(issue.notes.nodes!, id: \.self?.id) { maybeNote in
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
					ProgressView("Loading issue")
				}.frame(maxWidth: .infinity, minHeight: 100)
			}
		}.onAppear {
			loadIssue()
		}.refreshable {
			loadIssue()
		}.toolbar {
			if let url = project?.issue?.webUrl {
				ShareButton(URL(string: url)!)
			}
		}.scrollDismissesKeyboard(.immediately)
	}
}

#Preview {
	NavigationStack {
		Issue(fullPath: "felix-schindler/gitlab-ios", iid: "1")
	}
}
