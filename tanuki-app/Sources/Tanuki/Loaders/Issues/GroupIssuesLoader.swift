//
//  GroupIssuesLoader.swift
//  Tanuki
//
//  Created by Felix Schindler on 31.10.21.
//  Rewritten by Felix Schindler on 07.03.24.
//

import GitLabAPI
import SwiftUI

struct GroupIssuesLoader: View {
	private let fullPath: String

	@State
	public var filter = IssueFilter()

	@State var showFilters = false

	@State var loadTask: Task<Void, Never>?

	init(fullPath: String) {
		self.fullPath = fullPath
	}

	@State var issues: Result<[SmallIssue], Error>? = nil

	private func loadIssues() {
		self.loadTask?.cancel()
		self.loadTask = Task {
			do {
				let issues = try await Network.shared.service.fetchGroupIssues(
					fullPath: self.fullPath,
					filter: GroupIssuesFilter(
						state: self.filter.state,
						search: self.filter.search,
						confidential: self.filter.confidential,
						subscribed: self.filter.subscribed,
						types: self.filter.types.map { $0 }
					)
				)
				if !Task.isCancelled {
					self.issues = .success(issues)
				}
			} catch {
				if !Task.isCancelled {
					self.issues = .failure(error)
					Notify.status(.error)
				}
			}
		}
	}

	private func reloadIssues() async {
		do {
			let issues = try await Network.shared.service.fetchGroupIssues(
				fullPath: self.fullPath,
				filter: GroupIssuesFilter(
					state: self.filter.state,
					search: self.filter.search,
					confidential: self.filter.confidential,
					subscribed: self.filter.subscribed,
					types: self.filter.types.map { $0 }
				)
			)
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
						Text("There are no issues")
					} else {
						ForEach(issues, id: \.reference) { issue in
							SmallIssueView(self.fullPath, issue)
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
		}.toolbar {
			Button("Filter", systemImage: "line.3.horizontal.decrease") {
				showFilters = true
			}
		}.sheet(isPresented: $showFilters, onDismiss: { self.showFilters = false }) {
			NavigationView {
				IssueFilterView(filter: $filter)
					.toolbar {
						AsyncButton("Apply filter", systemImage: "checkmark") {
							await reloadIssues()
							showFilters = false
						}
					}
			}
		}.searchable(
			text: Binding(get: { self.filter.search ?? "" }, set: { self.filter.search = $0.isNotEmpty ? $0 : nil }),
			prompt: "Search issues"
		).onChange(of: filter.search) { _ in
			self.issues = nil
			loadIssues()
		}.navigationTitle("Issues")
	}
}
