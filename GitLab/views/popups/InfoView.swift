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
	 
	 This app is still in early development.
	 When you encounter any bugs or have feature requests,
	 please create an issue in our
	 [GitLab repository](https://gitlab.com/felix-schindler/gitlab-ios/-/issues)
	 or
	 [send an email](mailto:contact-project+felix-schindler-gitlab-ios-33025310-issue-@incoming.gitlab.com).
	 """
			}.font(.body)
				.padding()
			Spacer()
		}.onDisappear() {
			Store.showInfo = false
		}
	}
}

struct InfoView_Previews: PreviewProvider {
	static var previews: some View {
		InfoView()
	}
}
