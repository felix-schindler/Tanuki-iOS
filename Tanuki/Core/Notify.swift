//
//  Notify.swift
//  Tanuki
//
//  Created by Felix Schindler on 22.04.24.
//

import Foundation

enum NotifyStatus: Int {
	case success = 0
	case
		warning = 1
	case
		error = 2
}

class Notify {
	public static func status(
		_ feedbackType: NotifyStatus, _ title: String? = nil, _ subtitle: String? = nil
	) {
		switch feedbackType {
		case .success:
			#if os(iOS)
				Haptics.shared.notify(.success)
			#endif
			break
		case .warning:
			#if os(iOS)
				Haptics.shared.notify(.warning)
			#endif
			break
		case .error:
			#if os(iOS)
				Haptics.shared.notify(.error)
			#endif
			break
		}
	}
}
