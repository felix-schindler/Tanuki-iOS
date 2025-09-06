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

	@State
	private var epics: Result<[GroupEpicsQuery.Data.Group.Epics.Node?], Error>? = nil

	@State
	private var isLoading = false

	private func loadIssues() {
		isLoading = true

		defer {
			isLoading = false
		}

		do {
			let responses = try Network.shared.apollo.fetch(
				query: GroupEpicsQuery(fullPath: self.fullPath), cachePolicy: .cacheAndNetwork)

			Task {
				for try await response in responses {
					if let epics = response.data?.group?.epics?.nodes {
						self.epics = .success(epics)
						Notify.status(.success)
					} else if let errors = response.errors {
						for error in errors {
							Notify.status(.error, error.localizedDescription)
						}
					}
				}
			}
		} catch let error {
			self.epics = .failure(error)
			Notify.status(.error)
		}
	}

	private func reloadIssues() async {
		do {
			let response = try await Network.shared.apollo.fetch(
				query: GroupEpicsQuery(fullPath: self.fullPath), cachePolicy: .networkOnly)

			if let epics = response.data?.group?.epics?.nodes {
				self.epics = .success(epics)
			}

			Notify.status(.success)
		} catch let error {
			self.epics = .failure(error)
			Notify.status(.error)
		}
	}

	public var body: some View {
		List {
			if isLoading {
				ProgressView("Loading epics")
			} else if let epics {
				switch epics {
				case .success(let epics):
					if epics.isEmpty {
						ContentUnavailableView(
							"There are no epics", systemImage: "calendar.badge.checkmark")
					} else {
						ForEach(epics, id: \.?.reference) { maybeEpic in
							if let epic = maybeEpic {
								// TODO: This is basically the `SmallIssueView` just catching a few NIL cases in properties that Issues always have. Maybe I should just generalize this to `SmallIssueView`?
								NavigationLink(
									destination: EpicLoader(
										fullPath: self.fullPath, iid: epic.iid
									),
									label: {
										VStack(alignment: .leading) {
											HStack(spacing: 5) {
												IssueStateIcon(epic.state)
												Text(epic.reference)
													.foregroundStyle(.secondary)
											}.font(.footnote)

											if let title = epic.title?.emojized() {
												Text(title)
											}

											HStack {
												ScrollView(.horizontal) {
													HStack {
														AuthorView(epic._author)
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
														Text(String(epic.upvotes))
													}
													HStack(spacing: 2) {
														Image(systemName: "hand.thumbsdown")
														Text(String(epic.downvotes))
													}
													HStack(spacing: 2) {
														Image(systemName: "note.text")
														Text(String(epic.userNotesCount))
													}
												}
											}.font(.footnote)
										}.swipeActions {
											ShareButton(URL(string: epic.webUrl)!)
										}
									}
								)
							}
						}
					}
				case .failure(let error):
					FailedView(error.localizedDescription)
				}
			}
		}.onAppear {
			loadIssues()
		}.refreshable {
			await reloadIssues()
		}.navigationTitle("Epics")
	}
}

#Preview {
	NavigationStack {
		GroupEpicsLoader(fullPath: "gitlab-org")
	}
}
