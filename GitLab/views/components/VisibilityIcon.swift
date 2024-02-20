//
//  AvatarImage.swift
//  GitLab
//
//  Created by Felix Schindler on 10.06.23.
//

import SwiftUI

struct VisibilityIcon: View {
	let systemName: String

	public init(_ visibility: String) {
		switch (visibility) {
			case "public":
				systemName = "globe"
				break
			case "internal":
				systemName = "shield.lefthalf.filled"
				break
			case "private":
				systemName = "lock"
				break
			default:
				systemName = "questionmark"
				break
		}
	}

	var body: some View {
		Image(systemName: systemName)
	}
}

struct VisibilityIcon_Previews: PreviewProvider {
	static var previews: some View {
		VisibilityIcon("public")
	}
}
