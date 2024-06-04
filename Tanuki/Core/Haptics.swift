//
//  Haptics.swift
//  Tanuki
//
//  Created by Felix Schindler on 29.02.24.
//

#if os(iOS)
	import Foundation
	import UIKit

	class Haptics {
		static let shared = Haptics()

		private init() {
		}

		func play(_ feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle) {
			UIImpactFeedbackGenerator(style: feedbackStyle).impactOccurred()
		}

		func notify(_ feedbackType: UINotificationFeedbackGenerator.FeedbackType) {
			UINotificationFeedbackGenerator().notificationOccurred(feedbackType)
		}
	}
#endif
