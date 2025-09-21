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
	private var diffs: Result<[MergeRequestDiffsQuery.Data.Project.MergeRequest.DiffStat], Error>? =
		nil

	@State
	private var isLoading = false

	init(fullPath: String, iid: String) {
		self.fullPath = fullPath
		self.iid = iid
	}

	private func loadDiffs() {
		isLoading = true

		defer {
			isLoading = false
		}

		do {
			let responses = try Network.shared.apollo.fetch(
				query: MergeRequestDiffsQuery(fullPath: self.fullPath, iid: self.iid),
				cachePolicy: .cacheAndNetwork
			)

			Task {
				for try await response in responses {
					if let diffs = response.data?.project?.mergeRequest?.diffStats {
						self.diffs = .success(diffs)
					} else if let errors = response.errors {
						for error in errors {
							Notify.status(.error, error.localizedDescription)
						}
					}
				}
			}
		} catch let error {
			self.diffs = .failure(error)
			Notify.status(.error)
		}
	}

	private func reloadDiffs() async {
		do {
			let response = try await Network.shared.apollo.fetch(
				query: MergeRequestDiffsQuery(fullPath: self.fullPath, iid: self.iid),
				cachePolicy: .networkOnly
			)

			if let diffs = response.data?.project?.mergeRequest?.diffStats {
				self.diffs = .success(diffs)
			}

			Notify.status(.success)
		} catch let error {
			self.diffs = .failure(error)
			Notify.status(.error)
		}
	}

	public var body: some View {
		List {
			if isLoading {
				ProgressView("Loading file diffs")
			} else if let diffs {
				switch diffs {
				case .success(let diffs):
					if diffs.isEmpty {
						ContentUnavailableView(
							"There are no files with changed content", systemImage: "plusminus")
					} else {
						ForEach(diffs, id: \.path) { diff in
							VStack(alignment: .leading) {
								Text(diff.path)
								ScrollView(.horizontal) {
									HStack {
										PillView(
											"+\(diff.additions)", bgColor: .green, fgColor: .white)
										PillView(
											"-\(diff.deletions)", bgColor: .red, fgColor: .white)
									}.monospaced()
								}
							}
						}
					}
				case .failure(let error):
					FailedView(error)
				}
			}
		}.onAppear {
			loadDiffs()
		}.refreshable {
			await reloadDiffs()
		}.navigationTitle("Diffs")
	}
}

#Preview {
	NavigationStack {
		DiffsStatsLoader(fullPath: "felix-schindler/gitlab-ios", iid: "1")
	}
}
