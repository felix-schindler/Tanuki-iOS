//
//  Utils.swift
//  Tanuki
//
//  Created by Felix Schindler on 26.02.24.
//

import Foundation
import SwiftUI
import NVMColor

let LOAD_FAILED = "Failed to load\nPlease check token and internet connection, then try again"

extension String {
	var isNotEmpty: Bool {
		return !self.isEmpty
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

extension Date {
	static func fromToString(_ date: String, dateStyle: DateFormatter.Style = .medium) -> String {
		let inFormat = ISO8601DateFormatter()
		let outFormat = DateFormatter()
		outFormat.dateStyle = dateStyle
		return outFormat.string(from: inFormat.date(from: date)!)
	}
}
