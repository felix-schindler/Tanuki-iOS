//
//  ProjectReleasesLoader.swift
//  Tanuki
//
//  Created by Felix Schindler on 04.03.24.
//

import GitLabAPI
import MarkdownUI
import SwiftUI

struct ProjectReleasesLoader: View {
	private var fullPath: String

	@State
	private var releases: [ProjectReleasesQuery.Data.Project.Releases.Node?]? = nil

	@State
	private var loadFailed = false

	init(fullPath: String) {
		self.fullPath = fullPath
	}

	private func loadReleases() {
		Network.shared.apollo.fetch(query: ProjectReleasesQuery(fullPath: self.fullPath)) {
			result in
			switch result {
			case .success(let graphQLResult):
				print("Success! Setting releases...")
				releases = graphQLResult.data?.project?.releases?.nodes
			case .failure(let error):
				print("Failure! Error: \(error)")
				loadFailed = true
			}
		}
	}

	public var body: some View {
		List {
			if let releases = self.releases {
				ForEach(releases, id: \.?.id) { maybeRelease in
					if let release = maybeRelease {
						Section(
							content: {
								VStack(alignment: .leading) {
									ScrollView(.horizontal) {
										HStack {
											if let author = release._author {
												AuthorView(author)
											}

											if let tagName = release.tagName {
												PillView(tagName, icon: "tag")
											}

											if let milestones = release.milestones?.nodes {
												ForEach(milestones, id: \.?.id) { maybeMilestone in
													if let milestone = maybeMilestone {
														PillView(
															milestone.title,
															icon: "signpost.right.and.left"
														)
													}
												}
											}

											if let commit = release.commit?.shortId {
												PillView(
													commit,
													icon:
														"text.line.first.and.arrowtriangle.forward"
												)
												.textSelection(.enabled)
												.monospaced()
											}
										}.font(.footnote)
									}

									if let description = release.description {
										Markdown(description, baseURL: API.url)
											.markdownTheme(.gitLab)
									}
								}
								if let assets = release.assets {
									DisclosureGroup(
										"Assets (\(assets.count ?? 0))",
										content: {
											if let links = assets.links?.nodes {
												ForEach(links, id: \.?.id) { maybeLink in
													if let link = maybeLink {
														if let url = URL(string: link.url ?? "") {
															Link(
																link.name ?? "Link",
																destination: url)
														}
													}
												}
											}

											if let sources = assets.sources?.nodes {
												ForEach(sources, id: \.?.url) { maybeSource in
													if let url = URL(string: maybeSource?.url ?? "")
													{
														Link(
															"Source code (\(maybeSource?.format ?? "unknown"))",
															destination: url)
													}
												}
											}
										}
									)
								}
								if (release.assets?.count ?? 0) > 0 {
								}
							},
							header: {
								HStack {
									Text(release.name ?? release.id)
									if let releasedAt = release.releasedAt {
										Spacer()
										Text(Date.fromToString(releasedAt, timeStyle: .short))
											.font(.footnote)
									}
								}
							})
					}
				}
			} else {
				VStack {
					if loadFailed {
						Text(failedToLoad)
					} else {
						ProgressView("Loading releases")
					}
				}.frame(maxWidth: .infinity, minHeight: 100)
			}
		}.onAppear {
			loadReleases()
		}.refreshable {
			loadReleases()
		}.toolbar {
			RoundIconButton("Create new release", icon: "plus") {
				// TODO: Implement
				Notify.status(.success)
			}
		}
		.headerProminence(.increased)
		.navigationTitle("Releases")
	}
}

#Preview {
	NavigationStack {
		ProjectReleasesLoader(fullPath: "felix-schindler/gitlab-ios")
	}
}
