//
//  NoContentView.swift
//  Tanuki
//
//  Created by Felix Schindler on 21.09.25.
//

import SwiftUI

struct NoContentView: View {
	private let msg: String
	private let icon: String
	private let description: String?

	init(_ message: String, systemImage: String, description: String? = nil) {
		self.msg = message
		self.icon = systemImage
		self.description = description
	}

	var body: some View {
		if #available(iOS 17.0, *) {
			if let description {
				ContentUnavailableView(msg, systemImage: icon, description: Text(description))
			} else {
				ContentUnavailableView(msg, systemImage: icon)
			}
		} else {
			VStack {
				Image(systemName: self.icon)
					.resizable()
					.scaledToFill()
					.foregroundStyle(.secondary)
					.frame(width: 40, height: 40)
					.padding(.bottom, 10)
				Text(self.msg)
					.font(.title2.bold())
				if let description {
					Text(description)
						.font(.callout)
						.foregroundStyle(.secondary)
				}
			}
			.padding()
			.frame(maxWidth: .infinity, minHeight: 100)
		}
	}
}

#Preview {
	NoContentView(
		"All caught up!",
		systemImage: "checkmark.square",
		description: "There are no Todos"
	)
}
