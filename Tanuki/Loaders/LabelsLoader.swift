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
	private var labels: [MyLabel?]? = nil

	@State
	private var loadFailed = false

	init(fullPath: String, queryType: LabelQueryType) {
		self.fullPath = fullPath
		self.queryType = queryType
	}

	private func loadLabels() {
		switch self.queryType {
		case .group:
			Network.shared.apollo.fetch(query: GroupLabelsQuery(fullPath: self.fullPath)) {
				result in
				switch result {
				case .success(let graphQLResult):
					print("Success! Setting labels...")
					labels = graphQLResult.data?.group?.labels?.nodes
				case .failure(let error):
					print("Failure! Error: \(error)")
					loadFailed = true
				}
			}
		case .project:
			Network.shared.apollo.fetch(query: ProjectLabelsQuery(fullPath: self.fullPath)) {
				result in
				switch result {
				case .success(let graphQLResult):
					print("Success! Setting labels...")
					labels = graphQLResult.data?.project?.labels?.nodes
				case .failure(let error):
					print("Failure! Error: \(error)")
					loadFailed = true
				}
			}
		}
	}

	public var body: some View {
		List {
			if let labels = self.labels {
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

							if label.description?.isNotEmpty ?? false {
								Markdown(label.description!)
									.markdownTheme(.gitLab)
							}
						}
					}
				}
			} else {
				VStack {
					if loadFailed {
						Text(failedToLoad)
					} else {
						ProgressView("Loading labels")
					}
				}.frame(maxWidth: .infinity, minHeight: 100)
			}
		}.onAppear {
			loadLabels()
		}.refreshable {
			loadLabels()
		}.navigationTitle("Labels")
	}
}

#Preview {
	NavigationStack {
		LabelsLoader(fullPath: "gitlab-org", queryType: .group)
	}
}
