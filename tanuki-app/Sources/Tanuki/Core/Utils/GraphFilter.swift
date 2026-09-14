//
//  GraphFilter.swift
//  Tanuki
//
//  Created by Felix Schindler on 12.10.25.
//

import Foundation
import GitLabAPI

class GraphFilter {
	/// Wrap a value with GraphQLNullable
	public static func toFilter<T>(_ something: T?) -> GraphQLNullable<T> {
		if let something {
			.some(something)
		} else {
			.none
		}
	}

	/// Convert date to correct string format (ISO 8601) and wrap it in GraphQLNullable
	public static func toFilterDate(_ something: Foundation.Date?) -> GraphQLNullable<String> {
		if let something {
			.some(ISO8601DateFormatter().string(from: something))
		} else {
			.none
		}
	}

	/// Convert enum value to case and warp it in GraphQLNullable
	public static func toFilterEnum<T>(_ something: T?) -> GraphQLNullable<GraphQLEnum<T>> {
		if let something {
			.some(.case(something))
		} else {
			.none
		}
	}
}
