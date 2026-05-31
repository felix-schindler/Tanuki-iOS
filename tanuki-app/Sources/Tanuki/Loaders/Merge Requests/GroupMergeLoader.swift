//
//  GroupMergeLoader.swift
//  Tanuki
//
//  Created by Felix Schindler on 05.03.24.
//

import GitLabAPI
import SwiftUI

struct GroupMergeLoader: View {
	private let fullPath: String

	@State var mergeRequests: Result<[SmallMergeRequest], Error>? = nil

	init(fullPath: String) {
		self.fullPath = fullPath
	}

	private func loadMergeRequests() {
		Task {
			do {
				let mrs = try await Network.shared.service.fetchGroupMergeRequests(fullPath: self.fullPath)
				self.mergeRequests = .success(mrs)
			} catch let error {
				self.mergeRequests = .failure(error)
				Notify.status(.error)
			}
		}
	}

	private func reloadMergeRequests() async {
		do {
			let mrs = try await Network.shared.service.fetchGroupMergeRequests(fullPath: self.fullPath)
			self.mergeRequests = .success(mrs)
			Notify.status(.success)
		} catch let error {
			self.mergeRequests = .failure(error)
			Notify.status(.error)
		}
	}

	public var body: some View {
		List {
			if let mergeRequests {
				switch mergeRequests {
				case .success(let mrs):
					if mrs.isEmpty {
						NoContentView("There are no Merge Requests", image: "git-mr.symbols")
					} else {
						ForEach(mrs, id: \.reference) { mr in
							if let fullPath = mr.reference.split(separator: "!").first {
								SmallMergeView(String(fullPath), mr)
							}
						}
					}
				case .failure(let error):
					FailedView(error)
				}
			} else {
				LoadingView(
					"Loading Merge Requests", image: "git-mr.symbols", color: .blue)
			}
		}.onAppear {
			loadMergeRequests()
		}.refreshable {
			await reloadMergeRequests()
		}.navigationTitle("Merge Requests")
	}
}
