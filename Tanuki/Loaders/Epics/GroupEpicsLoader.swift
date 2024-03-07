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
	private var epics: [GroupEpicsQuery.Data.Group.Epics.Node?]? = nil

	@State
	private var loadFailed = false

	private func loadIssues() {
		Network.shared.apollo.fetch(
			query: GroupEpicsQuery(fullPath: self.fullPath)
		) { result in
			switch result {
			case .success(let graphQLResult):
				print("Success! Setting epics...")
				epics = graphQLResult.data?.group?.epics?.nodes
			case .failure(let error):
				print("Failure! Error: \(error)")
				loadFailed = true
			}
		}
	}

	var body: some View {
		List {
			if let epics = self.epics {
				if epics.isEmpty {
					Text("There are no issues")
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
			} else {
				VStack {
					if loadFailed {
						Text(loadFailedMsg)
					} else {
						ProgressView("Loading epics")
					}
				}.frame(maxWidth: .infinity, minHeight: 100)
			}
		}.onAppear {
			loadIssues()
		}.refreshable {
			loadIssues()
		}.navigationTitle("Epics")
	}
}

#Preview {
	NavigationStack {
		GroupEpicsLoader(fullPath: "gitlab-org")
	}
}
