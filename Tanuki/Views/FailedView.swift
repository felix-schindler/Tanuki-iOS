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
	
	init (_ message: String) {
		self.icon = "exclamationmark.triangle"
		self.msg = message
	}
	
	init(icon: String = "exclamationmark.triangle", msg: String = "Failed to load. Please make sure you're connected to the internet.") {
		self.icon = icon
		self.msg = msg
	}
	
	public var body: some View {
		VStack {
			Image(systemName: icon)
				.resizable()
				.frame(width: 50, height: 50)
			Text(msg)
				.foregroundStyle(.red)
		}.frame(maxWidth: .infinity)
	}
}

#Preview {
	List {
		FailedView(msg: "short")
	}
}
