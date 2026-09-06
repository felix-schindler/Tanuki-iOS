//
//  EpicLoader.swift
//  Tanuki
//
//  Created by Felix Schindler on 07.03.24.
//

import GitLabAPI
//import MarkdownUI
import SwiftUI

extension Epic_Group_Epic_Author {
	fileprivate var toMyAuthor: MyAuthor {
		MyAuthor(avatarUrl: avatarUrl, name: name ?? username ?? "", username: username ?? "")
	}
}

extension Epic_Group_Epic_Notes_Nodes_Author {
	fileprivate var toMyAuthor: MyAuthor {
		MyAuthor(avatarUrl: avatarUrl, name: name ?? username ?? "", username: username ?? "")
	}
}

private struct NoteWrapper: Note {
	let note: Epic_Group_Epic_Notes_Nodes

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

struct EpicLoader: View {
	private let fullPath: String
	private let iid: String

	@State var group: Result<Epic_Group, Error>? = nil

	init(fullPath: String, iid: String) {
		self.fullPath = fullPath
		self.iid = iid
	}

	private static func stateIcon(_ state: String?) -> String {
		switch state?.lowercased() {
		case "opened": "smallcircle.circle"
		case "closed": "minus.circle"
		default: "smallcircle.circle"
		}
	}

	private static func stateColor(_ state: String?) -> Color {
		switch state?.lowercased() {
		case "opened": .green
		case "closed": .blue
		default: .primary
		}
	}

	private func loadEpic() {
		Task {
			do {
				let group = try await Network.shared.service.fetchEpic(fullPath: fullPath, iid: iid)
				self.group = .success(group)
			} catch let error {
				self.group = .failure(error)
				Notify.status(.error)
			}
		}
	}

	private func reloadEpic() async {
		do {
			let group = try await Network.shared.service.fetchEpic(fullPath: fullPath, iid: iid, strategy: .networkOnly)
			self.group = .success(group)
			Notify.status(.success)
		} catch let error {
			self.group = .failure(error)
			Notify.status(.error)
		}
	}

	private func changeState(_ groupId: Int, _ state: String) async {
		var body = ["state_event": state]

		do {
			_ = try await API.req(
				type: UserSmall.self,
				method: .put,
				endpoint: "groups/\(groupId)/epics/\(self.iid)",
				body: body
			)
			await reloadEpic()
		} catch let error {
			Notify.status(.error, "Failed to change state", error.localizedDescription)
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
									Text(epic.reference ?? "")
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
										epic.state?.capitalized ?? "",
										icon: Self.stateIcon(epic.state),
										bgColor: Self.stateColor(epic.state),
										fgColor: .white,
										cornerRadius: 5
									)

									if let color = epic.color, let textColor = epic.textColor {
										PillView(
											"Color",
											bgColor: Color(hex: color),
											fgColor: Color(hex: textColor),
											cornerRadius: 5
										)
									}

									if let author = epic.author {
										AuthorView(author.toMyAuthor)
									}

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
										ForEach(blockedBy, id: \.iid) { block in
											NavigationLink(
												destination: EpicLoader(
													fullPath: self.fullPath,
													iid: block.iid ?? ""
												),
												label: {
													PillView(
														"&\(block.iid ?? "")",
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

							if let description = epic.description?.emojized(),
								description.isNotEmpty
							{
								Markdown(description)
									.markdownTheme(.gitLab)
							}

							HStack {
								PillView(String(Int(epic.upvotes ?? "0") ?? 0), icon: "hand.thumbsup")
								PillView(String(Int(epic.downvotes ?? "0") ?? 0), icon: "hand.thumbsdown")
							}
							.modifier(LabelSpacingIfAvailable())
							.font(.footnote)
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
												ForEach(labels, id: \.title) { label in
													PillView(
														(label.title ?? "").emojized(),
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

							if let ancestors = epic.ancestors?.nodes, ancestors.isNotEmpty {
								DisclosureGroup(
									content: {
										ForEach(ancestors, id: \.iid) { ancestor in
											NavigationLink(
												"&\(ancestor.iid ?? "")",
												destination: {
													EpicLoader(
														fullPath: self.fullPath,
														iid: ancestor.iid ?? ""
													)
												})
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
										ForEach(children, id: \.iid) { child in
											NavigationLink(
												"&\(child.iid ?? "")",
												destination: {
													EpicLoader(
														fullPath: self.fullPath,
														iid: child.iid ?? ""
													)
												})
										}
									},
									label: {
										Label("Children", systemImage: "figure.child")
									}
								)
							}
						}

						if epic.userPermissions?.updateEpic == "true",
							let groupId = group.id?.toIntId()
						{
							Section("Actions") {
								if epic.state == "opened" {
									AsyncButton(
										action: {
											await changeState(groupId, "close")
										},
										label: {
											Label(
												"Close epic",
												systemImage: "smallcircle.circle"
											)
										}
									).tint(.blue)
								} else if epic.state == "closed" {
									AsyncButton(
										action: {
											await changeState(groupId, "reopen")
										},
										label: {
											Label(
												"Reopen epic",
												systemImage: "arrow.triangle.swap"
											)
										}
									).tint(.green)
								}
							}
						}

						let noteCount = epic.notes?.nodes?.count ?? 0
						if epic.userPermissions?.createNote == "true" || noteCount > 0 {
							Section("Notes (\(epic.userNotesCount ?? "0"))") {
								if let groupId = group.id?.toIntId(),
									epic.userPermissions?.createNote == "true"
								{
									NewNoteView(groupId, iid: epic.iid ?? "", type: .epic)
								}

								if let notes = epic.notes?.nodes, notes.isNotEmpty {
									ForEach(notes, id: \.id) { note in
										NoteView(NoteWrapper(note: note))
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
