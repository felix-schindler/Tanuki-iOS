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
							}.font(.footnote)
								.padding(.bottom, 1)

							Text(issue.title.emojized())
								.font(.title3)
								.fontWeight(.medium)
								.padding(.bottom, 1)

							ScrollView(.horizontal) {
								AuthorView(issue._author)
							}.font(.footnote)

							ScrollView(.horizontal) {
								HStack(spacing: 5) {
									if let weight = issue.weight {
										PillView(
											String(weight),
											icon: "scalemass",
											bgColor: .red,
											fgColor: .white,
											cornerRadius: 5
										)
										.font(.system(.body, design: .monospaced))
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

									if (issue.blockedByIssues?.nodes?.count ?? 0)
										> 0
									{
										ForEach(
											issue.blockedByIssues!.nodes!,
											id: \.self?.iid
										) { maybeParent in
											if let parent = maybeParent {
												NavigationLink(
													destination: {
														IssueLoader(
															fullPath: self.fullPath,
															iid: parent.iid)
													},
													label: {
														PillView(
															"#\(parent.iid)",
															icon: "hand.raised",
															bgColor: .orange,
															fgColor: .white,
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

							if issue.description?.isNotEmpty ?? false {
								Markdown(issue.description!.emojized())
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
											Text(String(issue.upvotes))
										}
									})
								Button(
									action: {
										// TODO: Toggle like
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

							if (issue.labels?.nodes?.count ?? 0) > 0 {
								Label(
									title: {
										ScrollView(.horizontal) {
											HStack {
												ForEach(
													issue.labels!.nodes!, id: \.self
												) { maybeLabel in
													if let label = maybeLabel {
														PillView(
															label.title.emojized(),
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

							if let milestone = issue.milestone {
								Label(
									milestone.title.emojized(),
									systemImage: "signpost.right.and.left")
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
									Button(
										action: {
											// TODO: Implement
											Notify.status(.error, "Not yet implemented")
										},
										label: {
											Label(
												"Close issue",
												systemImage: "smallcircle.circle")
										}
									).tint(.blue)
								} else if issue.state == .closed {
									Button(
										action: {
											// TODO: Implement
											Notify.status(.error, "Not yet implemented")
										},
										label: {
											Label(
												"Reopen issue",
												systemImage: "arrow.triangle.swap")
										}
									).tint(.green)
								}
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
									ForEach(issue.notes.nodes!, id: \.self?.id) {
										maybeNote in
										if let note = maybeNote {
											NoteView(note)
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
			if let project {
				switch project {
				case .success(let project):
					if let issue = project.issue {
						PillView(
							issue.state.rawValue.firstCapitalized,
							icon: IssueStateHelper.getIconByState(issue.state),
							bgColor: IssueStateHelper.getColorByState(issue.state),
							fgColor: .white,
							cornerRadius: 5
						)
						.labelStyle(.titleAndIcon)
						.font(.footnote)

						if let url = URL(string: issue.webUrl) {
							ShareButton(url)
						}
					}
				case .failure:
					EmptyView()
				}
			}
		}
		.navigationBarTitleDisplayMode(.inline)
		.modifier(ScrollDismissIfAvailable())
	}
}

#Preview {
	NavigationView {
		IssueLoader(fullPath: "felix-schindler/gitlab-ios", iid: "1")
	}
}
