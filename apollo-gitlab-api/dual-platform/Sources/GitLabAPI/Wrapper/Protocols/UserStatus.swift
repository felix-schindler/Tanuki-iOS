import Foundation

public struct UserStatus: Codable, Hashable, Sendable {
	public let emoji: String?
	public let message: String?

	public init(emoji: String?, message: String?) {
		self.emoji = emoji
		self.message = message
	}
}
