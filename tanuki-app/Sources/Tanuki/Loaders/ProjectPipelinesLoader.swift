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

	@State var pipelines: Result<ProjectPipelines_Project, Error>? = nil

	init(fullPath: String) {
		self.fullPath = fullPath
	}

	private func loadPipelines() {
		Task {
			do {
				let payload = try await Network.shared.service.fetchProjectPipelines(fullPath: self.fullPath)
				self.pipelines = .success(payload)
			} catch let error {
				self.pipelines = .failure(error)
				Notify.status(.error)
			}
		}
	}

	private func reloadPipelines() async {
		do {
			let payload = try await Network.shared.service.fetchProjectPipelines(fullPath: self.fullPath, strategy: .networkOnly)
			self.pipelines = .success(payload)
			Notify.status(.success)
		} catch let error {
			self.pipelines = .failure(error)
			Notify.status(.error)
		}
	}

	public var body: some View {
		List {
			if let pipelines {
				switch pipelines {
				case .success(let payload):
					let nodes = payload.pipelines?.nodes ?? []
					if nodes.isEmpty {
						NoContentView("There are no pipelines", systemImage: "flag")
					} else {
						ForEach(nodes, id: \.id) { pipeline in
							HStack {
								VStack(alignment: .leading) {
									ScrollView(.horizontal) {
										HStack {
											if let user = pipeline.user {
												let author = MyAuthor(avatarUrl: user.avatarUrl, name: user.name ?? user.username ?? "", username: user.username ?? "")
												AuthorView(author)
											}

											if let iid = pipeline.iid {
												PillView(
													iid,
													icon: "number"
												)
											}

											if let commitId = pipeline.commit?.shortId {
												PillView(
													commitId,
													icon:
														"text.line.first.and.arrowtriangle.forward"
												)
												#if !SKIP_BRIDGE
													.textSelection(.enabled)
												#endif
												.font(.system(.footnote, design: .monospaced))
											}
										}.font(.footnote)
									}

									if let createdAt = pipeline.createdAt {
										Text(
											Date.fromToString(createdAt, timeStyle: .short)
										)
										.font(.footnote)
									}

									if let ref = pipeline.ref {
										Text("Branch: \(ref)")
									}

									if let source = pipeline.source {
										Text("Source: \(source)")
									}
								}
								Spacer()
								PipelineStatus(pipeline.status)
							}
						}
					}
				case .failure(let error):
					FailedView(error)
				}
			} else {
				LoadingView("Loading Pipelines", systemImage: "flag")
			}
		}.onAppear {
			loadPipelines()
		}.refreshable {
			await reloadPipelines()
		}.navigationTitle("Pipelines")
	}
}
