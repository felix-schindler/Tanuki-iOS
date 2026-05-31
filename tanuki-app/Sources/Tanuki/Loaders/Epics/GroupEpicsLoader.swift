//
//  GroupEpicsLoader.swift
//  Tanuki
//
//  Created by Felix Schindler on 07.03.24.
//

import GitLabAPI
import SwiftUI

struct GroupEpicsLoader: View {
	private let fullPath: String

	init(fullPath: String) {
		self.fullPath = fullPath
	}

	@State var epics: Result<GroupEpics_Group, Error>? = nil

	private func loadIssues() {
		Task {
			do {
				let payload = try await Network.shared.service.fetchGroupEpics(fullPath: self.fullPath)
				self.epics = .success(payload)
			} catch let error {
				self.epics = .failure(error)
				Notify.status(.error)
			}
		}
	}

	private func reloadIssues() async {
		do {
			let payload = try await Network.shared.service.fetchGroupEpics(fullPath: self.fullPath, strategy: .networkOnly)
			self.epics = .success(payload)
			Notify.status(.success)
		} catch let error {
			self.epics = .failure(error)
			Notify.status(.error)
		}
	}

	public var body: some View {
		List {
			if let epics {
				switch epics {
				case .success(let payload):
					let nodes = payload.epics?.nodes ?? []
					if nodes.isEmpty {
						NoContentView("There are no epics", systemImage: "calendar")
					} else {
						ForEach(nodes, id: \.iid) { epic in
							NavigationLink(
								destination: EpicLoader(
									fullPath: self.fullPath, iid: epic.iid ?? ""
								),
								label: {
									VStack(alignment: .leading) {
										if let reference = epic.reference {
											HStack(spacing: 5) {
												IssueStateIcon(epic.state)
												Text(reference)
													.foregroundStyle(.secondary)
											}.font(.footnote)
										}

										if let title = epic.title?.emojized() {
											Text(title)
										}

										HStack {
											ScrollView(.horizontal) {
												HStack {
													if let author = epic.author {
														AuthorView(MyAuthor(avatarUrl: author.avatarUrl, name: author.name ?? author.username ?? "", username: author.username ?? ""))
													}
													if let createdAt = epic.createdAt {
														HStack(spacing: 2) {
															Image(systemName: "clock")
															Text(Date.fromToString(createdAt))
														}
													}
												}
											}
											Spacer()
											HStack {
												HStack(spacing: 2) {
													Image(systemName: "hand.thumbsup")
													Text(epic.upvotes ?? "0")
												}
												HStack(spacing: 2) {
													Image(systemName: "hand.thumbsdown")
													Text(epic.downvotes ?? "0")
												}
												HStack(spacing: 2) {
													Image(systemName: "note.text")
													Text(epic.userNotesCount ?? "0")
												}
											}
										}.font(.footnote)
									}
								}
							)
						}
					}
				case .failure(let error):
					FailedView(error)
				}
			} else {
				LoadingView("Loading Epics", systemImage: "calendar")
			}
		}.onAppear {
			loadIssues()
		}.refreshable {
			await reloadIssues()
		}.navigationTitle("Epics")
	}
}

#Preview {
	NavigationView {
		GroupEpicsLoader(fullPath: "gitlab-org")
	}
}
