//
//  Notify.swift
//  Tanuki
//
//  Created by Felix Schindler on 22.04.24.
//

//import Toast
import SkipKit

enum NotifyStatus: Int {
	case success = 0
	case
		warning = 1
	case
		error = 2
}

struct Toast {
	private init() {
	}

	static func text(_ title: String?, subtitle: String?) -> Toast {
		Toast()
	}

	func show() {
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

		// The transient toast UI below is disabled (its dependency is commented out in
		// Package.swift), so without this every action that fails is completely silent.
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

		/*if let title {
			var toast: Toast

			if let systemImage, let image = UIImage(systemName: systemImage) {
				toast = Toast.default(
					image: image,
					title: title,
					subtitle: subtitle
				)
			} else {
				toast = Toast.text(title, subtitle: subtitle)
			}
			toast.show()
		}*/
	}
}
