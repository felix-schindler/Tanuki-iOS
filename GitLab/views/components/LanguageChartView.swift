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
				BarMark(
					x: .value("Percent", value)
				).foregroundStyle(by: .value("Language", key))
			}
		}
		.chartXAxis(.hidden)
		.frame(height: 30)
	}
}

#Preview {
	NavigationStack {
		LanguageChartView(languages: [
			"Swift": 50.0,
			"Dart": 30.0,
			"HTML": 20.0
		]).padding()
	}
}
