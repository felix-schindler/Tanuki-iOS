//
//  LabelListView.swift
//  GitLab
//
//  Created by Felix Schindler on 06.11.21.
//

import SwiftUI

struct LabelListView: View {
	@State var labels: [APILabel]
	
	var body: some View {
		HStack(spacing: 5) {
			ForEach(labels, id: \.id) { label in
				Text(label.name.emojized())
					.padding(.horizontal, 6)
					.padding(.vertical, 4)
					.background(Color.init(hex: label.color))
					.cornerRadius(25)
					.foregroundColor(Color.init(hex: label.textColor))
			}
		}
	}
}

struct LabelListView_Previews: PreviewProvider {
	static var previews: some View {
		LabelListView(labels: [
      APILabel(id: 1, name: "enhancement", color: "#5cb85c", textColor: "#FFFFFF"),
      APILabel(id: 2, name: "bug", color: "#d9534f", textColor: "#FFFFFF"),
      APILabel(id: 3, name: "documentation", color: "#f0ad4e", textColor: "#FFFFFF")
    ])
	}
}
