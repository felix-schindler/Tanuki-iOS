//
//  Utils.swift
//  Tanuki
//
//  Created by Felix Schindler on 26.02.24.
//

import Foundation
import GitLabAPI
import NVMColor
import SwiftUI

let LOAD_FAILED =
	"Failed to load\nPlease check token and internet connection, then try again"

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
			value = EMOJI_HASH[key]
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
}

extension StringProtocol {
	/// Calipalize only the first character of a string
	var firstCapitalized: String {
		prefix(1).capitalized + dropFirst()
	}
}

extension URL {
	public static func fromAvatar(_ avatarUrl: String?) -> URL? {
		if var urlStr = avatarUrl {
			if !urlStr.contains("://") {
				urlStr = "https://" + API.domain + urlStr
			}

			return URL(string: urlStr)
		}

		return nil
	}
}

extension Date {
	static func fromToString(
		_ date: String, dateStyle: DateFormatter.Style = .medium,
		timeStyle: DateFormatter.Style = .none
	) -> String {
		let inFormat = ISO8601DateFormatter()
		let outFormat = DateFormatter()
		outFormat.dateStyle = dateStyle
		outFormat.timeStyle = timeStyle
		return outFormat.string(from: inFormat.date(from: date)!)
	}
}
