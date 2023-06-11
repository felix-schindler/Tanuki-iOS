//
//  AvatarImage.swift
//  GitLab
//
//  Created by Felix Schindler on 10.06.23.
//

import SwiftUI

struct AvatarImage: View {
	let url: URL?

	let radius: CGFloat
	let width: CGFloat
	let height: CGFloat
	
	init(url: URL?, radius: CGFloat = 10, width: CGFloat = 50, height: CGFloat = 50) {
		self.url = url
		self.radius = radius
		self.width = width
		self.height = height
	}
	
	var body: some View {
		AsyncImage(url: url) { phase in
			switch phase {
			case .empty:
				ProgressView()
			case .success(let image):
				image
					.resizable()
					.scaledToFit()
					.cornerRadius(radius)
			default:
				EmptyView()
			}
		}.frame(width: width, height: height, alignment: .leading)
	}
}

struct AvatarImage_Previews: PreviewProvider {
	static var previews: some View {
		AvatarImage(url: URL(string: "https://schindlerfelix.de/favicon.ico")!)
	}
}
