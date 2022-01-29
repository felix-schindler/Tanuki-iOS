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
}

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
    /**
    Initializes a color from a hex string.

    - Parameter hex: The hex value of the color
    - Returns: Color
    */
    init(hex string: String) {
        var string: String = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if string.hasPrefix("#") {
            _ = string.removeFirst()
        }

        // Double the last value if incomplete hex
        if !string.count.isMultiple(of: 2), let last = string.last {
            string.append(last)
        }

        // Fix invalid values
        if string.count > 8 {
            string = String(string.prefix(8))
        }

        // Scanner creation
        let scanner = Scanner(string: string)

        var color: UInt64 = 0
        scanner.scanHexInt64(&color)

        if string.count == 2 {
            let mask = 0xFF

            let g = Int(color) & mask

            let gray = Double(g) / 255.0

            self.init(.sRGB, red: gray, green: gray, blue: gray, opacity: 1)

        } else if string.count == 4 {
            let mask = 0x00FF

            let g = Int(color >> 8) & mask
            let a = Int(color) & mask

            let gray = Double(g) / 255.0
            let alpha = Double(a) / 255.0

            self.init(.sRGB, red: gray, green: gray, blue: gray, opacity: alpha)

        } else if string.count == 6 {
            let mask = 0x0000FF
            let r = Int(color >> 16) & mask
            let g = Int(color >> 8) & mask
            let b = Int(color) & mask

            let red = Double(r) / 255.0
            let green = Double(g) / 255.0
            let blue = Double(b) / 255.0

            self.init(.sRGB, red: red, green: green, blue: blue, opacity: 1)

        } else if string.count == 8 {
            let mask = 0x000000FF
            let r = Int(color >> 24) & mask
            let g = Int(color >> 16) & mask
            let b = Int(color >> 8) & mask
            let a = Int(color) & mask

            let red = Double(r) / 255.0
            let green = Double(g) / 255.0
            let blue = Double(b) / 255.0
            let alpha = Double(a) / 255.0

            self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)

        } else {
            self.init(.sRGB, red: 1, green: 1, blue: 1, opacity: 1)
        }
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
    var value: String = ""
    let regex = try! NSRegularExpression(pattern: "(:[a-z0-9-+_]+:)", options: .caseInsensitive)

    if (regex.firstMatch(in: key, options: [], range: NSMakeRange(0, key.utf8.count)) != nil) {
        value = EMOJI_HASH[key]!
    }

    return value
}

// } catch let DecodingError.dataCorrupted(context) {
//     print(context)
// } catch let DecodingError.keyNotFound(key, context) {
//     print("Key '\(key)' not found:", context.debugDescription)
//     print("codingPath:", context.codingPath)
// } catch let DecodingError.valueNotFound(value, context) {
//     print("Value '\(value)' not found:", context.debugDescription)
//     print("codingPath:", context.codingPath)
// } catch let DecodingError.typeMismatch(type, context)  {
//     print("Type '\(type)' mismatch:", context.debugDescription)
//     print("codingPath:", context.codingPath)
// } catch {
//     print("error: ", error)
// }
