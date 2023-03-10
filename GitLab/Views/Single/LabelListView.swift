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
		LabelListView(labels: [APILabel]())
	}
}
