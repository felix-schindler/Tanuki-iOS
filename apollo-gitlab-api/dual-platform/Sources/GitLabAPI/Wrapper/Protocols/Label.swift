import Foundation

public protocol MyLabel: Sendable {
	var id: String { get }
	var title: String { get }
	var description: String? { get }
	var color: String { get }
	var textColor: String { get }
}
