//
//  Notify.swift
//  Tanuki
//
//  Created by Felix Schindler on 22.04.24.
//

import Toast
import UIKit

enum NotifyStatus: Int {
	case success = 0
	case
		warning = 1
	case
		error = 2
}

@MainActor
class Notify {
	public static func status(
		_ feedbackType: NotifyStatus, _ title: String? = nil, _ subtitle: String? = nil,
		systemImage: String? = nil
	) {
		switch feedbackType {
		case .success:
			Haptics.shared.notify(.success)
			break
		case .warning:
			Haptics.shared.notify(.warning)
			break
		case .error:
			Haptics.shared.notify(.error)
			break
		}

		// Most call sites pass no title, so untitled errors would otherwise be invisible.
		guard let title, !title.isEmpty else {
			guard feedbackType == .error else {
				return
			}

			let fallback = "Something went wrong"
			let image =
				systemImage.flatMap { UIImage(systemName: $0) }
				?? UIImage(systemName: "xmark")

			if let image {
				Notify.show(image: image, title: fallback, subtitle: subtitle)
			} else {
				Notify.show(title: fallback, subtitle: subtitle)
			}
			return
		}

		if let systemImage, let image = UIImage(systemName: systemImage) {
			Notify.show(image: image, title: title, subtitle: subtitle)
		} else {
			Notify.show(title: title, subtitle: subtitle)
		}
	}

	private static func show(image: UIImage, title: String, subtitle: String?) {
		Toast.default(
			image: image,
			title: title,
			subtitle: subtitle
		).show()
	}

	private static func show(title: String, subtitle: String?) {
		Toast.text(title, subtitle: subtitle).show()
	}
}
