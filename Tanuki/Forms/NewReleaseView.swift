//
//  NewReleaseView.swift
//  Tanuki
//
//  Created by Felix Schindler on 20.09.25.
//

import GitLabAPI
import HighlightedTextEditor
import SwiftUI

struct NewReleaseView: View {
	@Environment(\.presentationMode)
	var presentationMode: Binding<PresentationMode>

	private let id: Int
	private let fullPath: String

	init(id: Int, fullPath: String) {
		self.id = id
		self.fullPath = fullPath
	}

	@State private var tags: [Tag]? = nil
	@State private var milestones: [ProjectMilestonesQuery.Data.Project.Milestones.Node?]? = nil

	@State private var tagName = ""
	@State private var newTagName = false
	@State private var newTagMessage = ""
	@State private var newTagRef = ""
	@State private var releaseName = ""
	@State private var selectedMilestone = ""
	@State private var setReleaseDate = false
	@State private var releaseDate = Date()
	@State private var description = ""

	private func dismiss() {
		self.presentationMode.wrappedValue.dismiss()
	}

	private func loadTags() async {
		do {
			let temp = try await API.get(
				type: [Tag].self,
				endpoint: "projects/\(id)/repository/tags"
			)

			self.tags = temp
			self.tagName = temp[0].name
		} catch let error {
			Notify.status(
				.error, "Couldn't load tags", error.localizedDescription,
				systemImage: "exclamationmark.triangle")
		}
	}

	private func loadMilestones() async {
		do {
			let response = try await Network.shared.apollo.fetch(
				query: ProjectMilestonesQuery(fullPath: self.fullPath),
				cachePolicy: .networkOnly
			)

			if let milestones = response.data?.project?.milestones?.nodes {
				self.milestones = milestones
			}
		} catch let error {
			Notify.status(
				.error,
				"Couldn't load milestones",
				error.localizedDescription,
				systemImage: "exclamationmark.triangle"
			)
		}
	}

	private func createNewRelease() async {
		var body: [String: String] = [:]

		if tagName.isNotEmpty {
			body["tag_name"] = tagName
		} else {
			Notify.status(.error, "There is no tag name")
			return
		}
		
		if newTagName {
			if newTagRef.isNotEmpty {
				body["ref"] = newTagRef
			} else {
				Notify.status(.error, "There is no ref name")
			}
			
			if newTagMessage.isNotEmpty {
				body["tag_message"] = newTagMessage
			}
		}

		if releaseName.isNotEmpty {
			body["name"] = releaseName
		}

		if description.isNotEmpty {
			body["description"] = description
		}

		if selectedMilestone.isNotEmpty {
			body["milestones"] = "[\(selectedMilestone)]"
		}

		if setReleaseDate {
			body["released_at"] = ISO8601DateFormatter().string(from: releaseDate)
		}

		do {
			_ = try await API.req(
				type: RestAPIRelease.self,
				method: .post,
				endpoint: "projects/\(id)/releases",
				body: body
			)

			self.dismiss()
		} catch let error {
			Notify.status(
				.error, "Couldn't create new Release", error.localizedDescription,
				systemImage: "exclamationmark.triangle")
		}
	}

	public var body: some View {
		Form {
			Section("Tag name (required)") {
				Toggle("Create new tag name", isOn: $newTagName)
					.onChange(of: newTagName) { newValue in
						if newValue {
							self.tagName = ""
						} else if let tags, tags.isNotEmpty {
							self.tagName = tags[0].name
						}
					}
				if !newTagName, let tags, tags.isNotEmpty {
					Picker("Tag", selection: $tagName) {
						ForEach(tags, id: \.name) { tag in
							Text(tag.name)
								.tag(tag.name)
						}
					}
				} else if newTagName {
					TextField("Tag name", text: $tagName)
						.textInputAutocapitalization(.never)
						.autocorrectionDisabled()
					VStack(alignment: .leading) {
						TextField("Tag message (optional)", text: $newTagMessage)
							.textInputAutocapitalization(.never)
							.autocorrectionDisabled()
						Text("Message to use if creating a new annotated tag.")
							.foregroundStyle(.secondary)
							.font(.footnote)
					}
					VStack(alignment: .leading) {
						TextField("Ref", text: $newTagRef)
							.textInputAutocapitalization(.never)
							.autocorrectionDisabled()
						Text("It can be a commit SHA, another tag name, or a branch name.")
							.foregroundStyle(.secondary)
							.font(.footnote)
					}
				} else {
					VStack(alignment: .leading) {
						TextField("Tag name", text: $tagName)
							.textInputAutocapitalization(.never)
							.autocorrectionDisabled()
						Text("Enter an existing tag name.")
							.foregroundStyle(.secondary)
							.font(.footnote)
					}
				}
			}

			Section("Release title") {
				VStack(alignment: .leading) {
					TextField("Title", text: $releaseName)
					Text("Leave blank to use the tag name as the release title.")
						.foregroundStyle(.secondary)
						.font(.footnote)
				}
			}

			Section("Milestone") {
				if let milestones, milestones.isNotEmpty {
					Picker("Milestone", selection: $selectedMilestone) {
						ForEach(milestones, id: \.?.iid) { milestone in
							if let milestone {
								Text(milestone.title)
									.tag(milestone.iid)
							}
						}
					}
				} else {
					Text("There are no active Milestones")
				}
			}

			Section("Release date") {
				Toggle("Set date when the release is ready", isOn: $setReleaseDate)
				if setReleaseDate {
					VStack(alignment: .leading) {
						DatePicker(
							"Release date", selection: $releaseDate, displayedComponents: .date)
						Text(
							"A release with a date in the future is labeled as an Upcoming Release."
						)
						.foregroundStyle(.secondary)
						.font(.footnote)
					}
				}
			}

			Section("Release notes (Markdown supported)") {
				HighlightedTextEditor(text: $description, highlightRules: .markdown)
					.frame(minHeight: 100)
			}
		}.toolbar {
			AsyncButton("Create new release", systemImage: "checkmark") {
				await createNewRelease()
			}.tint(.accentColor)
		}.onAppear {
			Task {
				await loadTags()
				await loadMilestones()
			}
		}.refreshable {
			await loadTags()
			await loadMilestones()
		}.navigationTitle("New Release")
	}
}

#Preview {
	NavigationView {
		NewReleaseView(id: 278_964, fullPath: "gitlab-org/gitlab")
	}
}
