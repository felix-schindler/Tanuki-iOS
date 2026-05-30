//
//  Issue.swift
//  Tanuki
//
//  Created by Felix Schindler on 31.10.21.
//  Rewritten by Felix Schindler on 27.02.24.
//

import GitLabAPI
//import MarkdownUI
import SwiftUI

private extension Issue_Project_Issue_Author {
	var toMyAuthor: MyAuthor {
		MyAuthor(avatarUrl: avatarUrl, name: name ?? username ?? "", username: username ?? "")
	}
}

private extension Issue_Project_Issue_Notes_Nodes_Author {
	var toMyAuthor: MyAuthor {
		MyAuthor(avatarUrl: avatarUrl, name: name ?? username ?? "", username: username ?? "")
	}
}

private struct NoteWrapper: Note {
	let note: Issue_Project_Issue_Notes_Nodes

	var system: Bool { note.system == "true" }
	var systemNoteIconName: String? { note.systemNoteIconName }
	var body: String { note.body ?? "" }
	var _author: MyAuthor? {
		guard let author = note.author else { return nil }
		return author.toMyAuthor
	}
	var createdAt: String { note.createdAt ?? "" }
	var updatedAt: String { note.updatedAt ?? "" }
	var maxAccessLevelOfAuthor: String? { note.maxAccessLevelOfAuthor }
}

struct IssueLoader: View {
	@Environment(\.dismiss) var dismiss

	private let fullPath: String
	private let iid: String

	@State var project: Result<GitLabAPI.Issue_Project, Error>? = nil

	@State var showDeleteConfirm = false

	init(fullPath: String, iid: String) {
		self.fullPath = fullPath
		self.iid = iid
	}

	// MARK: - Data loading
	private func loadIssue() {
		Task {
			do {
				let project = try await Network.shared.service.fetchIssue(fullPath: fullPath, iid: iid)
				self.project = .success(project)
			} catch let error {
				self.project = .failure(error)
				Notify.status(.error)
			}
		}
	}

	private func reloadIssue() async {
		do {
			let project = try await Network.shared.service.fetchIssue(fullPath: fullPath, iid: iid, strategy: .networkOnly)
			self.project = .success(project)
			Notify.status(.success)
		} catch let error {
			self.project = .failure(error)
			Notify.status(.error)
		}
	}

	// MARK: - Issue mutations
	private func changeState(_ state: IssueStateEvent) async {
		do {
			_ = try await Network.shared.service.fetchIssueState(
				projectPath: fullPath, iid: iid, filter: IssueStateFilter(stateEvent: state)
			)
			await reloadIssue()
		} catch let error {
			Notify.status(.error, "Failed to change issue state", error.localizedDescription)
		}
	}

	private func deleteIssue(_ projectId: Int) async {
		do {
			try await API.delete(endpoint: "projects/\(projectId)/issues/\(self.iid)")
			Notify.status(.success, "Issue #\(self.iid) was deleted", systemImage: "trash")
			self.dismiss()
		} catch let error {
			Notify.status(.error, "Failed to delete issue", error.localizedDescription)
		}
	}

	public var body: some View {
		List {
			if let project {
				switch project {
				case .success(let project):
					if let issue = project.issue {
						VStack(alignment: .leading) {
							HStack(spacing: 5) {
								if let url = URL.fromAvatar(project.avatarUrl) {
									AvatarImage(url, size: .tiny)
								}
								ScrollView(.horizontal) {
									Text(issue.reference ?? "")
										.foregroundStyle(.secondary)
								}
								Spacer()
								Text(Date.fromToString(issue.createdAt ?? ""))
							}
							.font(.footnote)
							.padding(.bottom, 1)

							Text(issue.title?.emojized() ?? "")
								.font(.title3)
								.fontWeight(.medium)
								.padding(.bottom, 1)

							ScrollView(.horizontal) {
								HStack(spacing: 5) {
									if let author = issue.author {
										AuthorView(author.toMyAuthor)
									}

									if let weight = issue.weight {
										PillView(
											weight,
											icon: "scalemass",
											bgColor: .red,
											fgColor: .white,
											cornerRadius: 5
										)
										.font(.system(.footnote, design: .monospaced))
										.textSelection(.enabled)
									}

									if let dueDate = issue.dueDate {
										PillView(
											Date.fromToString(dueDate),
											icon: "alarm",
											bgColor: .blue,
											fgColor: .white,
											cornerRadius: 5
										)
									}

								if let blockedBy = issue.blockedByIssues?.nodes,
									blockedBy.isNotEmpty
								{
									ForEach(blockedBy, id: \.iid) { parent in
											if let parent {
												NavigationLink(
													destination: {
														IssueLoader(
															fullPath: self.fullPath,
															iid: parent.iid ?? ""
														)
													},
													label: {
														PillView(
															"#\(parent.iid ?? "")",
															icon: "hand.raised",
															bgColor: .orange,
															fgColor: .white,
															cornerRadius: 5
														)
													}
												)
											}
										}
									}
								}
								.font(.footnote)
								.monospacedDigit()
							}

							if let description = issue.description?.emojized(),
								description.isNotEmpty
							{
								Markdown(description)
									.markdownTheme(.gitLab)
							}

							HStack {
								PillView(issue.upvotes ?? "0", icon: "hand.thumbsup")
								PillView(issue.downvotes ?? "0", icon: "hand.thumbsdown")
							}
							.modifier(LabelSpacingIfAvailable())
							.font(.footnote)
						}

						Section("Details") {
							let assgineeCount = issue.assignees?.nodes?.count ?? 0
							DisclosureGroup(
								content: {
									if assgineeCount > 0 {
										ForEach(issue.assignees!.nodes!, id: \.username) { user in
												NavigationLink(
													destination: UserLoader(
														username: user.username ?? ""
													),
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
															Text(user.username ?? "")
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
											HStack {
												Text("Assignees")
												Spacer()
												Text(String(assgineeCount))
											}
										},
										icon: {
											Image(systemName: "person.crop.circle")
										})
								}
							)

							if let labels = issue.labels?.nodes, labels.isNotEmpty {
								Label(
									title: {
										ScrollView(.horizontal) {
											HStack {
											ForEach(labels, id: \.title) { label in
												PillView(
													label.title?.emojized() ?? "",
													bgColor: Color(hex: label.color ?? ""),
													fgColor: Color(hex: label.textColor ?? "")
												)
											}
											}
										}
									},
									icon: {
										Image(systemName: "tag")
									}
								)
							}

							if let milestone = issue.milestone {
								Label(
									milestone.title?.emojized() ?? "",
									systemImage: "diamond"
								)
							}

							if issue.humanTimeEstimate != nil
								|| issue.humanTotalTimeSpent != nil
							{
								Label(
									title: {
										HStack {
											Text(
												"Estimate: \(issue.humanTimeEstimate ?? "none")"
											)
											Spacer()
											Text(
												"Spent: \(issue.humanTotalTimeSpent ?? "none")"
											)
										}
									},
									icon: {
										Image(systemName: "hourglass")
									})
							}
						}

						if issue.userPermissions?.updateIssue == "true" {
							Section("Actions") {
								if issue.state == "opened" {
									AsyncButton("Close issue", systemImage: "smallcircle.circle") {
										await self.changeState(.close)
									}.tint(.blue)
								} else if issue.state == "closed" {
									AsyncButton("Reopen issue", systemImage: "arrow.triangle.swap") {
										await self.changeState(.reopen)
									}.tint(.green)
								}

								if let projectId = project.id?.toIntId() {
									Button("Delete issue", systemImage: "trash", role: .destructive) {
										self.showDeleteConfirm = true
									}.confirmationDialog(
										"Are you sure you want to delete issue #\(self.iid)?",
										isPresented: $showDeleteConfirm, titleVisibility: .visible
									) {
										AsyncButton("Delete", role: .destructive) {
											await self.deleteIssue(projectId)
										}
										Button("Cancel", role: .cancel) {
											showDeleteConfirm = false
										}
									}.tint(.red)
								}
							}
						}

						let noteCount = issue.notes?.nodes?.count ?? 0
						if issue.userPermissions?.createNote == "true" || noteCount > 0 {
							Section("Notes (\(issue.userNotesCount ?? "0"))") {
								if let projectId = project.id?.toIntId(),
									issue.userPermissions?.createNote == "true"
								{
									NewNoteView(projectId, iid: issue.iid ?? "", type: .issue)
								}

								if noteCount > 0 {
									ForEach(issue.notes!.nodes!, id: \.id) { note in
										NoteView(NoteWrapper(note: note), projectId: project.id?.toIntId() ?? 0)
									}
								}
							}
						}
					} else {
						NoContentView(
							"Issue was not found", systemImage: "smallcircle.circle")
					}
				case .failure(let error):
					FailedView(error)
				}
			} else {
				LoadingView(
					"Loading Issue #\(self.iid)", systemImage: "smallcircle.circle", color: .green)
			}
		}.onAppear {
			loadIssue()
		}.refreshable {
			await reloadIssue()
		}.toolbar {
			if let project, case .success(let project) = project,
				let issue = project.issue
			{
				HStack {
					IssueStateIcon(issue.state)

					if let url = URL(string: issue.webUrl ?? "") {
						ShareButton(url)
					}
				}
			}
		}
		.navigationBarTitleDisplayMode(.inline)
		.modifier(ScrollDismissIfAvailable())
	}
}

#Preview {
	NavigationView {
		IssueLoader(fullPath: "felix-schindler/gitlab-ios", iid: "111")
	}
}
