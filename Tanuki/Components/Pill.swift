//
//  PillView.swift
//  Tanuki
//
//  Created by Felix Schindler on 26.02.24.
//

import SwiftUI

struct Pill: View {
	private var label: String
	private var icon: String?
	private var fgColor: Color
	private var bgColor: Color
	
	init(_ label: String, icon: String? = nil, bgColor: Color? = nil, fgColor: Color? = nil) {
		self.label = label
		self.icon = icon
		self.fgColor = fgColor ?? .primary
		self.bgColor = bgColor ?? Color(.systemGray5)
	}
	
	var body: some View {
		if let icon = icon {
			Label(label, systemImage: icon)
				.padding(.horizontal, 8)
				.padding(.vertical, 3)
				.background(bgColor)
				.foregroundStyle(fgColor)
				.cornerRadius(25)
		} else {
			Text(label)
				.padding(.horizontal, 8)
				.padding(.vertical, 3)
				.background(bgColor)
				.foregroundStyle(fgColor)
				.cornerRadius(25)
		}
	}
}

#Preview {
	VStack {
		Pill("Test")
		Pill("Something")
		Pill("Sth else")
		Pill("abc", bgColor: .green, fgColor: .white)
		Pill("abc", bgColor: .yellow, fgColor: .black)
		Pill("abc", bgColor: .orange, fgColor: .black)
		Pill("abc", bgColor: .blue, fgColor: .white)
		Pill("abc", bgColor: .red, fgColor: .white)
	}
}
