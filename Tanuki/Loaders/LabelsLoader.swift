//
//  GroupLabelsLoader.swift
//  Tanuki
//
//  Created by Felix Schindler on 07.03.24.
//

import GitLabAPI
import MarkdownUI
import SwiftUI

enum LabelQueryType {
	case group,
		project
}

struct LabelsLoader: View {
	private let fullPath: String
	private let queryType: LabelQueryType

	@State
	private var labels: Result<[MyLabel?], Error>? = nil

	@State
	private var isLoading = false

	init(fullPath: String, queryType: LabelQueryType) {
		self.fullPath = fullPath
		self.queryType = queryType
	}

	private func loadLabels() {
		isLoading = true

		defer {
			isLoading = false
		}

		do {
			switch self.queryType {
			case .group:
				let responses = try Network.shared.apollo.fetch(
					query: GroupLabelsQuery(fullPath: self.fullPath), cachePolicy: .cacheAndNetwork)

				Task {
					for try await response in responses {
						if let labels = response.data?.group?.labels?.nodes {
							self.labels = .success(labels)
						} else if let errors = response.errors {
							for error in errors {
								Notify.status(.error, error.localizedDescription)
							}
						}
					}
				}
			case .project:
				let responses = try Network.shared.apollo.fetch(
					query: ProjectLabelsQuery(fullPath: self.fullPath),
					cachePolicy: .cacheAndNetwork)

				Task {
					for try await response in responses {
						if let labels = response.data?.project?.labels?.nodes {
							self.labels = .success(labels)
						} else if let errors = response.errors {
							for error in errors {
								Notify.status(.error, error.localizedDescription)
							}
						}
					}
				}
			}
		} catch let error {
			self.labels = .failure(error)
			Notify.status(.error)
		}
	}

	private func reloadLabels() async {
		do {
			switch self.queryType {
			case .group:
				let response = try await Network.shared.apollo.fetch(
					query: GroupLabelsQuery(fullPath: self.fullPath), cachePolicy: .networkOnly)

				if let labels = response.data?.group?.labels?.nodes {
					self.labels = .success(labels)
				}

				Notify.status(.success)
			case .project:
				let response = try await Network.shared.apollo.fetch(
					query: ProjectLabelsQuery(fullPath: self.fullPath), cachePolicy: .networkOnly)

				if let labels = response.data?.project?.labels?.nodes {
					self.labels = .success(labels)
				}

				Notify.status(.success)
			}
		} catch let error {
			self.labels = .failure(error)
			Notify.status(.error)
		}
	}

	public var body: some View {
		List {
			if isLoading {
				ProgressView("Loading labels")
			} else if let labels {
				switch labels {
				case .success(let labels):
					if labels.isEmpty {
						ContentUnavailableView("There are no labels", systemImage: "person.2")
					} else {
						ForEach(labels, id: \.?.id) { maybeLabel in
							if let label = maybeLabel {
								VStack(alignment: .leading) {
									ScrollView(.horizontal) {
										PillView(
											label.title.emojized(),
											bgColor: Color(hex: label.color),
											fgColor: Color(hex: label.textColor)
										)
									}

									if let description = label.description,
										description.isNotEmpty
									{
										Markdown(description)
											.markdownTheme(.gitLab)
									}
								}
							}
						}
					}
				case .failure(let error):
					FailedView(error)
				}
			}
		}.onAppear {
			loadLabels()
		}.refreshable {
			await reloadLabels()
		}.toolbar {
			if let labels, case .success = labels {
				NavigationLink(
					destination: NewLabelView(id: 1, groupId: 1),
					label: {
						Label("New label", systemImage: "plus")
					}
				).tint(.accentColor)
			}
		}.navigationTitle("Labels")
	}
}

#Preview {
	NavigationStack {
		LabelsLoader(fullPath: "gitlab-org", queryType: .group)
	}
}
