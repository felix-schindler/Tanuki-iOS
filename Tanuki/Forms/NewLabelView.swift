//
//  NewLabelView.swift
//  Tanuki
//
//  Created by Felix Schindler on 20.09.25.
//

import HighlightedTextEditor
import SwiftUI

struct NewLabelView: View {
	@Environment(\.presentationMode)
	var presentationMode: Binding<PresentationMode>

	/// Project ID
	@State var id: Int
	/// Group ID
	@State var groupId: Int

	@State var title: String = ""
	@State var description: String = ""
	@State var color: Color = Color(.red)

	@State var prio: Int = -1

	@State var isError: Bool = false

	var body: some View {
		List {
			Section("Title") {
				TextField("enhancement", text: $title)
			}

			Section("Details") {
				VStack(alignment: .leading) {
					Text("Description (optional)")
						.font(.callout)
						.foregroundStyle(.secondary)
					HighlightedTextEditor(text: $description, highlightRules: .markdown)
				}
				ColorPicker("Background color", selection: $color)
				Stepper("Priority: \(prio < 0 ? "none" : String(prio))", value: $prio)
			}
		}.toolbar {
			AsyncButton("Save", systemImage: "checkmark") {
				await saveNewLabel()
			}.tint(.accentColor)
		}.navigationBarTitle("New Label")
	}

	private func saveNewLabel() async {
		var query: [String: String] = [
			"name": title,
			"color": "#\(color.hex!.dropLast(2))",
		]

		if description != "" {
			query["description"] = description
		}

		if prio >= 0 {
			query["priority"] = String(prio)
		}

		do {
			_ = try await API.req(
				type: RestAPILabel.self,
				method: .post,
				endpoint: (id != 0 ? "projects/\(id)/labels" : "groups/\(id)/labels"),
				query: query
			)

			self.presentationMode.wrappedValue.dismiss()
		} catch let error {
			Notify.status(.error, error.localizedDescription)
		}
	}
}

#Preview {
	NavigationView {
		NewLabelView(id: 33_025_310, groupId: 0)
	}
}
