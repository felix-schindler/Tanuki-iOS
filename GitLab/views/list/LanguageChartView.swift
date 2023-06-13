//
//  LanguagesListView.swift
//  GitLab
//
//  Created by Felix Schindler on 19.03.23.
//

import SwiftUI
import Charts

struct LanguageChartView: View {
	@State var languages: Dictionary<String, Double>
	
	var body: some View {
		if #available(iOS 16.0, *) {
			Chart {
				ForEach(languages.sorted(by: >), id: \.key) { key, value in
					BarMark(x: .value("Language", key), y: .value("Percent", value))
				}
			}
		} else {
			// Fallback on earlier versions
			ScrollView(.horizontal) {
				HStack {
					ForEach(languages.sorted(by: >), id: \.key) { key, value in
						Text("\(key): \(value, specifier: "%.2f")%")
							.padding(.horizontal, 6)
							.padding(.vertical, 4)
							.background(Color(.systemGray3))
							.cornerRadius(10)
					}
				}.font(.caption)
			}
		}
	}
}

struct LanguageChartView_Previews: PreviewProvider {
	static var previews: some View {
		LanguageChartView(languages: [
			"Swift": 50.0,
			"Dart": 50.0
		])
	}
}
