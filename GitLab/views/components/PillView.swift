//
//  PillView.swift
//  GitLab
//
//  Created by Felix Schindler on 20.02.24.
//

import SwiftUI

struct PillView: View {
	private var label: String
	private var fgColor: Color
	private var bgColor: Color
	
	init(_ label: String, bgColor: Color? = nil, fgColor: Color? = nil) {
		self.label = label
		self.fgColor = fgColor ?? .primary
		self.bgColor = bgColor ?? Color(.systemGray5)
	}
	
    var body: some View {
		Text(label)
			.padding(.horizontal, 8)
			.padding(.vertical, 3)
			.background(bgColor)
			.foregroundStyle(fgColor)
			.cornerRadius(25)
    }
}

#Preview {
	VStack {
		PillView("Test")
		PillView("Something")
		PillView("Sth else")
		PillView("abc", bgColor: .green, fgColor: .white)
		PillView("abc", bgColor: .yellow, fgColor: .black)
		PillView("abc", bgColor: .orange, fgColor: .black)
		PillView("abc", bgColor: .blue, fgColor: .white)
		PillView("abc", bgColor: .red, fgColor: .white)
	}
}
