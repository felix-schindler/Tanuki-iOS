//
//  ContributionLoader.swift
//  GitLab
//
//  Created by Felix Schindler on 08.03.23.
//

import SwiftUI
import ContributionChart

struct ContributionLoader: View {
	@State var username: String
	@State var data: [Double]? = nil
	@State var loadFailed: Bool = false
	
	var body: some View {
		VStack {
			if (data != nil) {
				ContributionChartView(data: data!,
															rows: 4,
															columns: 14,
															targetValue: 5,
															blockColor: .green)
			} else {
				if (loadFailed) {
					Text("Failed to load contributions, please check your internet connection and your token")
				} else {
					ProgressView("Loading contributions")
				}
			}
		}.onAppear {
			Task.init {
				await getContributions()
			}
		}
	}
	
	private func getContributions() async -> Void {
		let temp = await API.get(type: Dictionary<String, Double>.self, endpoint: "users/\(username)/calendar.json", useBase: false)
		if (temp != nil && !temp!.isEmpty) {
			data = Array(temp!.values)
		} else {
			loadFailed = true
		}
	}
}

struct ContributionLoader_Previews: PreviewProvider {
	static var previews: some View {
		ContributionLoader(username: "felix-schindler")
	}
}
