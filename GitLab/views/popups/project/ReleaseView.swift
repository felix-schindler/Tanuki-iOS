//
//  ReleaseView.swift
//  GitLab
//
//  Created by Felix Schindler on 05.05.23.
//

import SwiftUI
import MarkdownUI

struct ReleaseView: View {
	/// Project ID
	@State var id: Int
	
	@State var releases: [Release]? = nil
	@State var loadFailed: Bool = false
	
	var body: some View {
		List {
			if (releases != nil) {
				if (releases!.isEmpty) {
					Text("You'll see your releases after you pushed them")
				} else {
					ForEach(releases!, id: \.name) { release in
						Section(release.name.emojized()) {
							if (release.assets != nil && release.assets!.count > 0) {
								DisclosureGroup("Assets (\(release.assets!.count))", content: {
									ForEach(release.assets!.sources, id: \.format) { source in
										Link("Source code (\(source.format))", destination: URL(string: source.url)!)
									}
								})
							}

							HStack {
								HStack(spacing: 2) {
									Image(systemName: "tag")
									Text(release.tagName)
								}
								Spacer()
								HStack(spacing: 2) {
									Image(systemName: "text.line.first.and.arrowtriangle.forward")
									Text(release.commit.shortId)
										.font(.system(.body, design: .monospaced))
								}
							}

							Text("Released on \(release.releasedAt.toString()) by \(release.author.name)")

							if (!release.description.isEmpty) {
								Markdown(release.description)
							}
						}
					}
				}
			} else {
				if (loadFailed) {
					Text("Failed to load, please check your internet connection and your token")
						.foregroundStyle(.red)
				} else {
					ProgressView()
				}
			}
		}.onAppear {
			Task {
				await getReleases()
			}
		}.refreshable {
			await getReleases()
		}.navigationBarTitle("Releases")
			.headerProminence(.increased)
			.listStyle(.sidebar)
	}
	
	private func getReleases() async -> Void {
		releases = await API.get(type: [Release].self, endpoint: "projects/\(id)/releases")
		loadFailed = releases == nil
	}
}

struct ReleaseView_Previews: PreviewProvider {
	static var previews: some View {
		ReleaseView(id: 278964)
	}
}
