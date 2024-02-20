//
//  AvatarImage.swift
//  GitLab
//
//  Created by Felix Schindler on 10.06.23.
//

import SwiftUI

enum AvatarSize {
	case small,
			 medium,
			 big
}

struct AvatarImage: View {
	let url: URL?
	
	let radius: CGFloat
	let width: CGFloat
	let height: CGFloat
	
	init(url: URL, radius: CGFloat = 10, width: CGFloat = 50, height: CGFloat = 50) {
		self.url = url
		self.radius = radius
		self.width = width
		self.height = height
	}
	
	init(url: URL, size: AvatarSize) {
		self.url = url
		
		if (size == .small) {
			radius = 5
			width = 25
			height = 25
		} else if (size == .medium) {
			radius = 7.5
			width = 37.5
			height = 37.5
		} else {
			radius = 10
			width = 50
			height = 50
		}
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
				Image(systemName: "photo")
					.resizable()
					.scaledToFit()
			}
		}.frame(width: width, height: height, alignment: .leading)
	}
}

struct AvatarImage_Previews: PreviewProvider {
	static var previews: some View {
		AvatarImage(url: URL(string: "https://schindlerfelix.de/favicon.ico")!)
	}
}
