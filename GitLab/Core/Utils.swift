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
	
	/// Url encode content
	func url() -> String {
		let new = self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
		return new ?? self
	}
}

extension StringProtocol {
	/// Calipalize only the first character of a string
	var firstCapitalized: String { prefix(1).capitalized + dropFirst() }
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
	
	func toDateString() -> String {
		let dateFormat = DateFormatter()
		dateFormat.dateStyle = .medium
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

extension Color {
	init(hex: String) {
		let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
		var int = UInt64()
		Scanner(string: hex).scanHexInt64(&int)
		let r, g, b: UInt64
		switch hex.count {
		case 3: // RGB (12-bit)
			(r, g, b) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
		case 6: // RGB (24-bit)
			(r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
		case 8: // ARGB (32-bit)
			(r, g, b) = (int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
		default:
			(r, g, b) = (0, 0, 0)
		}
		self.init(red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255)
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
