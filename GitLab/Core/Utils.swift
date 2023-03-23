//
//  Utils.swift
//  GitLab
//
//  Created by Felix Schindler on 31.10.21.
//

import Foundation
import SwiftUI


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
}

extension StringProtocol {
	/// Calipalize only the first character of a string
	var firstCapitalized: String {
		prefix(1).capitalized + dropFirst()
	}
}


extension Date {
	static func formToString(_ date: String) -> String {
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
	
	func toDateString(_ style: DateFormatter.Style = .medium) -> String {
		let dateFormat = DateFormatter()
		dateFormat.dateStyle = style
		return dateFormat.string(from: self)
	}
	
	func toTimeString() -> String {
		let dateFormat = DateFormatter()
		dateFormat.timeStyle = .short
		return dateFormat.string(from: self)
	}
	
	func toShortString() -> String {
		let dateFormat = DateFormatter()
		dateFormat.dateStyle = .short
		dateFormat.timeStyle = .short
		return dateFormat.string(from: self)
	}
}


extension URL {
	func share() {
		let activityVC = UIActivityViewController(activityItems: [self], applicationActivities: nil)
		
		let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
		windowScene?.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
	}
}


@Sendable
func iso8601Decoder() -> (Decoder) throws -> Date {
	{ (decoder) -> Date in
		let formatter = DateFormatter()
		formatter.calendar = Calendar(identifier: .iso8601)
		formatter.locale = Locale(identifier: "en_US_POSIX")
		formatter.timeZone = TimeZone(secondsFromGMT: 0)
		
		let container = try decoder.singleValueContainer()
		let dateStr = try container.decode(String.self)
		
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
		if let date = formatter.date(from: dateStr) {
			return date
		}
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
		if let date = formatter.date(from: dateStr) {
			return date
		}
		throw DateError.invalidDate
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
