//
//  SmallCommitView.swift
//  Tanuki
//
//  Created by Felix Schindler on 29.03.24.
//

import MarkdownUI
import SwiftUI

struct SmallCommitView: View {
	private let projectId: Int?
	private let commit: NewCommit

	@State var showVerified = false

	init(_ commit: NewCommit, _ projectId: Int? = nil) {
		self.commit = commit
		self.projectId = projectId
	}

	public var body: some View {
		if let id = self.projectId,
			let sha = commit.id.toStringId()
		{
			NavigationLink(
				destination: DiffLoader(projectId: id, commitSha: sha),
				label: {
					main
				}
			)
		} else {
			main
		}
	}

	private var main: some View {
		HStack {
			VStack(alignment: .leading) {
				if let title = commit.title {
					Markdown(title.emojized())
						.markdownTheme(.gitLab)
				}

				if commit.authorName != nil
					&& commit.authoredDate != nil
				{
					Text(
						"\(commit.authorName!) authored at \(Date.fromToString(commit.authoredDate!))"
					)
					.font(.footnote)
				}
			}

			Spacer()

			VStack {
				HStack {
					if let status = commit._lastPipelineStatus {
						PipelineStatus(status)
					}

					if commit._signatureVerificationStatus?.starts(with: "VERIFIED") ?? false {
						RoundIconButton(
							"Verified", icon: "checkmark.seal"
						) {
							Haptics.shared.play(.light)
							showVerified = true
						}
						.tint(.green)
						.controlSize(.mini)
					}
				}

				Text(commit.shortId)
					.font(.system(.footnote, design: .monospaced))
			}
		}.sheet(isPresented: $showVerified) {
			VStack(alignment: .leading) {
				PopupHeader(
					title: "Verified commit",
					onClose: {
						showVerified = false
					})
				Text(
					"This commit was signed with a verified signature and the committer email was verified to belong to the same user."
				)
				Spacer()
			}
			.padding()
			.modifier(PresentationDetendsIfAvailable())
		}.swipeActions {
			if let url = URL(string: commit.webUrl) {
				ShareButton(url)
			}
		}
	}
}
