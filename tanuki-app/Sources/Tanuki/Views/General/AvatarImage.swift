//
//  AvatarImage.swift
//  GitLab
//
//  Created by Felix Schindler on 10.06.23.
//

import SwiftUI

#if canImport(CachedAsyncImage)
	import CachedAsyncImage
#endif

enum AvatarSize {
	case tiny,
		small,
		medium,
		big
}

struct AvatarImage: View {
	private let url: URL

	private let radius: CGFloat
	private let width: CGFloat
	private let height: CGFloat

	public init(
		_ url: URL, radius: CGFloat = 10, width: CGFloat = 50,
		height: CGFloat = 50
	) {
		self.url = url
		self.radius = radius
		self.width = width
		self.height = height
	}

	public init(_ url: URL, size: AvatarSize) {
		self.url = url

		switch size {
		case .tiny:
			self.radius = 5
			self.width = 17.5
			self.height = 17.5
		case .small:
			self.radius = 5
			self.width = 25
			self.height = 25
		case .medium:
			self.radius = 7.5
			self.width = 37.5
			self.height = 37.5
		case .big:
			self.radius = 10
			self.width = 50
			self.height = 50
		}
	}

	public var body: some View {
		#if canImport(CachedAsyncImage)
			CachedAsyncImage(url: self.url, urlCache: .avatar) { phase in
				switch phase {
				case .empty:
					ProgressView()
				case .success(let image):
					image
						.resizable()
						.scaledToFit()
						.cornerRadius(self.radius)
				case .failure:
					Image(systemName: "exclamationmark.triangle")
						.resizable()
						.scaledToFit()
				@unknown default:
					EmptyView()
				}
			}.frame(width: width, height: height, alignment: .leading)
		#else
			AsyncImage(url: self.url) { phase in
				switch phase {
				case .empty:
					ProgressView()
				case .success(let image):
					image
						.resizable()
						.scaledToFit()
						.cornerRadius(self.radius)
				case .failure:
					Image(systemName: "exclamationmark.triangle")
						.resizable()
						.scaledToFit()
				@unknown default:
					EmptyView()
				}
			}.frame(width: width, height: height, alignment: .leading)
		#endif
	}
}
