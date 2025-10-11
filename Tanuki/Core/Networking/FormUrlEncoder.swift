//
//  FormUrlEncoder.swift
//  Tanuki
//
//  Created by Felix Schindler on 03.10.25.
//

import Foundation

struct FormURLEncoder {
	public static func encode<T: Encodable>(_ value: T) throws -> Data {
		// Encode to JSON first
		let jsonData = try JSONEncoder().encode(value)
		let jsonObject = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any]

		guard let dict = jsonObject else {
			throw EncodingError.invalidValue(
				value,
				.init(
					codingPath: [],
					debugDescription: "Top-level Encodable is not a dictionary"))
		}

		let query = dict.map { key, value in
			let escapedKey =
				key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? key
			let escapedVal =
				"\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
				?? "\(value)"
			return "\(escapedKey)=\(escapedVal)"
		}.joined(separator: "&")

		return Data(query.utf8)
	}
}
