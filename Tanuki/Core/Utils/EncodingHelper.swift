//
//  EncodingHelper.swift
//  Tanuki
//
//  Created by Felix Schindler on 24.09.25.
//

enum StringOrArray: Codable {
	case string(String)
	case array([String])
	case int(Int)
	case intArray([Int])

	// MARK: Codable conformance
	init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		if let str = try? container.decode(String.self) {
			self = .string(str)
		} else if let arr = try? container.decode([String].self) {
			self = .array(arr)
		} else if let int = try? container.decode(Int.self) {
			self = .int(int)
		} else if let intArr = try? container.decode([Int].self) {
			self = .intArray(intArr)
		} else {
			throw DecodingError.typeMismatch(
				StringOrArray.self,
				DecodingError.Context(
					codingPath: decoder.codingPath,
					debugDescription: "Expected String or [String]")
			)
		}
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		switch self {
		case .string(let str):
			try container.encode(str)
		case .array(let arr):
			try container.encode(arr)
		case .int(let int):
			try container.encode(int)
		case .intArray(let intArr):
			try container.encode(intArr)
		}
	}
}
