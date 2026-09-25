import SwiftUI

struct FailedView: View {
	private let msg: String
	private let icon: String

	init(_ error: Error) {
		self.icon = "exclamationmark.triangle"
		self.msg = error.localizedDescription
	}

	init(
		_ message: String = "Failed to load. Please make sure you're connected to the internet.",
		icon: String = "exclamationmark.triangle"
	) {
		self.msg = message
		self.icon = icon
	}

	public var body: some View {
		NoContentView(self.msg, systemImage: self.icon)
			.foregroundStyle(.red)
	}
}

struct NoContentView: View {
	private let msg: String
	private let icon: String

	init(_ message: String, systemImage: String) {
		self.msg = message
		self.icon = systemImage
	}

	public var body: some View {
		ContentUnavailableView(msg, systemImage: icon)
	}
}

#Preview {
	NoContentView("There's no content here", systemImage: "checkmark")
}

struct AuthorView: View {
	private let author: MyAuthor

	init(_ author: MyAuthor) {
		self.author = author
	}

	public var body: some View {
		Label(
			title: {
				Text(
					author.name.isEmpty
						? "@\(author.username)"
						: author.name
				)
			},
			icon: {
				if let url = URL.fromAvatar(author.avatarUrl) {
					AvatarImage(url, size: .tiny)
				} else {
					Image(
						systemName: "person"
					)
				}
			}
		)
		.padding(.horizontal, 8)
		.padding(.vertical, 3)
		.background(.secondary)
		.foregroundStyle(.primary)
		.cornerRadius(5)
	}
}

enum AvatarSize {
	case tiny,
		small,
		medium,
		big
}

/// Avatar image with Bearer auth, loaded via URLSession (private instances
/// require authentication, which plain AsyncImage cannot provide).
struct AvatarImage: View {
	let url: URL

	let radius: CGFloat
	let width: CGFloat
	let height: CGFloat

	@State private var image: Image? = nil

	init(
		_ url: URL, radius: CGFloat = 10, width: CGFloat = 50,
		height: CGFloat = 50
	) {
		self.url = url
		self.radius = radius
		self.width = width
		self.height = height
	}

	init(_ url: URL, size: AvatarSize) {
		self.url = url

		switch size {
		case .tiny:
			radius = 5
			width = 17.5
			height = 17.5
		case .small:
			radius = 5
			width = 25
			height = 25
		case .medium:
			radius = 7.5
			width = 37.5
			height = 37.5
		default:
			radius = 10
			width = 50
			height = 50
		}
	}

	public var body: some View {
		Group {
			if let image {
				image
					.resizable()
					.scaledToFit()
					.cornerRadius(radius)
			} else {
				ProgressView()
					.task {
						await load()
					}
			}
		}.frame(width: width, height: height, alignment: .leading)
	}

	private func load() async {
		var req = URLRequest(url: url)
		req.setValue("Bearer \(API.token)", forHTTPHeaderField: "Authorization")
		guard let (data, _) = try? await URLSession.shared.data(for: req),
			let uiImage = UIImage(data: data)
		else {
			return
		}
		image = Image(uiImage: uiImage)
	}
}
