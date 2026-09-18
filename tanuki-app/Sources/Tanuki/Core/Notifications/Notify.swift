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
	let id: UUID
	let status: NotifyStatus
	let title: String?
	let subtitle: String?
	let systemImage: String?
	let duration: Duration
	let haptic: HapticPattern?

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

	init(
		id: UUID = UUID(),
		status: NotifyStatus,
		title: String? = nil,
		subtitle: String? = nil,
		systemImage: String? = nil,
		duration: Duration = .seconds(4),
		haptic: HapticPattern? = nil
	) {
		self.id = id
		self.status = status
		self.title = title
		self.subtitle = subtitle
		self.systemImage = systemImage
		self.duration = duration
		self.haptic = haptic
	}
}

@MainActor
final class NotifyCenter {
	static let shared = NotifyCenter()

	/// How long a message is shown when it does not ask for its own `duration`.
	static let defaultDuration: Duration = .seconds(4)
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

	func dismiss(_ id: UUID? = nil) {
		if let id, message?.id != id {
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

	func dismissAll() {
		dismissTask?.cancel()
		dismissTask = nil
		pending.removeAll()
		message = nil
		broadcast()
	}

	private func present(_ message: NotifyMessage) {
		dismissTask?.cancel()
		HapticFeedback.play(message.haptic ?? message.status.haptic)
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

/// The app-wide feedback entry point. `status` is the original API, kept so no call site needs
/// migrating; `success` / `warning` / `error` are the preferred spelling.
@MainActor
class Notify {
	public static func success(
		_ title: String? = nil, _ subtitle: String? = nil, systemImage: String? = nil,
		withDuration duration: Duration? = nil
	) {
		show(
			NotifyMessage(
				status: .success, title: title, subtitle: subtitle, systemImage: systemImage,
				duration: duration ?? NotifyCenter.defaultDuration))
	}

	public static func warning(
		_ title: String? = nil, _ subtitle: String? = nil, systemImage: String? = nil,
		withDuration duration: Duration? = nil
	) {
		show(
			NotifyMessage(
				status: .warning, title: title, subtitle: subtitle, systemImage: systemImage,
				duration: duration ?? NotifyCenter.defaultDuration))
	}

	public static func error(
		_ title: String? = nil, _ subtitle: String? = nil, systemImage: String? = nil,
		withDuration duration: Duration? = nil
	) {
		show(
			NotifyMessage(
				status: .error, title: title, subtitle: subtitle, systemImage: systemImage,
				duration: duration ?? NotifyCenter.defaultDuration))
	}

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

	/// Dismisses the current banner, revealing the next queued message.
	public static func dismiss() {
		NotifyCenter.shared.dismiss()
	}

	/// Drops the queue instead of revealing the next message.
	public static func dismissAll() {
		NotifyCenter.shared.dismissAll()
	}

	public static func status(
		_ feedbackType: NotifyStatus, _ title: String? = nil, _ subtitle: String? = nil,
		systemImage: String? = nil
	) {
		switch feedbackType {
		case .success:
			success(title, subtitle, systemImage: systemImage)
		case .warning:
			warning(title, subtitle, systemImage: systemImage)
		case .error:
			error(title, subtitle, systemImage: systemImage)
		}
	}
}
