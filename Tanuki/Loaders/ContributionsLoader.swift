//
//  ContributionsLoader.swift
//  Tanuki
//
//  Created by Felix Schindler on 09.04.24.
//

import Charts
import SwiftUI

struct ContributionsLoader: View {
	private let username: String
	private let height: CGFloat = 50

	/// User contributions in format ["YYYY-MM-DD" → intCount]
	@State
	private var contributions: [String: Int]? = nil

	@State
	private var loadFailed = false

	init(username: String) {
		self.username = username
	}

	private func loadContributions() async {
		if var temp = await API.get(
			type: [String: Int].self,
			endpoint: "users/\(username)/calendar.json",
			useBase: false
		) {
			if let startDate = Calendar.current.date(byAdding: .year, value: -1, to: Date()) {
				let endDate = Date()
				var currentDate = startDate
				let dateFormatter = DateFormatter()
				dateFormatter.dateFormat = "yyyy-MM-dd"

				while currentDate <= endDate {
					let dateString = dateFormatter.string(from: currentDate)
					if temp[dateString] == nil {
						temp[dateString] = 0
					}
					currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
				}
			}

			contributions = temp
		}

		loadFailed = contributions == nil
	}

	var body: some View {
		VStack {
			if let contributions = self.contributions {
				Chart {
					ForEach(contributions.sorted(by: { $0.key < $1.key }), id: \.key) {
						key, value in
						BarMark(
							x: .value("Date", key),
							y: .value("Contributions", value)
						)
					}
				}
				.chartYAxis {
					AxisMarks(values: .automatic(desiredCount: 3))
				}
				.chartXAxis(.hidden)
				.frame(height: self.height)
			} else {
				if loadFailed {
					Text("Failed to load contributions")
				} else {
					ProgressView("Loading contributions")
				}
			}
		}.onAppear {
			Task {
				await loadContributions()
			}
		}.refreshable {
			await loadContributions()
		}.frame(maxWidth: .infinity, minHeight: self.height)
	}
}

#Preview {
	List {
		ContributionsLoader(username: "felix-schindler")
	}
}
