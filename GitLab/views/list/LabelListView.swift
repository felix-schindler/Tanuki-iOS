//
//  LabelListView.swift
//  GitLab
//
//  Created by Felix Schindler on 06.11.21.
//

import SwiftUI

struct LabelListView: View {
	@State var labels: [APILabel]
	@State var showDescription = false
	
	/// Project ID (needed for deletion)
	@State var projectId: Int?
	@State var deletionError = false
	
	var body: some View {
		ForEach(labels, id: \.id) { label in
			VStack(alignment: .leading) {
				Text(label.name.emojized())
					.padding(.horizontal, 8)
					.padding(.vertical, 3)
					.background(Color.init(hex: label.color))
					.foregroundColor(Color.init(hex: label.textColor))
					.cornerRadius(25)
				if (showDescription && label.description != nil && label.description != "") {
					Text(label.description!)
						.font(.callout)
						.foregroundColor(.secondary)
				}
			}.swipeActions(edge: .trailing) {
				AsyncButton(action: {
					if (projectId != nil) {
						let code = await API.delete(endpoint: "projects/\(projectId!)/labels/\(label.id)")
						deletionError = (code.rawValue < 200 || code.rawValue >= 300)
					} else {
						deletionError = true
					}
				}, role: .destructive, label: {
					Label("Delete", systemImage: "trash")
				}).alert(isPresented: $deletionError, content: {
					Alert(title: Text("Error"), message: Text("Failed to delete label"), dismissButton: .default(Text("OK")))
				})
			}
		}
	}
}

struct LabelListView_Previews: PreviewProvider {
	static var previews: some View {
		LabelListView(labels: [
			APILabel(id: 1, name: "enhancement", description: "Something describing it", color: "#5cb85c", textColor: "#FFFFFF"),
			APILabel(id: 2, name: "bug", description: "", color: "#d9534f", textColor: "#FFFFFF"),
			APILabel(id: 3, name: "documentation", description: "", color: "#f0ad4e", textColor: "#FFFFFF")
		], showDescription: true)
	}
}
