//
//  Utils.swift
//  GitLab
//
//  Created by Felix Schindler on 31.10.21.
//

import Foundation

extension String
{
    func trim() -> String
    {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
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
