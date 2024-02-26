//
//  RoundIconButton.swift
//  GitLab
//
//  Created by Felix Schindler on 20.02.24.
//

import SwiftUI

struct RoundIconButton: View {
	private var label: String
	private var iconName: String
	private var action: () -> Void
	
	init(_ label: String, icon: String, role: ButtonRole? = nil, action: @escaping () -> Void) {
		self.label = label
		self.iconName = icon
		self.action = action
	}
	
	var body: some View {
		if #available(iOS 17.0, *) {
			Button(label, systemImage: iconName, action: action)
				.buttonStyle(.bordered)
				.buttonBorderShape(.circle)
				.labelStyle(.iconOnly)
		} else {
			Button(label, systemImage: iconName, action: action)
				.buttonStyle(.bordered)
				.clipShape(Circle())
				.labelStyle(.iconOnly)
		}
	}
}

#Preview {
	VStack {
		RoundIconButton("Up", icon: "arrow.up", action: {})
		RoundIconButton("Filters", icon: "line.3.horizontal.decrease", action: {})
		RoundIconButton("Add", icon: "plus") {
		}
		RoundIconButton("Events", icon: "bell", action: {})
		RoundIconButton("Cancel", icon: "xmark", action: {})
			.tint(.secondary)
		RoundIconButton("Cancel", icon: "xmark", action: {})
			.tint(.red)
	}
}
