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
	private var pipelines: Result<[ProjectPipelinesQuery.Data.Project.Pipelines.Node?], Error>? =
		nil

	@State
	private var isLoading = false

	init(fullPath: String) {
		self.fullPath = fullPath
	}

	private func loadPipelines() {
		do {
			let responses = try Network.shared.apollo.fetch(
				query: ProjectPipelinesQuery(fullPath: self.fullPath), cachePolicy: .cacheAndNetwork
			)

			Task {
				for try await response in responses {
					if let pipelines = response.data?.project?.pipelines?.nodes {
						self.pipelines = .success(pipelines)
						Notify.status(.success)
					} else if let errors = response.errors {
						for error in errors {
							Notify.status(.error, error.localizedDescription)
						}
					}
				}
			}
		} catch let error {
			self.pipelines = .failure(error)
			Notify.status(.error)
		}
	}

	private func reloadPipelines() async {
		do {
			let response = try await Network.shared.apollo.fetch(
				query: ProjectPipelinesQuery(fullPath: self.fullPath), cachePolicy: .networkOnly)

			if let pipelines = response.data?.project?.pipelines?.nodes {
				self.pipelines = .success(pipelines)
			}

			Notify.status(.success)
		} catch let error {
			self.pipelines = .failure(error)
			Notify.status(.error)
		}
	}

	public var body: some View {
		List {
			if isLoading {
				ProgressView("Loading pipelines")
			} else if let pipelines {
				switch pipelines {
				case .success(let pipelines):
					if pipelines.isEmpty {
						ContentUnavailableView("There are no pipelines", systemImage: "flag")
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

										Text(
											Date.fromToString(pipeline.createdAt, timeStyle: .short)
										)
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
				case .failure(let error):
					FailedView(error.localizedDescription)
				}
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
