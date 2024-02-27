//
//  PillView.swift
//  Tanuki
//
//  Created by Felix Schindler on 26.02.24.
//

import SwiftUI

struct Pill: View {
	private let label: String
	private let icon: String?
	private let fgColor: Color
	private let bgColor: Color
	private let cornerRadius: CGFloat
	
	init(_ label: String, icon: String? = nil, bgColor: Color? = nil, fgColor: Color? = nil, cornerRadius: CGFloat = 25) {
		self.label = label
		self.icon = icon
		self.fgColor = fgColor ?? .primary
		self.bgColor = bgColor ?? Color(.systemGray5)
		self.cornerRadius = cornerRadius
	}
	
	public var body: some View {
		if let icon = icon {
			Label(label, systemImage: icon)
				.padding(.horizontal, 8)
				.padding(.vertical, 3)
				.background(bgColor)
				.foregroundStyle(fgColor)
				.cornerRadius(cornerRadius)
		} else {
			Text(label)
				.padding(.horizontal, 8)
				.padding(.vertical, 3)
				.background(bgColor)
				.foregroundStyle(fgColor)
				.cornerRadius(cornerRadius)
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
