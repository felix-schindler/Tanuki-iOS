//
//  Issue.swift
//  Tanuki
//
//  Created by Felix Schindler on 31.10.21.
//  Rewritten by Felix Schindler on 27.02.24.
//

import GitLabAPI
import MarkdownUI
import SwiftUI

struct IssueLoader: View {
	private let fullPath: String
	private let iid: String

	@State
	private var project: Result<GitLabAPI.IssueQuery.Data.Project, Error>? = nil

	@State
	private var newNoteContent = ""

	@State var newNoteError = false

	init(fullPath: String, iid: String) {
		self.fullPath = fullPath
		self.iid = iid
	}

	private func loadIssue() {
		do {
			let responses = try Network.shared.apollo.fetch(
				query: IssueQuery(fullPath: self.fullPath, iid: self.iid),
				cachePolicy: .cacheAndNetwork
			)

			Task {
				for try await response in responses {
					if let project = response.data?.project {
						self.project = .success(project)
					} else if let errors = response.errors {
						for error in errors {
							Notify.status(.error, error.localizedDescription)
						}
					}
				}
			}
		} catch let error {
			self.project = .failure(error)
			Notify.status(.error)
		}
	}

	private func reloadIssue() async {
		do {
			let response = try await Network.shared.apollo.fetch(
				query: IssueQuery(fullPath: self.fullPath, iid: self.iid),
				cachePolicy: .networkOnly
			)

			if let project = response.data?.project {
				self.project = .success(project)
			}

			Notify.status(.success)
		} catch let error {
			self.project = .failure(error)
			Notify.status(.error)
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
									Text(issue.reference)
										.foregroundStyle(.secondary)
								}
								Spacer()
								Text(Date.fromToString(issue.createdAt))
							}
							.font(.footnote)
							.padding(.bottom, 1)

							Text(issue.title.emojized())
								.font(.title3)
								.fontWeight(.medium)
								.padding(.bottom, 1)

							ScrollView(.horizontal) {
								HStack(spacing: 5) {
									AuthorView(issue._author)

									if let weight = issue.weight {
										PillView(
											String(weight),
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

									if let blockedBy = issue.blockedByIssues?.nodes, blockedBy.isNotEmpty {
										ForEach(blockedBy, id: \.?.iid) { parent in
											if let parent {
												NavigationLink(
													destination: {
														IssueLoader(
															fullPath: self.fullPath,
															iid: parent.iid
														)
													},
													label: {
														PillView(
															"#\(parent.iid)",
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
							
							if let description = issue.description?.emojized(), description.isNotEmpty {
								Markdown(description)
									.markdownTheme(.gitLab)
							}

							HStack {
								Button(
									action: {
										// TODO: Toggle like
										Notify.status(.error, "Not yet implemented")
									},
									label: {
										HStack(spacing: 5) {
											Image(systemName: "hand.thumbsup")
											Text(String(issue.upvotes))
										}
									})
								Button(
									action: {
										// TODO: Toggle dislike
										Notify.status(.error, "Not yet implemented")
									},
									label: {
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
									if assgineeCount > 0 {
										ForEach(issue.assignees!.nodes!, id: \.self) { maybeUser in
											if let user = maybeUser {
												NavigationLink(
													destination: UserLoader(
														username: user.username
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
												ForEach(labels, id: \.?.title) { label in
													if let label {
														PillView(
															label.title.emojized(),
															bgColor: Color(hex: label.color),
															fgColor: Color(hex: label.textColor)
														)
													}
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
									milestone.title.emojized(),
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

						if issue.userPermissions.updateIssue {
							Section("Actions") {
								if issue.state == .opened {
									Button("Close issue", systemImage: "smallcircle.circle") {
										// TODO: Implement
										Notify.status(.error, "Not yet implemented")
									}.tint(.blue)
								} else if issue.state == .closed {
									Button("Reopen issue", systemImage: "arrow.triangle.swap") {
										// TODO: Implement
										Notify.status(.error, "Not yet implemented")
									}.tint(.green)
								}

								Button("Delete issue", systemImage: "trash", role: .destructive) {
									// TODO: Implement
									Notify.status(.error, "Not yet implemented")
								}.tint(.red)
							}
						}

						let noteCount = issue.notes.nodes?.count ?? 0
						if issue.userPermissions.createNote || noteCount > 0 {
							Section("Notes (\(issue.userNotesCount))") {
								if issue.userPermissions.createNote {
									HStack {
										TextField(
											"New note",
											text: $newNoteContent
										)
										RoundIconButton("Comment", icon: "arrow.up") {
											// TODO: Save note
											if newNoteContent.isEmpty {
												Notify.status(.error, "Please provide content")
												newNoteError = true
											} else {
												Notify.status(.success)
												newNoteContent = ""
											}
										}
									}
								}

								if noteCount > 0 {
									ForEach(issue.notes.nodes!, id: \.self?.id) { maybeNote in
										if let note = maybeNote {
											NoteView(note, projectId: project.id.toIntId() ?? 0)
										}
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
					Button(
						issue.state.rawValue.firstCapitalized,
						systemImage: IssueStateHelper.getIconByState(issue.state),
					) {}
					.tint(IssueStateHelper.getColorByState(issue.state))
					.labelStyle(.titleAndIcon)
					.buttonBorderShape(.roundedRectangle)
					.buttonStyle(.borderedProminent)
					.controlSize(.mini)

					if let url = URL(string: issue.webUrl) {
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
