//
//  ScrollDismissIfAvailable.swift
//  Tanuki
//
//  Created by Felix Schindler on 21.09.25.
//

import SwiftUI

struct LabelSpacingIfAvailable: ViewModifier {
	func body(content: Content) -> some View {
		if #available(iOS 26.0, *) {
			content.labelIconToTitleSpacing(5)
		} else {
			content
		}
	}
}
