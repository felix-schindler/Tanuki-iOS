//
//  Commits.swift
//  GitLab
//
//  Created by Felix Schindler on 02.11.21.
//

import SwiftUI
import MarkdownUI

struct CommitsView: View {
	@Environment(\.presentationMode)
	var presentationMode: Binding<PresentationMode>
	
	@State var id: Int
	@State var refName: String
	
	@State var branches: [Branch]? = nil
	@State var commits: [Commit]? = nil
	@State var loadFailed: Bool = false
	
	var body: some View {
		List {
			if (commits != nil) {
				if (commits!.isEmpty) {
					Text("You'll see your commits after you pushed something to branch \(refName)")
				} else {
					HStack {
						Text("On branch")
						if (branches != nil) {
							Picker("", selection: $refName) {
								ForEach(branches!, id: \.name) { branch in
									Text(branch.name).tag(branch.name)
								}
							}.pickerStyle(.menu)
								.onChange(of: refName) { _ in
									Task { await getCommits() }
								}
						} else {
							Picker("", selection: $refName) {
								Text(refName).tag(refName)
							}.pickerStyle(.menu)
						}
					}
					Section("Commits") {
						ForEach(commits!, id: \.id) { commit in
							HStack {
								VStack(alignment: .leading) {
									Text(commit.title.emojized())
										.fontWeight(.medium)

									HStack {
										Text(commit.authorName)
										Text(commit.authoredDate.toString())
									}.font(.footnote)
								}
								Spacer()
								Text(commit.shortId)
									.font(.system(.caption, design: .monospaced))
							}
						}
					}
				}
			} else {
				if (loadFailed) {
					Text("Failed to load, please check your internet connection and your token")
						.foregroundColor(.red)
				} else {
					ProgressView()
				}
			}
		}.onAppear {
			Task {
				await getCommits()
				await getBranches()
				loadFailed = (commits == nil) || (branches == nil)
			}
		}.refreshable {
			await getCommits()
			await getBranches()
			loadFailed = (commits == nil) || (branches == nil)
		}.navigationBarTitle("Commits")
			.headerProminence(.increased)
	}
	
	private func getCommits() async -> Void {
		commits = await API.get(type: [Commit].self, endpoint: "projects/\(id)/repository/commits", query: ["ref_name": refName])
	}
	
	private func getBranches() async -> Void {
		branches = await API.get(type: [Branch].self, endpoint: "projects/\(id)/repository/branches")
	}
}

struct CommitsView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationView {
			CommitsView(id: 33025310, refName: "main", branches: [
				Branch(name: "main", commit: Commit(id: "00761f920931144587a5b213976e41243e6ae746", shortId: "shortId", title: "Update CommitsView.swift", message: "Update CommitsView.swift", authorName: "Felix", authorEmail: "felix-schindler@outlook.com", authoredDate: Date()), merged: false, protected: false, developersCanPush: true, developersCanMerge: true, canPush: true)
			], commits: [
				Commit(id: "00761f920931144587a5b213976e41243e6ae746", shortId: "shortId", title: "Update CommitsView.swift", message: "Update CommitsView.swift", authorName: "Felix", authorEmail: "felix-schindler@outlook.com", authoredDate: Date())
			])
		}
	}
}
