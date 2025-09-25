//
//  EpicLoader.swift
//  Tanuki
//
//  Created by Felix Schindler on 07.03.24.
//

import GitLabAPI
import MarkdownUI
import SwiftUI

struct EpicLoader: View {
	private let fullPath: String
	private let iid: String

	@State
	private var group: Result<EpicQuery.Data.Group, Error>? = nil

	// MARK: New note
	@State
	private var newNoteContent = ""

	@State
	private var newNoteError = false

	init(fullPath: String, iid: String) {
		self.fullPath = fullPath
		self.iid = iid
	}

	private func loadEpic() {
		do {
			let responses = try Network.shared.apollo.fetch(
				query: EpicQuery(fullPath: self.fullPath, iid: self.iid),
				cachePolicy: .cacheAndNetwork)

			Task {
				for try await response in responses {
					if let group = response.data?.group {
						self.group = .success(group)
					} else if let errors = response.errors {
						for error in errors {
							Notify.status(.error, error.localizedDescription)
						}
					}
				}
			}
		} catch let error {
			self.group = .failure(error)
			Notify.status(.error)
		}
	}

	private func reloadEpic() async {
		do {
			let response = try await Network.shared.apollo.fetch(
				query: EpicQuery(fullPath: self.fullPath, iid: self.iid), cachePolicy: .networkOnly)

			if let group = response.data?.group {
				self.group = .success(group)
			}

			Notify.status(.success)
		} catch let error {
			self.group = .failure(error)
			Notify.status(.error)
		}
	}

	public var body: some View {
		List {
			if let group {
				switch group {
				case .success(let group):
					if let epic = group.epic {
						VStack(alignment: .leading) {
							HStack(spacing: 5) {
								if let url = URL.fromAvatar(group.avatarUrl) {
									AvatarImage(url, size: .tiny)
								}
								ScrollView(.horizontal) {
									Text(epic.reference)
										.foregroundStyle(.secondary)
								}
								if let createdAt = epic.createdAt {
									Spacer()
									Text(Date.fromToString(createdAt))
								}
							}.padding(.bottom, 1)

							if let title = epic.title {
								Text(title.emojized())
									.font(.title3)
									.fontWeight(.medium)
									.padding(.bottom, 1)
							}

							ScrollView(.horizontal) {
								HStack(spacing: 5) {
									PillView(
										epic.state.rawValue.firstCapitalized,
										icon: IssueStateHelper.getIconByState(epic.state),
										bgColor: IssueStateHelper.getColorByState(epic.state),
										fgColor: .white,
										cornerRadius: 5
									)

									if let color = epic.color {
										PillView(
											"Color",
											bgColor: Color(hex: color),
											fgColor: Color(hex: epic.textColor),
											cornerRadius: 5
										)
									}

									AuthorView(epic._author)

									if let startDate = epic.startDate {
										PillView(startDate, icon: "clock")
									}

									if let dueDate = epic.dueDate {
										PillView(dueDate, icon: "alarm")
									}
								}
							}
							
							if let blockedBy = epic.blockedByEpics?.nodes,
							   blockedBy.isNotEmpty
							{
								ScrollView(.horizontal) {
									HStack(spacing: 5) {
										ForEach(blockedBy, id: \.?.iid) { block in
											if let block {
												NavigationLink(
													destination: EpicLoader(
														fullPath: self.fullPath,
														iid: block.iid
													),
													label: {
														PillView(
															"&\(block.iid)",
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
							}
							
							if let description = epic.description?.emojized(),
								description.isNotEmpty
							{
								Markdown(description)
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
											Text(String(epic.upvotes))
										}
									})
								Button(
									action: {
										// TODO: Toggle like
									},
									label: {
										HStack(spacing: 5) {
											Image(systemName: "hand.thumbsdown")
											Text(String(epic.downvotes))
										}
									})
							}
							.controlSize(.small)
							.buttonStyle(.bordered)
							.font(.footnote)
							.foregroundStyle(.primary)
						}.font(.footnote)

						Section("Details") {
							NavigationLink(
								destination: EpicIssuesLoader(
									fullPath: self.fullPath,
									iid: self.iid
								),
								label: {
									Label(
										title: {
											Text("Issues")
										},
										icon: {
											Image(systemName: "smallcircle.circle")
												.foregroundStyle(.green)
										})
								})

							if let labels = epic.labels?.nodes, labels.isNotEmpty {
								Label(
									title: {
										ScrollView(.horizontal) {
											HStack {
												ForEach(labels, id: \.self) { label in
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

							if let ancestors = epic.ancestors?.nodes, ancestors.isNotEmpty {
								DisclosureGroup(
									content: {
										ForEach(ancestors, id: \.?.iid) { ancestor in
											if let ancestor {
												NavigationLink("&\(ancestor.iid)", destination: {
													EpicLoader(
														fullPath: self.fullPath,
														iid: ancestor.iid
													)
												})
											}
										}
									},
									label: {
										Label(
											"Ancestors",
											systemImage: "figure.and.child.holdinghands"
										)
									}
								)
							}

							if let children = epic.children?.nodes, children.isNotEmpty {
								DisclosureGroup(
									content: {
										ForEach(children, id: \.?.iid) { child in
											if let child {
												NavigationLink("&\(child.iid)", destination: {
													EpicLoader(
														fullPath: self.fullPath,
														iid: child.iid
													)
												})
											}
										}
									},
									label: {
										Label("Children", systemImage: "figure.child")
									}
								)
							}
						}

						if epic.userPermissions.updateEpic {
							Section("Actions") {
								if epic.state == .opened {
									Button(
										action: {
											// TODO: Implement
										},
										label: {
											Label(
												"Close issue",
												systemImage: "smallcircle.circle")
										}
									).tint(.blue)
								} else if epic.state == .closed {
									Button(
										action: {
											// TODO: Implement
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

						let noteCount = epic.notes.nodes?.count ?? 0
						if epic.userPermissions.createNote || noteCount > 0 {
							Section("Notes (\(epic.userNotesCount))") {
								if epic.userPermissions.createNote {
									HStack {
										TextField(
											"New note",
											text: $newNoteContent
										)
										RoundIconButton("Comment", icon: "arrow.up") {
											// TODO: Save note
											if newNoteContent.isEmpty {
												Notify.status(.error, "Please provide content")
											} else {
												Notify.status(.success)
												newNoteContent = ""
											}
										}
									}
								}

								if noteCount > 0 {
									ForEach(epic.notes.nodes!, id: \.self?.id) { maybeNote in
										if let note = maybeNote {
											NoteView(note)
										}
									}
								}
							}
						}
					} else {
						NoContentView("Epic not found", systemImage: "calendar")
					}
				case .failure(let error):
					FailedView(error)
				}
			} else {
				LoadingView("Loading Epics", systemImage: "calendar")
			}
		}.onAppear {
			loadEpic()
		}.refreshable {
			await reloadEpic()
		}.toolbar {
			if let group, case .success(let group) = group,
			   let webUrl = group.epic?.webUrl,
			   let url = URL(string: webUrl)
			{
				ShareButton(url)
			}
		}
	}
}

#Preview {
	NavigationView {
		EpicLoader(fullPath: "gitlab-org", iid: "12691")
	}
}
