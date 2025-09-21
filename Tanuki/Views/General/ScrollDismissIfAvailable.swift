//
//  ScrollDismissIfAvailable.swift
//  Tanuki
//
//  Created by Felix Schindler on 21.09.25.
//

import SwiftUI

struct ScrollDismissIfAvailable: ViewModifier {
	func body(content: Content) -> some View {
		if #available(iOS 16.0, *) {
			content.scrollDismissesKeyboard(.interactively)
		} else {
			content
		}
	}
}
