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
}

struct NotifyMessage: Equatable {
	let id: UUID
	let status: NotifyStatus
	let title: String
	let subtitle: String?
	let systemImage: String?
}

@MainActor
final class NotifyCenter {
	static let shared = NotifyCenter()

	private static let duration: Duration = .seconds(4)

	private(set) var message: NotifyMessage?

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
		self.message = message
		broadcast()

		dismissTask?.cancel()
		dismissTask = Task { [weak self] in
			try? await Task.sleep(for: NotifyCenter.duration)
			guard !Task.isCancelled else {
				return
			}
			self?.dismiss(message.id)
		}
	}

	func dismiss(_ id: UUID? = nil) {
		if let id, message?.id != id {
			return
		}
		dismissTask?.cancel()
		dismissTask = nil
		message = nil
		broadcast()
	}

	private func broadcast() {
		for observer in observers.values {
			observer(message)
		}
	}
}

@MainActor
class Notify {
	public static func status(
		_ feedbackType: NotifyStatus, _ title: String? = nil, _ subtitle: String? = nil,
		systemImage: String? = nil
	) {
		switch feedbackType {
		case .success:
			HapticFeedback.play(.success)
			break
		case .warning:
			HapticFeedback.play(.warning)
			break
		case .error:
			HapticFeedback.play(.error)
			break
		}

		// Mirror it into the platform log: `adb logcat -s de.schindlerfelix.GitLab.Tanuki`.
		let message = [title, subtitle].compactMap { $0 }.filter { !$0.isEmpty }.joined(separator: " — ")
		if !message.isEmpty {
			switch feedbackType {
			case .success:
				logger.info("ok: \(message)")
			case .warning:
				logger.warning("warn: \(message)")
			case .error:
				logger.error("error: \(message)")
			}
		}

		let resolvedTitle: String?
		if let title, !title.isEmpty {
			resolvedTitle = title
		} else if feedbackType == .error {
			resolvedTitle = "Something went wrong"
		} else {
			resolvedTitle = nil
		}

		if let resolvedTitle {
			NotifyCenter.shared.show(
				NotifyMessage(
					id: UUID(),
					status: feedbackType,
					title: resolvedTitle,
					subtitle: subtitle.flatMap { $0.isEmpty ? nil : $0 },
					systemImage: systemImage
				))
		}
	}
}
