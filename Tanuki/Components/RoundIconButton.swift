//
//  RoundIconButton.swift
//  Tanuki
//
//  Created by Felix Schindler on 26.02.24.
//

import SwiftUI

struct CloseButton: View {
	private var action: () -> Void
	
	init(_ action: @escaping () -> Void) {
		self.action = action
	}
	
	var body: some View {
		RoundIconButton("Close", icon: "xmark", action: action)
			.fontWeight(.medium)
			.tint(.secondary)
	}
}

struct ShareButton: View {
	private var url: URL
	
	init(_ url: URL) {
		self.url = url
	}
	
	var body: some View {
		ShareLink(item: url) {
			Label("Share", systemImage: "square.and.arrow.up")
		}.labelStyle(.iconOnly)
	}
}

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
		Button(label, systemImage: iconName, action: action)
			.buttonStyle(.bordered)
			.clipShape(Circle())
			.labelStyle(.iconOnly)
	}
}

#Preview {
	HStack {
		VStack {
			ShareButton(URL(string: "https://schindlerfelix.de")!)
			ShareButton(URL(string: "https://gitlab.com")!)
			ShareButton(URL(string: "https://gitlab.com/felix-schindler/gitlab-ios")!)
		}
		VStack {
			RoundIconButton("Up", icon: "arrow.up", action: {})
			RoundIconButton("Filters", icon: "line.3.horizontal.decrease", action: {})
			RoundIconButton("Add", icon: "plus") {
			}
			RoundIconButton("Events", icon: "bell", action: {})
			CloseButton({})
			RoundIconButton("Cancel", icon: "xmark", action: {})
				.tint(.secondary)
			RoundIconButton("Cancel", icon: "xmark", action: {})
				.tint(.red)
		}
	}
}
