//
//  InfoView.swift
//  GitLab
//
//  Created by Felix Schindler on 14.03.23.
//

import SwiftUI
import MarkdownUI

struct InfoView: View {
	var body: some View {
		VStack {
			Spacer()
			Markdown {
			"""
			## Tanuki for GitLab
			
			This app is still in early development so bugs
			are expected. If you encounter any, you can
			report them in our
			[GitLab Repository](https://gitlab.com/felix-schindler/gitlab-ios/-/issues).
			"""
			}	.font(.body)
				.padding()
			Spacer()
		}
	}
}

struct InfoView_Previews: PreviewProvider {
	static var previews: some View {
		InfoView()
	}
}
