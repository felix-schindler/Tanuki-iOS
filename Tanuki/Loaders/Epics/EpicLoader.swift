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
	private var group: EpicQuery.Data.Group? = nil

	@State
	private var loadFailed = false

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
		Network.shared.apollo.fetch(
			query: EpicQuery(
				fullPath: self.fullPath,
				iid: self.iid)
		) { result in
			switch result {
			case .success(let graphQLResult):
				print("Success! Setting epic...")
				group = graphQLResult.data?.group
			case .failure(let error):
				print("Failure! Error: \(error)")
				loadFailed = true
			}
		}
	}

	public var body: some View {
		List {
			if let group = self.group {
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

						if (epic.blockedByEpics?.nodes?.count ?? 0)
							> 0
						{
							ScrollView(.horizontal) {
								HStack(spacing: 5) {
									ForEach(
										epic.blockedByEpics!.nodes!,
										id: \.self?.iid
									) { maybeBlock in
										if let block = maybeBlock {
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
												})
										}
									}
								}
							}
						}

						if epic.description?.isNotEmpty ?? false {
							Markdown(epic.description!.emojized())
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

						if (epic.labels?.nodes?.count ?? 0) > 0 {
							Label(
								title: {
									ScrollView(.horizontal) {
										HStack {
											ForEach(
												epic.labels!.nodes!, id: \.self
											) { maybeLabel in
												if let label = maybeLabel {
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
								})
						}

						if !(epic.ancestors?.nodes?.isEmpty ?? false) {
							DisclosureGroup(
								content: {
									ForEach(epic.ancestors!.nodes!, id: \.?.iid) {
										maybeAncestor in
										if let ancestor = maybeAncestor {
											NavigationLink(
												destination: EpicLoader(
													fullPath: self.fullPath,
													iid: ancestor.iid
												),
												label: {
													Text("&\(ancestor.iid)")
												})
										}
									}
								},
								label: {
									Label("Ancestors", systemImage: "figure.and.child.holdinghands")
								})
						}

						if !(epic.children?.nodes?.isEmpty ?? false) {
							DisclosureGroup(
								content: {
									ForEach(epic.children!.nodes!, id: \.?.iid) { maybeChild in
										if let child = maybeChild {
											NavigationLink(
												destination: EpicLoader(
													fullPath: self.fullPath,
													iid: child.iid
												),
												label: {
													Text("&\(child.iid)")
												}
											)
										}
									}
								},
								label: {
									Label("Children", systemImage: "figure.child")
								})
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
								ForEach(epic.notes.nodes!, id: \.self?.id) { maybeNote in
									if let note = maybeNote {
										NoteView(note)
									}
								}
							}
						}
					}
				} else {
					Text("Epic does not exist")
				}
			} else {
				VStack {
					if loadFailed {
						Text(failedToLoad)
					} else {
						ProgressView("Loading epic")
					}
				}.frame(maxWidth: .infinity, minHeight: 100)
			}
		}.onAppear {
			loadEpic()
		}.refreshable {
			loadEpic()
		}.toolbar {
			if let webUrl = URL(string: group?.epic?.webUrl ?? "") {
				ShareButton(webUrl)
			}
		}
	}
}

#Preview {
	NavigationStack {
		EpicLoader(fullPath: "gitlab-org", iid: "12691")
	}
}
