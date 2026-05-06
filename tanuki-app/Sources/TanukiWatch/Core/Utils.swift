//
//  Utils.swift
//  Tanuki
//
//  Created by Felix Schindler on 20.09.25.
//

import Foundation

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

// MARK: - String helpers
extension String {
	var isNotEmpty: Bool {
		return !self.isEmpty
	}

	func emojized() -> String {
		return EmojiHelper.emojizedStringWithString(text: self)
	}
}

extension StringProtocol {
	/// Calipalize only the first character of a string
	var firstCapitalized: String {
		prefix(1).capitalized + dropFirst()
	}
}

// MARK: - Date helpers
extension Date {
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
