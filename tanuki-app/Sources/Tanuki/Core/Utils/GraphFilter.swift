import Foundation
import GitLabAPI

class GraphFilter {
	public static func toFilter<T>(_ something: T?) -> T? {
		something
	}

	public static func toFilterDate(_ something: Foundation.Date?) -> String? {
		if let something {
			ISO8601DateFormatter().string(from: something)
		} else {
			nil
		}
	}

	public static func toFilterEnum<T>(_ something: T?) -> T? {
		something
	}
}
