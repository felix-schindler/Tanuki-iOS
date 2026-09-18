//
//  NotifyBanner.swift
//  Tanuki
//
//  Created by Felix Schindler on 18.09.26.
//

import SwiftUI

struct NotifyBanner: View {
	let message: NotifyMessage
	let onDismiss: () -> Void

	private var icon: String {
		if let systemImage = message.systemImage, !systemImage.isEmpty {
			return systemImage
		}
		return message.status.defaultIcon
	}

	private var border: Color {
		message.status.color.opacity(0.4)
	}

	public var body: some View {
		HStack(alignment: .top, spacing: 10) {
			Image(systemName: icon)
				.resizable()
				.scaledToFit()
				.frame(width: 20, height: 20)
				.foregroundStyle(message.status.color)
				.padding(.top, 1)

			VStack(alignment: .leading, spacing: 2) {
				if let title = message.displayTitle {
					Text(title)
						.font(.subheadline.bold())
				}
				if let subtitle = message.subtitle, !subtitle.isEmpty {
					Text(subtitle)
						.font(.caption)
						.foregroundStyle(.secondary)
				}
			}
			.multilineTextAlignment(.leading)
			.frame(maxWidth: .infinity, alignment: .leading)
		}
		.padding(.horizontal, 14)
		.padding(.vertical, 10)
		.background(.regularMaterial, in: RoundedRectangle(cornerRadius: 14))
		.overlay(RoundedRectangle(cornerRadius: 14).strokeBorder(border, lineWidth: 1))
		.shadow(color: Color.black.opacity(0.15), radius: 10, y: 3)
		.padding(.horizontal, 12)
		.onTapGesture {
			onDismiss()
		}
	}
}

struct NotifyBannerHost: ViewModifier {
	@State var message: NotifyMessage?
	@State var observer: String?

	func body(content: Content) -> some View {
		content
			.overlay(alignment: .top) {
				if let message {
					NotifyBanner(message: message) {
						NotifyCenter.shared.dismiss(message.id)
					}
					.padding(.top, 8)
					.transition(.move(edge: .top).combined(with: .opacity))
				}
			}
			.animation(.easeInOut(duration: 0.25), value: message?.id)
			.onAppear {
				observer = NotifyCenter.shared.addObserver { newMessage in
					message = newMessage
				}
			}
			.onDisappear {
				if let observer {
					NotifyCenter.shared.removeObserver(observer)
				}
			}
	}
}

extension View {
	func notifyBanner() -> some View {
		modifier(NotifyBannerHost())
	}
}
