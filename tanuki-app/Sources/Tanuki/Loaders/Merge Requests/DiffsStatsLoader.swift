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

	@State var diffs: Result<MergeRequestDiffsPayload, Error>? = nil

	init(fullPath: String, iid: String) {
		self.fullPath = fullPath
		self.iid = iid
	}

	private func loadDiffs() {
		Task {
			do {
				let diffs = try await Network.shared.service.fetchMergeRequestDiffs(fullPath: self.fullPath, iid: self.iid)
				self.diffs = .success(diffs)
			} catch let error {
				self.diffs = .failure(error)
				Notify.status(.error)
			}
		}
	}

	private func reloadDiffs() async {
		do {
			let diffs = try await Network.shared.service.fetchMergeRequestDiffs(fullPath: self.fullPath, iid: self.iid)
			self.diffs = .success(diffs)
			Notify.status(.success)
		} catch let error {
			self.diffs = .failure(error)
			Notify.status(.error)
		}
	}

	public var body: some View {
		List {
			if let diffs {
				switch diffs {
				case .success(let diffs):
					if diffs.mergeRequest?.diffStats?.isEmpty ?? true {
						NoContentView("There are no files with changed content", systemImage: "plusminus")
					} else if let stats = diffs.mergeRequest?.diffStats {
						ForEach(stats, id: \.path) { diff in
							VStack(alignment: .leading) {
								Text(diff.path)
								ScrollView(.horizontal) {
									HStack {
										PillView("+\(diff.additions)", bgColor: .green, fgColor: .white)
										PillView("-\(diff.deletions)", bgColor: .red, fgColor: .white)
									}.font(.system(.body, design: .monospaced))
								}
							}
						}
					}
				case .failure(let error):
					FailedView(error)
				}
			} else {
				LoadingView("Loading file diffs", systemImage: "plusminus")
			}
		}.onAppear {
			loadDiffs()
		}.refreshable {
			await reloadDiffs()
		}.navigationTitle("Diffs")
	}
}

#Preview {
	NavigationView {
		DiffsStatsLoader(fullPath: "felix-schindler/gitlab-ios", iid: "1")
	}
}
