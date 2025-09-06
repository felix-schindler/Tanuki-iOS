//
//  FailedView.swift
//  Tanuki
//
//  Created by Felix Schindler on 04.09.25.
//

import SwiftUI

struct FailedView: View {
	private let icon: String
	private let msg: String

	init(_ message: String) {
		self.icon = "exclamationmark.triangle"
		self.msg = message
	}

	init(
		_ message: String = "Failed to load. Please make sure you're connected to the internet.",
		icon: String = "exclamationmark.triangle"
	) {
		self.icon = icon
		self.msg = message
	}

	public var body: some View {
		ContentUnavailableView(msg, systemImage: icon)
			.foregroundStyle(.red)
	}
}

#Preview {
	List {
		FailedView("short")
	}
}
