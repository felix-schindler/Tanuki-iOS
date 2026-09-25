//
//  Notify.swift
//  Tanuki
//
//  Created by Felix Schindler on 22.04.24.
//

import SkipKit
import SwiftUI

enum NotifyStatus: Int {
	case success = 0
	case
		warning = 1
	case
		error = 2

	var color: Color {
		switch self {
		case .success:
			return .green
		case .warning:
			return .orange
		case .error:
			return .red
		}
	}

	var defaultIcon: String {
		switch self {
		case .success:
			return "checkmark.circle"
		case .warning:
			return "exclamationmark.triangle"
		case .error:
			return "xmark"
		}
	}

	/// Overridable per message.
	var haptic: HapticPattern {
		switch self {
		case .success:
			return .success
		case .warning:
			return .warning
		case .error:
			return .error
		}
	}
}

struct NotifyMessage {
	let id = UUID()
	let status: NotifyStatus
	var title: String?
	var subtitle: String?
	var systemImage: String?
	var duration: Duration = .seconds(4)

	/// Messages with no text exist only for their haptic and must not occupy a queue slot.
	var isDisplayable: Bool {
		!(title ?? "").isEmpty || !(subtitle ?? "").isEmpty
	}

	/// An untitled failure still surfaces, as it always has.
	var displayTitle: String? {
		if let title, !title.isEmpty {
			return title
		}
		return status == .error ? "Something went wrong" : nil
	}
}

@MainActor
final class NotifyCenter {
	static let shared = NotifyCenter()

	private static let maxPending = 8

	private(set) var message: NotifyMessage?

	private var pending: [NotifyMessage] = []
	private var observers: [String: (NotifyMessage?) -> Void] = [:]
	private var dismissTask: Task<Void, Never>?

	private init() {
	}

	func addObserver(_ handler: @escaping (NotifyMessage?) -> Void) -> String {
		let token = UUID().uuidString
		observers[token] = handler
		handler(message)
		return token
	}

	func removeObserver(_ token: String) {
		observers.removeValue(forKey: token)
	}

	func show(_ message: NotifyMessage) {
		if self.message != nil {
			if pending.count >= NotifyCenter.maxPending {
				pending.removeFirst()
			}
			pending.append(message)
			return
		}
		present(message)
	}

	func dismiss(_ id: UUID) {
		guard message?.id == id else {
			return
		}
		guard !pending.isEmpty else {
			message = nil
			dismissTask?.cancel()
			dismissTask = nil
			broadcast()
			return
		}
		present(pending.removeFirst())
	}

	private func present(_ message: NotifyMessage) {
		dismissTask?.cancel()
		HapticFeedback.play(message.status.haptic)
		self.message = message
		broadcast()

		let id = message.id
		let duration = message.duration
		dismissTask = Task { [weak self] in
			try? await Task.sleep(for: duration)
			guard !Task.isCancelled else {
				return
			}
			self?.dismiss(id)
		}
	}

	private func broadcast() {
		for observer in observers.values {
			observer(message)
		}
	}
}

/// The app-wide feedback entry point.
@MainActor
class Notify {

	/// For messages whose status is only known at runtime.
	public static func show(_ message: NotifyMessage) {
		// Mirror it into the platform log: `adb logcat -s de.schindlerfelix.GitLab.Tanuki`.
		let text = [message.title, message.subtitle].compactMap { $0 }.filter { !$0.isEmpty }
			.joined(separator: " — ")
		if !text.isEmpty {
			switch message.status {
			case .success:
				logger.info("ok: \(text)")
			case .warning:
				logger.warning("warn: \(text)")
			case .error:
				logger.error("error: \(text)")
			}
		}

		// A message with no text only exists for its haptic; the banner has nothing to draw.
		if message.isDisplayable {
			NotifyCenter.shared.show(message)
		}
	}

	public static func status(
		_ feedbackType: NotifyStatus, _ title: String? = nil, _ subtitle: String? = nil,
		systemImage: String? = nil
	) {
		show(
			NotifyMessage(
				status: feedbackType, title: title, subtitle: subtitle, systemImage: systemImage))
	}
}
