#if os(watchOS)
	import Foundation

	// MARK: - URL helpers
	extension URL {
		@MainActor
		public static func fromAvatar(_ avatarUrl: String?) -> URL? {
			if var urlStr = avatarUrl {
				if !urlStr.contains("://") {
					urlStr = "https://" + API.host + urlStr
				}

				return URL(string: urlStr)
			}

			return nil
		}
	}

	// MARK: - Date helpers
	extension Date {
		static func fromToString(
			_ date: String, dateStyle: DateFormatter.Style = .medium,
			timeStyle: DateFormatter.Style = .none
		) -> String {
			let inFormat = ISO8601DateFormatter()
			if let dateObj = inFormat.date(from: date) {
				return dateObj.toString(dateStyle, timeStyle: timeStyle)
			} else {
				return date
			}
		}

		func toString(
			_ dateStyle: DateFormatter.Style = .medium,
			timeStyle: DateFormatter.Style = .none
		) -> String {
			let dateFormat = DateFormatter()
			dateFormat.dateStyle = dateStyle
			dateFormat.timeStyle = timeStyle
			return dateFormat.string(from: self)
		}
	}
#endif
