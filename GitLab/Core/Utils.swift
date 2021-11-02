//
//  Utils.swift
//  GitLab
//
//  Created by Felix Schindler on 31.10.21.
//

import Foundation

// TODO documentation
extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }
    
    func emojized() -> String {
        return emojizedStringWithString(text: self)
    }
}

extension StringProtocol {
    var firstCapitalized: String { prefix(1).capitalized + dropFirst() }
}


// Emojized string helper functions
func emojizedStringWithString(text: String) -> String {
    let regex = try! NSRegularExpression(pattern: "(:[a-z0-9-+_]+:)", options: .caseInsensitive)
    var resultText = text
    let matchingRange = NSMakeRange(0, resultText.lengthOfBytes(using: .utf8))
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
