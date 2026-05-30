//
//  EpicIssuesLoader.swift
//  Tanuki
//
//  Created by Felix Schindler on 31.10.21.
//  Rewritten by Felix Schindler on 07.03.24.
//

import GitLabAPI
import SwiftUI

struct EpicIssuesLoader: View {
	private let fullPath: String
	private let iid: String

	@State var issues: Result<[SmallIssue], Error>? = nil

	init(fullPath: String, iid: String) {
		self.fullPath = fullPath
		self.iid = iid
	}

	private func loadIssues() {
		Task {
			do {
				let issues = try await Network.shared.service.fetchEpicIssues(fullPath: self.fullPath, iid: self.iid)
				self.issues = .success(issues)
			} catch let error {
				self.issues = .failure(error)
				Notify.status(.error)
			}
		}
	}

	private func reloadIssues() async {
		do {
			let issues = try await Network.shared.service.fetchEpicIssues(fullPath: self.fullPath, iid: self.iid)
			self.issues = .success(issues)
			Notify.status(.success)
		} catch let error {
			self.issues = .failure(error)
			Notify.status(.error)
		}
	}

	public var body: some View {
		List {
			if let issues {
				switch issues {
				case .success(let issues):
					if issues.isEmpty {
						NoContentView(
							"There are no issues", systemImage: "smallcircle.circle")
					} else {
						ForEach(issues, id: \.reference) { issue in
							SmallIssueView(
								String(issue.reference.split(separator: "#")[0]),
								issue
							)
						}
					}
				case .failure(let error):
					FailedView(error)
				}
			} else {
				LoadingView("Loading Issues", systemImage: "smallcircle.circle", color: .green)
			}
		}.onAppear {
			loadIssues()
		}.refreshable {
			await reloadIssues()
		}.navigationTitle("Issues")
	}
}

#Preview {
	NavigationView {
		EpicIssuesLoader(fullPath: "gitlab-org", iid: "12691")
	}
}
