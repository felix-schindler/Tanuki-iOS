//
//  LanguagesListView.swift
//  GitLab
//
//  Created by Felix Schindler on 19.03.23.
//

import SwiftUI

struct LanguagesListView: View {
	@State var languages: Dictionary<String, Double>

	var body: some View {
		ScrollView(.horizontal) {
			HStack {
				ForEach(languages.sorted(by: >), id: \.key) { key, value in
					Text("\(key): \(value, specifier: "%.2f")%")
						.padding(.horizontal, 6)
						.padding(.vertical, 4)
						.background(Color(.systemGray3))
						.cornerRadius(10)
				}.font(.caption)
			}
		}
	}
}

struct LanguagesListView_Previews: PreviewProvider {
	static var previews: some View {
		LanguagesListView(languages: [:])
	}
}
