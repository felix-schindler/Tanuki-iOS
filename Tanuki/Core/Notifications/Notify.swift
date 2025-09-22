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

		if let title {
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
		}
	}
}
