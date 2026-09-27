//
//  Utils.swift
//  Tanuki (GitLab)
//
//  Created by Felix Schindler on 31.10.21.
//  Rewritten by Felix Schindler on 26.02.24.
//

import Foundation
import GitLabAPI
import NVMColor
import SwiftUI
import TanukiEmoji

// MARK: - Cache helpers
extension URLCache {
	static let avatar = URLCache(
		memoryCapacity: 100 * 1024 * 1024,  // 100 MB in RAM
		diskCapacity: 300 * 1024 * 1024  // 300 MB on disk
	)
}

// MARK: - Array helpers
extension Array {
	var isNotEmpty: Bool {
		return !self.isEmpty
	}
}

// MARK: - Set helpers
extension Set {
	var isNotEmpty: Bool {
		return !self.isEmpty
	}
}

// MARK: - String helpers
extension String {
	var isNotEmpty: Bool {
		return !self.isEmpty
	}

	func emojized() -> String {
		return EmojiHelper.emojizedStringWithString(text: self)
	}

	func toIntId() -> Int? {
		return Int(self.split(separator: "/").last ?? "")
	}

	func toStringId() -> String? {
		if let last = self.split(separator: "/").last {
			return String(last)
		}

		return nil
	}

	/// Writes the string to clipboard
	func copyToClipboard() {
		UIPasteboard.general.string = self
	}

	func replacing(_ target: String, with replacement: String) -> String {
		var result = self

		while let range = result.range(of: target) {
			result.replaceSubrange(range, with: replacement)
		}

		return result
	}
}

// MARK: - URL helpers
extension URL {
	@MainActor
	public static func fromAvatar(_ avatarUrl: String?) -> URL? {
		if var urlStr = avatarUrl {
			if !urlStr.contains("://") {
				urlStr = "https://" + API.host + urlStr
			}

			return URL(string: urlStr)
		}

		return nil
	}
}

// MARK: - Date helpers
extension SwiftUI.Date {
	static func fromToString(
		_ date: String, dateStyle: DateFormatter.Style = .medium,
		timeStyle: DateFormatter.Style = .none
	) -> String {
		let inFormat = ISO8601DateFormatter()
		if let dateObj = inFormat.date(from: date) {
			return dateObj.toString(dateStyle, timeStyle: timeStyle)
		} else {
			return date
		}
	}

	func toString(
		_ dateStyle: DateFormatter.Style = .medium,
		timeStyle: DateFormatter.Style = .none
	) -> String {
		let dateFormat = DateFormatter()
		dateFormat.dateStyle = dateStyle
		dateFormat.timeStyle = timeStyle
		return dateFormat.string(from: self)
	}
}
