//
//  DiffsLoader.swift
//  Tanuki
//
//  Created by Felix Schindler on 29.03.24.
//

import GitLabAPI
import SwiftUI

struct DiffsStatsLoader: View {
	private let fullPath: String
	private let iid: String

	@State
	private var diffs: [MergeRequestDiffsQuery.Data.Project.MergeRequest.DiffStat]? = nil

	@State
	private var loadFailed = false

	init(fullPath: String, iid: String) {
		self.fullPath = fullPath
		self.iid = iid
	}

	private func loadDiffs() {
		Network.shared.apollo.fetch(
			query: MergeRequestDiffsQuery(fullPath: self.fullPath, iid: self.iid)
		) { result in
			switch result {
			case .success(let graphQLResult):
				print("Success! Setting diffs...")
				diffs = graphQLResult.data?.project?.mergeRequest?.diffStats
			case .failure(let error):
				print("Failure! Error: \(error)")
				loadFailed = true
			}
		}
	}

	public var body: some View {
		List {
			if let diffs = self.diffs {
				if diffs.isEmpty {
					Text("There are no files with changed content")
				} else {
					ForEach(diffs, id: \.path) { diff in
						VStack(alignment: .leading) {
							Text(diff.path)
							ScrollView(.horizontal) {
								HStack {
									PillView("+\(diff.additions)", bgColor: .green, fgColor: .white)
									PillView("-\(diff.deletions)", bgColor: .red, fgColor: .white)
								}.monospaced()
							}
						}
					}
				}
			} else {
				VStack {
					if loadFailed {
						Text(failedToLoad)
					} else {
						ProgressView("Loading file diffs")
					}
				}.frame(maxWidth: .infinity, minHeight: 100)
			}
		}.onAppear {
			loadDiffs()
		}.refreshable {
			loadDiffs()
		}.navigationTitle("Diffs")
	}
}

#Preview {
	NavigationStack {
		DiffsStatsLoader(fullPath: "felix-schindler/gitlab-ios", iid: "1")
	}
}
