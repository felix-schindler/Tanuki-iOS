//
//  GroupLoader.swift
//  Tanuki
//
//  Created by Felix Schindler on 29.02.24.
//

import SwiftUI

struct GroupLoader: View {
	private let fullPath: String
	
	init(fullPath: String) {
		self.fullPath = fullPath
	}
	
    var body: some View {
		Label(self.fullPath, systemImage: "person.3")
    }
}

#Preview {
	NavigationStack {
		GroupLoader(fullPath: "gitlab-org")
	}
}
