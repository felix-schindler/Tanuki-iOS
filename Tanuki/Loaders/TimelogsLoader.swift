//
//  TimelogsLoader.swift
//  Tanuki
//
//  Created by Felix Schindler on 07.03.24.
//

import GitLabAPI
import MarkdownUI
import SwiftUI

enum TimelogsQueryType {
	case group,
		user
}

struct TimelogsLoader: View {
	private let fullPath: String
	private let queryType: TimelogsQueryType

	@State
	private var timelogs: [Timelog?]? = nil

	@State
	private var loadFailed = false

	init(fullPath: String, queryType: TimelogsQueryType) {
		self.fullPath = fullPath
		self.queryType = queryType
	}

	private func loadTimelogs() {
		switch self.queryType {
		case .group:
			Network.shared.apollo.fetch(query: GroupTimelogsQuery(fullPath: self.fullPath)) {
				result in
				switch result {
				case .success(let graphQLResult):
					print("Success! Setting timelogs...")
					timelogs = graphQLResult.data?.group?.timelogs.nodes
				case .failure(let error):
					print("Failure! Error: \(error)")
					loadFailed = true
				}
			}
		case .user:
			Network.shared.apollo.fetch(query: UserTimelogsQuery(username: self.fullPath)) {
				result in
				switch result {
				case .success(let graphQLResult):
					print("Success! Setting timelogs...")
					timelogs = graphQLResult.data?.user?.timelogs?.nodes
				case .failure(let error):
					print("Failure! Error: \(error)")
					loadFailed = true
				}
			}
		}
	}

	var body: some View {
		List {
			if let timelogs = self.timelogs {
				if timelogs.isEmpty {
					Text("There are no timelogs")
				} else {
					ForEach(timelogs, id: \.?.id) { maybeLog in
						if let log = maybeLog {
							VStack(alignment: .leading) {
								HStack {
									ScrollView(.horizontal) {
										NavigationLink(
											destination: ProjectLoader(
												fullPath: log._project.fullPath
											),
											label: {
												Text(log._project.nameWithNamespace)
											}
										).foregroundStyle(.secondary)
									}

									if let spentAt = log.spentAt {
										Spacer()
										Text(Date.fromToString(spentAt))
									}
								}.font(.footnote)

								ScrollView(.horizontal) {
									HStack {
										AuthorView(log._user)

										if let issueIid = log._issue?.iid {
											NavigationLink(
												destination: IssueLoader(
													fullPath: log._project.fullPath,
													iid: issueIid
												),
												label: {
													PillView(
														"#\(issueIid)",
														icon: "smallcircle.circle",
														bgColor: .green,
														fgColor: .white,
														cornerRadius: 5
													)
												})
										}

										if let mergeIid = log._mergeRequest?.iid {
											NavigationLink(
												destination: MergeRequestLoader(
													fullPath: log._project.fullPath,
													iid: mergeIid
												),
												label: {
													PillView(
														"#\(mergeIid)",
														icon: "arrow.triangle.pull",
														bgColor: .blue,
														fgColor: .white,
														cornerRadius: 5
													)
												})
										}
									}.font(.footnote)
								}

								Text("\(log.timeSpent / 60) minutes")

								if let summary = log.summary {
									Markdown(summary.emojized())
										.markdownTheme(.gitHub)
								}
							}
						}
					}
				}
			} else {
				VStack {
					if loadFailed {
						Text(loadFailedMsg)
					} else {
						ProgressView("Loading timelogs")
					}
				}.frame(maxWidth: .infinity, minHeight: 100)
			}
		}.onAppear {
			loadTimelogs()
		}.refreshable {
			loadTimelogs()
		}.navigationTitle("Timelogs")
	}
}

#Preview {
	NavigationStack {
		TimelogsLoader(fullPath: "felix-schindler", queryType: .user)
	}
}
