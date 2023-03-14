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
		ScrollView(.horizontal) {
			HStack(spacing: 4) {
				ForEach(labels, id: \.id) { label in
					Text(label.name.emojized())
						.padding(.horizontal, 8)
						.padding(.vertical, 3)
						.background(Color.init(hex: label.color))
						.foregroundColor(Color.init(hex: label.textColor))
						.cornerRadius(25)
				}
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
