//
//  VisibilityIcon.swift
//  Tanuki
//
//  Created by Felix Schindler on 27.02.24.
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

#Preview {
	VisibilityIcon("public")
}
