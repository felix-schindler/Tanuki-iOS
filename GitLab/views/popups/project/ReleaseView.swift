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
	
	@State private var releases: [Release]? = nil
	@State private var loadFailed = false
	
	
	@State private var showNewRelease = false
	@State private var newReleaseError = false
	
	@State private var tagName = ""
	@State private var releaseName = ""
	@State private var description = ""
	
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
					Text(Messages.failedToLoad)
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
		}.toolbar {
			RoundIconButton("New Release", icon: "plus") {
				showNewRelease = true
			}
		}.sheet(isPresented: $showNewRelease) {
			VStack {
				Form {
					Section {
						VStack(alignment: .leading) {
							TextField("Tag name", text: $tagName)
							Text("This is the only required field")
								.font(.footnote)
								.foregroundStyle(.secondary)
						}
						TextField("Name", text: $releaseName)
						TextField(
							"Description (Markdown supported)",
							text: $description,
							axis: .vertical
						).frame(minHeight: 65, alignment: .top)
					}.presentationDetents([.large, .medium])
				}
				
				VStack {
					AsyncButton(action: {
						await createNewRelease()
					}, label: {
						Text("Create new Release")
							.frame(maxWidth: .infinity)
					}).tint(.green)
						.buttonStyle(.bordered)
						.controlSize(.large)
					
					Button(role: .cancel,
						   action: {
						showNewRelease = false
					}, label: {
						Text("Cancel")
							.frame(maxWidth: .infinity)
					}
					).foregroundStyle(.secondary)
						.buttonStyle(.bordered)
						.controlSize(.large)
				}.padding()
			}.alert("Failed to create new Release", isPresented: $newReleaseError, actions: {})
		}.navigationBarTitle("Releases")
			.headerProminence(.increased)
			.listStyle(.sidebar)
	}
	
	private func getReleases() async -> Void {
		releases = await API.get(type: [Release].self, endpoint: "projects/\(id)/releases")
		loadFailed = releases == nil
	}
	
	private func createNewRelease() async -> Void {
		var body: Dictionary<String, String> = [:]
		
		if (tagName.isNotEmpty) {
			body["tag_name"] = tagName
		} else {
			newReleaseError = true
			return
		}
		
		if (releaseName.isNotEmpty) {
			body["name"] = releaseName
		}
		
		if (description.isNotEmpty) {
			body["description"] = description
		}
		
		if let res = await API.req(
			type: Release.self,
			method: .post,
			endpoint: "projects/\(id)/releases",
			body: body
		) {
			releases?.append(res)
		} else {
			newReleaseError = true
		}
	}
}

#Preview {
	NavigationStack {
		ReleaseView(id: 278964)
	}
}
