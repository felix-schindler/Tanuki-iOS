//
//  InfoView.swift
//  Tanuki
//
//  Created by Felix Schindler on 08.04.24.
//

import SwiftUI
import Highlightr

struct PreferencesView: View {
	let highlighter = Highlightr()
	
    var body: some View {
		List {
			NavigationLink(
				"Syntax highlighting",
				destination: {
					List {
						if let highlighter = highlighter {
							Section("Themes") {
								ForEach(highlighter.availableThemes(), id: \.self) { theme in
									Text(theme)
								}
							}
							Section("Languages") {
								ForEach(highlighter.supportedLanguages(), id: \.self) { lang in
									Text(lang)
								}
							}
						} else {
							Text("Error occured")
						}
					}
				}
			).disabled(highlighter == nil)
		}
    }
}

#Preview {
	NavigationStack {
		PreferencesView()
	}
}
