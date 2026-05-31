//
//  ProjectReleasesLoader.swift
//  Tanuki
//
//  Created by Felix Schindler on 04.03.24.
//

import GitLabAPI
import SwiftUI

struct ProjectReleasesLoader: View {
	private var fullPath: String
	private var projectId: Int?

	@State var releases: Result<[Release], Error>? = nil

	init(fullPath: String, projectId: Int? = nil) {
		self.fullPath = fullPath
		self.projectId = projectId
	}

	private func loadReleases() {
		Task {
			do {
				let releases = try await Network.shared.service.fetchProjectReleasesQuery(fullPath: self.fullPath)
				self.releases = .success(releases)
			} catch let error {
				self.releases = .failure(error)
				Notify.status(.error)
			}
		}
	}

	private func reloadReleases() async {
		do {
			let releases = try await Network.shared.service.fetchProjectReleasesQuery(fullPath: self.fullPath)
			self.releases = .success(releases)
			Notify.status(.success)
		} catch let error {
			self.releases = .failure(error)
			Notify.status(.error)
		}
	}

	public var body: some View {
		List {
			if let releases {
				switch releases {
				case .success(let releases):
					if releases.isEmpty {
						NoContentView("There are no releases", systemImage: "flag")
					} else {
						ForEach(releases, id: \.id) { release in
							Section {
								ReleaseContent(release: release)
							} header: {
								HStack {
									Text(release.name ?? release.id ?? "")
									if let releasedAt = release.releasedAt {
										Spacer()
										Text(Date.fromToString(releasedAt, timeStyle: .short))
											.font(.footnote)
									}
								}
							}
						}
					}
				case .failure(let error):
					FailedView(error)
				}
			} else {
				LoadingView("Loading Releases", systemImage: "flag")
			}
		}.onAppear {
			loadReleases()
		}.refreshable {
			await reloadReleases()
		}.toolbar {
			if let projectId {
				NavigationLink(
					destination: NewReleaseView(id: projectId, fullPath: self.fullPath),
					label: {
						Label("Create new release", systemImage: "plus")
					}
				).tint(.accentColor)
			}
		}
		.headerProminence(.increased)
		.navigationTitle("Releases")
	}
}

struct ReleaseContent: View {
	let release: any Release

	var body: some View {
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
								PillView(milestone.title ?? "", icon: "diamond")
							}
						}
					}
					if let commit = release.commit?.shortId {
						PillView(commit, icon: "text.line.first.and.arrowtriangle.forward")
							.textSelection(.enabled)
							.font(.system(.footnote, design: .monospaced))
					}
				}.font(.footnote)
			}
			if let description = release.description {
				Markdown(description, baseURL: API.url)
					.markdownTheme(.gitLab)
			}
		}
		if let assets = release.assets {
			DisclosureGroup("Assets (\(assets.count ?? 0))") {
				if let links = assets.links?.nodes {
					ForEach(links, id: \.?.id) { maybeLink in
						if let link = maybeLink {
							if let url = URL(string: link.url ?? "") {
								Link(link.name ?? "Link", destination: url)
							}
						}
					}
				}
				if let sources = assets.sources?.nodes {
					ForEach(sources, id: \.?.url) { maybeSource in
						if let url = URL(string: maybeSource?.url ?? "") {
							Link("Source code (\(maybeSource?.format ?? "unknown"))", destination: url)
						}
					}
				}
			}
		}
	}
}

#Preview {
	NavigationView {
		ProjectReleasesLoader(fullPath: "felix-schindler/gitlab-ios")
	}
}
