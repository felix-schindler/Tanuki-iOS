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
		Chart {
			ForEach(languages.sorted(by: >), id: \.key) { key, value in
				BarMark(x: .value("Language", key), y: .value("Percent", value))
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
