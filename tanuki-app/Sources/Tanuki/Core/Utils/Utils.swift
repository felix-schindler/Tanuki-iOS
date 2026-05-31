//
//  Utils.swift
//  Tanuki (GitLab)
//
//  Created by Felix Schindler on 31.10.21.
//  Rewritten by Felix Schindler on 26.02.24.
//

import Foundation
import GitLabAPI
import SwiftUI

// MARK: - Cache helpers
extension URLCache {
	static let avatarCache = URLCache(
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
		#if canImport(UIKit)
			UIPasteboard.general.string = self
		#elseif canImport(AppKit)
			NSPasteboard.general.clearContents()
			NSPasteboard.general.setString(self, forType: .string)
		#endif
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

// MARK: - Color helpers
extension SwiftUI.Color {
	// Source - https://stackoverflow.com/a/56874327
	// Posted by kontiki, modified by community. See post 'Timeline' for change history
	// Retrieved 2026-04-14, License - CC BY-SA 4.0
	init(hex: String) {
		let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
		var int: UInt64 = 0
		Scanner(string: hex).scanHexInt64(&int)
		let a: UInt64
		let r: UInt64
		let g: UInt64
		let b: UInt64
		switch hex.count {
		case 3:  // RGB (12-bit)
			(a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
		case 6:  // RGB (24-bit)
			(a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
		case 8:  // ARGB (32-bit)
			(a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
		default:
			(a, r, g, b) = (1, 1, 1, 0)
		}

		self.init(
			.sRGB,
			red: Double(r) / 255,
			green: Double(g) / 255,
			blue: Double(b) / 255,
			opacity: Double(a) / 255
		)
	}

	var hex: String {
		guard let components = cgColor?.components, components.count >= 3 else {
			return "#000000"
		}
		let r = Int(components[0] * 255)
		let g = Int(components[1] * 255)
		let b = Int(components[2] * 255)
		let a = components.count >= 4 ? Int(round(components[3] * 255)) : 255
		return String(format: "#%02X%02X%02X%02X", r, g, b, a)
	}
}
