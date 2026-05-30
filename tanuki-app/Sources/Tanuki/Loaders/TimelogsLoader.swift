//
//  TimelogsLoader.swift
//  Tanuki
//
//  Created by Felix Schindler on 07.03.24.
//

import GitLabAPI
import SwiftUI

enum TimelogsQueryType {
	case group,
		user
}

struct TimelogsLoader: View {
	private let fullPath: String
	private let queryType: TimelogsQueryType

	@State var timelogs: Result<[Timelog], Error>? = nil

	init(fullPath: String, queryType: TimelogsQueryType) {
		self.fullPath = fullPath
		self.queryType = queryType
	}

	private func loadTimelogs() {
		Task {
			do {
				switch self.queryType {
				case .group:
					let timelogs = try await Network.shared.service.fetchGroupTimelogs(fullPath: self.fullPath)
					self.timelogs = .success(timelogs)
				case .user:
					let timelogs = try await Network.shared.service.fetchUserTimelogs(username: self.fullPath)
					self.timelogs = .success(timelogs)
				}
			} catch let error {
				self.timelogs = .failure(error)
				Notify.status(.error)
			}
		}
	}

	private func reloadTimelogs() async {
		do {
			switch self.queryType {
			case .group:
				let timelogs = try await Network.shared.service.fetchGroupTimelogs(fullPath: self.fullPath)
				self.timelogs = .success(timelogs)

			case .user:
				let timelogs = try await Network.shared.service.fetchUserTimelogs(username: self.fullPath)
				self.timelogs = .success(timelogs)
			}

			Notify.status(.success)
		} catch let error {
			self.timelogs = .failure(error)
			Notify.status(.error)
		}
	}

	public var body: some View {
		List {
			if let timelogs {
				switch timelogs {
				case .success(let timelogs):
					if timelogs.isEmpty {
						NoContentView("There are no timelogs", systemImage: "hourglass")
					} else {
						ForEach(timelogs, id: \.id) { log in
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
														"!\(mergeIid)",
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
										.markdownTheme(.gitLab)
								}
							}
						}
					}
				case .failure(let error):
					FailedView(error)
				}
			} else {
				LoadingView("Loading Timelogs", systemImage: "hourglass")
			}
		}.onAppear {
			loadTimelogs()
		}.refreshable {
			await reloadTimelogs()
		}.navigationTitle("Timelogs")
	}
}

#Preview {
	NavigationView {
		TimelogsLoader(fullPath: "felix-schindler", queryType: .user)
	}
}
