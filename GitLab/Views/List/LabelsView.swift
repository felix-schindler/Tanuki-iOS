//
//  LabelListView.swift
//  GitLab
//
//  Created by Felix Schindler on 19.03.23.
//

import SwiftUI

struct LabelsView: View {
	@State var labels: [APILabel]
	@State var updateFunction: () async -> [APILabel]?
	
	var body: some View {
		List {
			if (labels.isEmpty) {
				Text("There are no users")
			} else {
				ForEach(labels, id: \.id) { label in
					VStack(alignment: .leading) {
						Text(label.name.emojized())
							.padding(.horizontal, 8)
							.padding(.vertical, 3)
							.background(Color.init(hex: label.color))
							.foregroundColor(Color.init(hex: label.textColor))
							.cornerRadius(25)
						if (label.description != nil && label.description != "") {
							Text(label.description!)
								.font(.callout)
								.foregroundColor(.secondary)
						}
					}
				}
			}
		}.refreshable {
			Task.init {
				let temp = await updateFunction()
				if (temp != nil) {
					labels = temp!
				}
			}
		}.navigationTitle("Labels")
	}
}

struct LabelsView_Previews: PreviewProvider {
	static var previews: some View {
		LabelsView(labels: [
			APILabel(id: 1, name: "enhancement", description: "", color: "#5cb85c", textColor: "#FFFFFF"),
			APILabel(id: 2, name: "bug", description: "", color: "#d9534f", textColor: "#FFFFFF"),
			APILabel(id: 3, name: "documentation", description: "", color: "#f0ad4e", textColor: "#FFFFFF")
		], updateFunction: { nil })
	}
}
