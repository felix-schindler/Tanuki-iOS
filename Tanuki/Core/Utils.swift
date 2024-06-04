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

let failedToLoad =
	"Failed to load\nPlease check token and internet connection, then try again"

// MARK: - Emoji helpers
class EmojiHelper {
	public static func emojizedStringWithString(text: String) -> String {
		var resultText = text
		do {
			let regex = try NSRegularExpression(
				pattern: "(:[a-z0-9-+_]+:)", options: .caseInsensitive)
			let matchingRange = NSMakeRange(0, resultText.count)
			regex.enumerateMatches(
				in: resultText, options: .reportCompletion,
				range: matchingRange,
				using: {
					(
						result: NSTextCheckingResult!,
						flags: NSRegularExpression.MatchingFlags,
						stop: UnsafeMutablePointer<ObjCBool>
					) -> Void in
					if (result != nil)
						&& (result.resultType == .regularExpression)
					{
						let range = result.range
						if range.location != NSNotFound {
							let code = (text as NSString).substring(with: range)
							let unicode = EmojiHelper.emojiAliases(key: code)
							if !unicode.isEmpty {
								resultText = resultText.replacingOccurrences(
									of: code, with: unicode)
							}
						}
					}
				})
		} catch {
			print("RegExp error")
		}

		return resultText
	}

	public static func emojiAliases(key: String) -> String {
		var value: String?
		let regex = try! NSRegularExpression(
			pattern: "(:[a-z0-9-+_]+:)", options: .caseInsensitive)

		if regex.firstMatch(
			in: key, options: [], range: NSMakeRange(0, key.utf8.count)) != nil
		{
			value = emojiCodes[key]
		}

		return value ?? key
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
		#if os(iOS)
			UIPasteboard.general.string = self
		#else
			let pasteboard = NSPasteboard.general
			pasteboard.clearContents()
			pasteboard.writeObjects([self as NSString])
		#endif
	}
}

extension StringProtocol {
	/// Calipalize only the first character of a string
	var firstCapitalized: String {
		prefix(1).capitalized + dropFirst()
	}
}

// MARK: - URL helpers
extension URL {
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
