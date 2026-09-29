//
//  PersistedCookies.swift
//  Tanuki
//
//  Created by Felix Schindler on 29.09.26.
//

import Foundation

enum PersistedCookies {
	private static let key = "persistedCookies"

	static func load() -> [[HTTPCookiePropertyKey: Any]] {
		guard let data = UserDefaults.standard.data(forKey: key),
			let dicts = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil)
				as? [[HTTPCookiePropertyKey: Any]]
		else {
			return []
		}
		return dicts
	}

	static func loadCookies() -> [HTTPCookie] {
		load().compactMap { HTTPCookie(properties: $0) }
	}

	static func save(_ cookies: [HTTPCookie]) {
		let propertyDicts: [[HTTPCookiePropertyKey: Any]] = cookies.compactMap { $0.properties }
		guard !propertyDicts.isEmpty else { return }
		if let data = try? PropertyListSerialization.data(
			fromPropertyList: propertyDicts, format: .binary, options: 0)
		{
			UserDefaults.standard.set(data, forKey: key)
		}
	}

	static func clear() {
		UserDefaults.standard.removeObject(forKey: key)
	}
}
