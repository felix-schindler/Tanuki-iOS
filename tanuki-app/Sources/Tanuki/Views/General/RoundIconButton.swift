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

	public var body: some View {
		RoundIconButton("Close", icon: "xmark", action: action)
			.font(.system(size: 16, weight: .bold))
			.tint(.secondary)
	}
}

struct ShareButton: View {
	private let url: URL

	@State var isSharePresented = false

	init(_ url: URL) {
		self.url = url
	}

	public var body: some View {
		if #available(iOS 16.0, macOS 13.0, *) {
			ShareLink(item: url) {
				Label("Share", systemImage: "square.and.arrow.up")
			}
		}
	}
}

#if canImport(UIKit)
struct ShareSheet: UIViewControllerRepresentable {
	var items: [Any]  // items to share
	var excludedActivityTypes: [UIActivity.ActivityType]? = nil

	func makeUIViewController(context: Context) -> UIActivityViewController {
		let controller = UIActivityViewController(
			activityItems: items,
			applicationActivities: nil
		)
		controller.excludedActivityTypes = excludedActivityTypes
		return controller
	}

	func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
#endif

struct RoundIconButton: View {
	private let label: String
	private let iconName: String
	private let action: () -> Void

	init(
		_ label: String, icon: String, role: ButtonRole? = nil,
		action: @escaping () -> Void
	) {
		self.label = label
		self.iconName = icon
		self.action = action
	}

	public var body: some View {
		if #available(iOS 17.0, *) {
			Button(label, systemImage: iconName, action: action)
				.frame(minWidth: 30, minHeight: 30)
				.buttonStyle(.bordered)
				.buttonBorderShape(.circle)
				.labelStyle(.iconOnly)
		} else {
			Button(label, systemImage: iconName, action: action)
				.frame(minWidth: 30, minHeight: 30)
				.buttonStyle(.bordered)
				.clipShape(Circle())
				.labelStyle(.iconOnly)
		}
	}
}
