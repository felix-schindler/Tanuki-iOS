//
//  NoContentView.swift
//  Tanuki Watch App
//
//  Created by Felix Schindler on 21.09.25.
//

import SwiftUI

struct NoContentView: View {
	private let msg: String
	private let icon: String
	
	init(_ message: String, systemImage: String) {
		self.msg = message
		self.icon = systemImage
	}
	
	public var body: some View {
		if #available(watchOS 10.0, *) {
			ContentUnavailableView(msg, systemImage: icon)
		} else {
			VStack {
				Image(systemName: icon)
				Text(msg)
					.font(.headline)
			}
		}
	}
}
	
#Preview {
	NoContentView("There's no content here", systemImage: "checkmark")
}
