//
//  NewReleaseView.swift
//  Tanuki
//
//  Created by Felix Schindler on 20.09.25.
//

import SwiftUI
import HighlightedTextEditor

struct NewReleaseView: View {
	@Environment(\.presentationMode)
	var presentationMode: Binding<PresentationMode>

	@State public var id: Int

	@State private var tags: [Tag]? = nil
	@State private var tagName = ""
	@State private var releaseName = ""
	@State private var description = ""

	private func dismiss() {
		self.presentationMode.wrappedValue.dismiss()
	}

	private func loadTags() async {
		do {
			let temp = try await API.get(
				type: [Tag].self,
				endpoint: "/projects/\(id)/repository/tags"
			)
			
			self.tags = temp
			self.tagName = temp[0].name
		} catch let error {
			Notify.status(.error, error.localizedDescription)
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

		if releaseName.isNotEmpty {
			body["name"] = releaseName
		}

		if description.isNotEmpty {
			body["description"] = description
		}

		do {
			_ = try await API.req(
				type: RestAPIRelease.self,
				method: .post,
				endpoint: "projects/\(id)/releases",
				body: body
			)

			dismiss()
		} catch let error {
			Notify.status(.error, error.localizedDescription)
		}
	}

	public var body: some View {
		Form {
			if let tags,
			   tags.isNotEmpty
			{
				Picker(
					"Tag", selection: $tagName,
					content: {
						ForEach(tags, id: \.name) { tag in
							Text(tag.name)
								.tag(tag.name)
						}
					})
			} else {
				TextField("Tag name", text: $tagName)
			}
			
			Section("Details (optional)") {
				TextField("Name", text: $releaseName)
				VStack(alignment: .leading) {
					Text("Description (Markdown supported)")
						.font(.callout)
						.foregroundStyle(.secondary)
					HighlightedTextEditor(text: $description, highlightRules: .markdown)
						.frame(minHeight: 100)
				}
			}
		}.toolbar {
			AsyncButton("Create new release", systemImage: "checkmark") {
				await createNewRelease()
			}.tint(.accentColor)
		}.onAppear {
			Task {
				await loadTags()
			}
		}.refreshable {
			await loadTags()
		}.navigationTitle("New Release")
	}
}

#Preview {
	NavigationStack {
		NewReleaseView(id: 278_964)
	}
}
