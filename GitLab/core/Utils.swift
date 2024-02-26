//
//  Utils.swift
//  GitLab
//
//  Created by Felix Schindler on 31.10.21.
//

import Foundation
import SwiftUI
import MarkdownUI


struct Messages {
	static let failedToLoad = "Failed to load, please check your internet connection and your token"
}


extension Theme {
	public static let small = Theme.gitHub
		.text {
			FontSize(14)
		}
		.code {
			FontSize(.em(0.8))
		}
}


extension View {
	/// Applies the given transform if the given condition evaluates to `true`.
	/// - Parameters:
	///   - condition: The condition to evaluate.
	///   - transform: The transform to apply to the source `View`.
	/// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
	@ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
		if condition {
			transform(self)
		} else {
			self
		}
	}
}


extension String {
	/// Removes whitespaces and new lines from a string
	func trim() -> String {
		return self.trimmingCharacters(in: .whitespacesAndNewlines)
	}
	
	/// Decodes string from base64
	func fromBase64() -> String? {
		guard let data = Data(base64Encoded: self) else {
			return nil
		}
		
		return String(data: data, encoding: .utf8)
	}
	
	/// Replace :emojis: by actual emojis
	func emojized() -> String {
		return emojizedStringWithString(text: self)
	}
	
	var isNotEmpty: Bool {
		return !self.isEmpty
	}
}

extension StringProtocol {
	/// Calipalize only the first character of a string
	var firstCapitalized: String {
		prefix(1).capitalized + dropFirst()
	}
}


extension Date {
	static func fromToString(_ date: String) -> String {
		let inFormat = DateFormatter()
		inFormat.dateFormat = "yyyy-MM-dd"
		let outFormat = DateFormatter()
		outFormat.dateStyle = .medium
		return outFormat.string(from: inFormat.date(from: date)!)
	}
	
	/// Convert date to string with short time and medium date
	func toString() -> String {
		let dateFormat = DateFormatter()
		dateFormat.dateStyle = .medium
		dateFormat.timeStyle = .short
		return dateFormat.string(from: self)
	}
	
	func toString(_ style: DateFormatter.Style) -> String {
		let dateFormat = DateFormatter()
		dateFormat.dateStyle = style
		dateFormat.timeStyle = style
		return dateFormat.string(from: self)
	}
	
	func toDateString(_ style: DateFormatter.Style = .medium) -> String {
		let dateFormat = DateFormatter()
		dateFormat.dateStyle = style
		return dateFormat.string(from: self)
	}
	
	func toTimeString(_ style: DateFormatter.Style = .short) -> String {
		let dateFormat = DateFormatter()
		dateFormat.timeStyle = style
		return dateFormat.string(from: self)
	}
}


extension URL {
	public static func fromAvatar(_ avatarUrl: String?) -> URL? {
		if var urlStr = avatarUrl {
			if (!urlStr.contains("://")) {
				urlStr = "https://" + API.domain + urlStr
			}
			
			return URL(string: urlStr)
		}
		
		return nil
	}
}


/// Emojized string helper functions
func emojizedStringWithString(text: String) -> String {
	var resultText = text
	do {
		let regex = try NSRegularExpression(pattern: "(:[a-z0-9-+_]+:)", options: .caseInsensitive)
		let matchingRange = NSMakeRange(0, resultText.count)
		regex.enumerateMatches(in: resultText, options: .reportCompletion, range: matchingRange, using: {
			(result: NSTextCheckingResult!, flags: NSRegularExpression.MatchingFlags, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
			if ((result != nil) && (result.resultType == .regularExpression)) {
				let range = result.range
				if (range.location != NSNotFound) {
					let code = (text as NSString).substring(with: range)
					let unicode = emojiAliases(key: code)
					if !unicode.isEmpty {
						resultText = resultText.replacingOccurrences(of: code, with: unicode)
					}
				}
			}
		})
	} catch {
		print("RegExp error")
	}
	
	return resultText
}

func emojiAliases(key: String) -> String {
	var value: String?
	let regex = try! NSRegularExpression(pattern: "(:[a-z0-9-+_]+:)", options: .caseInsensitive)
	
	if (regex.firstMatch(in: key, options: [], range: NSMakeRange(0, key.utf8.count)) != nil) {
		value = EMOJI_HASH[key]
	}
	
	return value ?? key
}
