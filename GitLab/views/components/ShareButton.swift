//
//  ShareButton.swift
//  GitLab
//
//  Created by Felix Schindler on 26.02.24.
//

import SwiftUI

struct ShareButton: View {
	private var url: URL
	
	init(_ url: URL) {
		self.url = url
	}
	
	var body: some View {
		ShareLink(item: url) {
			Label("Share", systemImage: "square.and.arrow.up")
		}.labelStyle(.iconOnly)
	}
}

#Preview {
	ShareButton(URL(string: "https://schindlerfelix.de")!)
}
