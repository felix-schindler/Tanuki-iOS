//
//  Issues.swift
//  Tanuki
//
//  Created by Felix Schindler on 31.10.21.
//  Rewritten by Felix Schindler on 26.02.24.
//

import GitLabAPI
import SwiftUI

struct ProjectIssuesLoader: View {
	/// Path of project to load issues from
	private let fullPath: String

	@State
	public var filter = IssueFilter()

	@State var showFilters = false

	@State var loadTask: Task<Void, Never>?

	@State var issues: Result<[SmallIssue], Error>? = nil

	init(fullPath: String) {
		self.fullPath = fullPath
	}

	private func loadIssues() {
		self.loadTask?.cancel()
		self.loadTask = Task {
			do {
				let issues = try await Network.shared.service.fetchProjectIssues(
					fullPath: self.fullPath,
					filter: ProjectIssuesFilter(
						state: GraphFilter.toFilterEnum(self.filter.state),
						search: GraphFilter.toFilter(self.filter.search),
						confidential: GraphFilter.toFilter(self.filter.confidential),
						subscribed: GraphFilter.toFilterEnum(self.filter.subscribed),
						types: self.filter.types
					)
				)
				if Task.isCancelled { return }
				self.issues = .success(issues)
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
			let issues = try await Network.shared.service.fetchProjectIssues(
				fullPath: self.fullPath,
				filter: ProjectIssuesFilter(
					state: GraphFilter.toFilterEnum(self.filter.state),
					search: GraphFilter.toFilter(self.filter.search),
					confidential: GraphFilter.toFilter(self.filter.confidential),
					subscribed: GraphFilter.toFilterEnum(self.filter.subscribed),
					types: self.filter.types
				),
				strategy: .networkOnly
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
						NoContentView(
							"There are no issues", systemImage: "smallcircle.circle")
					} else {
						ForEach(issues, id: \.iid) { issue in
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
			HStack {
				NavigationLink(
					destination: NewIssueView(id: 0, fullPath: self.fullPath),
					label: {
						Label("New issue", systemImage: "plus")
					}
				).tint(.accentColor)

				Button("Filter", systemImage: "line.3.horizontal.decrease") {
					showFilters = true
				}
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
			self.issues = nil  // Show loading state
			loadIssues()
		}.navigationTitle("Issues")
	}
}
