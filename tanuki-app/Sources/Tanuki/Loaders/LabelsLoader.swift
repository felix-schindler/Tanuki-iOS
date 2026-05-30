//
//  GroupLabelsLoader.swift
//  Tanuki
//
//  Created by Felix Schindler on 07.03.24.
//

import GitLabAPI
import SwiftUI

enum LabelQueryType {
	case group,
		project
}

struct LabelsLoader: View {
	private let id: Int
	private let fullPath: String
	private let queryType: LabelQueryType

	@State var labels: Result<[MyLabel], Error>? = nil

	init(fullPath: String, id: Int, queryType: LabelQueryType) {
		self.fullPath = fullPath
		self.id = id
		self.queryType = queryType
	}

	private func loadLabels() {
		Task {
			do {
				switch self.queryType {
				case .group:
					let labels = try await Network.shared.service.fetchGroupLabels(fullPath: self.fullPath)
					self.labels = .success(labels)
				case .project:
					let labels = try await Network.shared.service.fetchProjectLabels(fullPath: self.fullPath)
					self.labels = .success(labels)
				}
			} catch let error {
				self.labels = .failure(error)
				Notify.status(.error)
			}
		}
	}

	private func reloadLabels() async {
		do {
			switch self.queryType {
			case .group:
				let labels = try await Network.shared.service.fetchGroupLabels(fullPath: self.fullPath)
				self.labels = .success(labels)

				Notify.status(.success)
			case .project:
				let labels = try await Network.shared.service.fetchProjectLabels(fullPath: self.fullPath)
				self.labels = .success(labels)

				Notify.status(.success)
			}
		} catch let error {
			self.labels = .failure(error)
			Notify.status(.error)
		}
	}

	public var body: some View {
		List {
			if let labels {
				switch labels {
				case .success(let labels):
					if labels.isEmpty {
						NoContentView("There are no labels", systemImage: "tag")
					} else {
						ForEach(labels, id: \.id) { label in
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
				case .failure(let error):
					FailedView(error)
				}
			} else {
				LoadingView("Loading Labels", systemImage: "tag")
			}
		}.onAppear {
			loadLabels()
		}.refreshable {
			await reloadLabels()
		}.toolbar {
			if let labels, case .success = labels {
				NavigationLink(
					destination: {
						if self.queryType == .project {
							NewLabelView(id: self.id, groupId: 0)
						} else {
							NewLabelView(id: 0, groupId: self.id)
						}
					},
					label: {
						Label("New label", systemImage: "plus")
					}
				).tint(.accentColor)
			}
		}.navigationTitle("Labels")
	}
}

#Preview {
	NavigationView {
		LabelsLoader(fullPath: "gitlab-org", id: 278_964, queryType: .group)
	}
}
