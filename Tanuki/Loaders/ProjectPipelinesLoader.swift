//
//  ProjectPipelinesLoader.swift
//  Tanuki
//
//  Created by Felix Schindler on 07.03.24.
//

import GitLabAPI
import SwiftUI

struct ProjectPipelinesLoader: View {
	private var fullPath: String

	@State
	private var pipelines: [ProjectPipelinesQuery.Data.Project.Pipelines.Node?]? = nil

	@State
	private var loadFailed = false

	init(fullPath: String) {
		self.fullPath = fullPath
	}

	private func loadPipelines() {
		Network.shared.apollo.fetch(query: ProjectPipelinesQuery(fullPath: self.fullPath)) {
			result in
			switch result {
			case .success(let graphQLResult):
				print("Success! Setting pipelines...")
				pipelines = graphQLResult.data?.project?.pipelines?.nodes
			case .failure(let error):
				print("Failure! Error: \(error)")
				loadFailed = true
			}
		}
	}

	public var body: some View {
		List {
			if let pipelines = self.pipelines {
				if pipelines.isEmpty {
					Text("There are no pipelines")
				} else {
					ForEach(pipelines, id: \.?.id) { maybePipeline in
						if let pipeline = maybePipeline {
							HStack {
								VStack(alignment: .leading) {
									ScrollView(.horizontal) {
										HStack {
											if let author = pipeline._author {
												AuthorView(author)
											}

											PillView(
												String(pipeline.iid),
												icon: "number"
											)

											if let commitId = pipeline.commit?.shortId {
												PillView(
													commitId,
													icon:
														"text.line.first.and.arrowtriangle.forward"
												)
												.textSelection(.enabled)
												.monospaced()
											}
										}.font(.footnote)
									}

									Text(Date.fromToString(pipeline.createdAt, timeStyle: .short))
										.font(.footnote)

									if let ref = pipeline.ref {
										Text("Branch: \(ref)")
									}

									if let source = pipeline.source {
										Text("Source: \(source)")
									}
								}
								Spacer()
								PipelineStatus(pipeline.status)
							}.swipeActions {
								if pipeline.cancelable {
									Button("Cancel", systemImage: "slash.circle") {
										// TODO: Implement
									}
								}
							}
						}
					}
				}
			} else {
				VStack {
					if loadFailed {
						Text(failedToLoad)
					} else {
						ProgressView("Loading pipelines")
					}
				}.frame(maxWidth: .infinity, minHeight: 100)
			}
		}.onAppear {
			loadPipelines()
		}.refreshable {
			loadPipelines()
		}.navigationTitle("Pipelines")
	}
}

#Preview {
	NavigationStack {
		ProjectPipelinesLoader(fullPath: "felix-schindler/gitlab-ios")
	}
}
