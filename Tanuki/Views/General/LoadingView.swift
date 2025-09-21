//
//  LoadingView.swift
//  Tanuki
//
//  Created by Felix Schindler on 21.09.25.
//

import SwiftUI

struct LoadingView: View {
	private let msg: String
	private let icon: String
	private let color: Color

	init(_ message: String, systemImage: String, color: Color = .secondary) {
		self.msg = message
		self.icon = systemImage
		self.color = color
	}

	var body: some View {
		VStack {
			ProgressView(label: {
				Label(
					title: {
						Text(self.msg)
					},
					icon: {
						Image(systemName: self.icon)
							.foregroundStyle(self.color)
					})
			})
		}.frame(maxWidth: .infinity, minHeight: 100)
	}
}

#Preview {
	LoadingView("Loading Project", systemImage: "app.gift.fill")
}
