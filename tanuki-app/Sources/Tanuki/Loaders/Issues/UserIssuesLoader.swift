//
//  UserIssuesLoader.swift
//  Tanuki
//
//  Created by Felix Schindler on 31.10.21.
//  Rewritten by Felix Schindler on 07.03.24.
//

import GitLabAPI
import SwiftUI

#if SKIP_BRIDGE
	private typealias PlatformNavigationView = NavigationStack
#else
	private typealias PlatformNavigationView = NavigationView
#endif

private struct MappedIssue: SmallIssue {
	let iid: String
	let title: String
	let reference: String
	let state: IssueState
	let upvotes: Int
	let downvotes: Int
	let userNotesCount: Int
	let _author: MyAuthor
	let createdAt: String
	let webUrl: String

	init(
		iid: String?, title: String?, reference: String?, state: String?, upvotes: String?, downvotes: String?, userNotesCount: String?, authorAvatarUrl: String?, authorName: String?,
		authorUsername: String?, createdAt: String?, webUrl: String?
	) {
		self.iid = iid ?? ""
		self.title = title ?? ""
		self.reference = reference ?? ""
		self.state = IssueState(rawValue: state ?? "") ?? .opened
		self.upvotes = Int(upvotes ?? "0") ?? 0
		self.downvotes = Int(downvotes ?? "0") ?? 0
		self.userNotesCount = Int(userNotesCount ?? "0") ?? 0
		self._author = MyAuthor(avatarUrl: authorAvatarUrl, name: authorName ?? "", username: authorUsername ?? "")
		self.createdAt = createdAt ?? ""
		self.webUrl = webUrl ?? ""
	}
}

struct UserIssuesLoader: View {
	private let username: String?

	@State
	public var filter = IssueFilter()

	@State var showFilters = false

	@State var loadTask: Task<Void, Never>?

	@State var issues: Result<[SmallIssue], Error>? = nil

	init(username: String? = nil) {
		self.username = username
	}

	private func loadIssues() {
		self.loadTask?.cancel()
		self.loadTask = Task {
			do {
				if let username {
					let user = try await Network.shared.service.fetchUserIssues(
						username: username,
						filter: UserIssuesFilter(
							state: GraphFilter.toFilterEnum(self.filter.state),
							search: GraphFilter.toFilter(self.filter.search),
							confidential: GraphFilter.toFilter(self.filter.confidential),
							subscribed: GraphFilter.toFilterEnum(self.filter.subscribed),
							types: self.filter.types
						)
					)
					if Task.isCancelled { return }
					self.issues = .success(mapIssues(user.projectMemberships?.nodes))
				} else {
					let currentUser = try await Network.shared.service.fetchCurrentUserIssues(
						filter: CurrentUserIssuesFilter(
							state: GraphFilter.toFilterEnum(self.filter.state),
							search: GraphFilter.toFilter(self.filter.search),
							confidential: GraphFilter.toFilter(self.filter.confidential),
							subscribed: GraphFilter.toFilterEnum(self.filter.subscribed),
							types: self.filter.types
						)
					)
					if Task.isCancelled { return }
					self.issues = .success(mapIssues(currentUser.projectMemberships?.nodes))
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
			if let username {
				let user = try await Network.shared.service.fetchUserIssues(
					username: username,
					filter: UserIssuesFilter(
						state: GraphFilter.toFilterEnum(self.filter.state),
						search: GraphFilter.toFilter(self.filter.search),
						confidential: GraphFilter.toFilter(self.filter.confidential),
						subscribed: GraphFilter.toFilterEnum(self.filter.subscribed),
						types: self.filter.types
					),
					strategy: .networkOnly
				)
				self.issues = .success(mapIssues(user.projectMemberships?.nodes))
			} else {
				let currentUser = try await Network.shared.service.fetchCurrentUserIssues(
					filter: CurrentUserIssuesFilter(
						state: GraphFilter.toFilterEnum(self.filter.state),
						search: GraphFilter.toFilter(self.filter.search),
						confidential: GraphFilter.toFilter(self.filter.confidential),
						subscribed: GraphFilter.toFilterEnum(self.filter.subscribed),
						types: self.filter.types
					),
					strategy: .networkOnly
				)
				self.issues = .success(mapIssues(currentUser.projectMemberships?.nodes))
			}
			Notify.status(.success)
		} catch let error {
			self.issues = .failure(error)
			Notify.status(.error)
		}
	}

	private func mapIssues(_ memberships: [UserIssues_User_ProjectMemberships_Nodes]?) -> [SmallIssue] {
		(memberships ?? []).compactMap { $0 }.flatMap { node in
			(node.project?.issues?.nodes ?? []).compactMap { $0 }.map { issueNode in
				MappedIssue(
					iid: issueNode.iid,
					title: issueNode.title,
					reference: issueNode.reference,
					state: issueNode.state,
					upvotes: issueNode.upvotes,
					downvotes: issueNode.downvotes,
					userNotesCount: issueNode.userNotesCount,
					authorAvatarUrl: issueNode.author?.avatarUrl,
					authorName: issueNode.author?.name,
					authorUsername: issueNode.author?.username,
					createdAt: issueNode.createdAt,
					webUrl: issueNode.webUrl
				) as SmallIssue
			}
		}
	}

	private func mapIssues(_ memberships: [CurrentUserIssues_CurrentUser_ProjectMemberships_Nodes]?) -> [SmallIssue] {
		(memberships ?? []).compactMap { $0 }.flatMap { node in
			(node.project?.issues?.nodes ?? []).compactMap { $0 }.map { issueNode in
				MappedIssue(
					iid: issueNode.iid,
					title: issueNode.title,
					reference: issueNode.reference,
					state: issueNode.state,
					upvotes: issueNode.upvotes,
					downvotes: issueNode.downvotes,
					userNotesCount: issueNode.userNotesCount,
					authorAvatarUrl: issueNode.author?.avatarUrl,
					authorName: issueNode.author?.name,
					authorUsername: issueNode.author?.username,
					createdAt: issueNode.createdAt,
					webUrl: issueNode.webUrl
				) as SmallIssue
			}
		}
	}

	public var body: some View {
		List {
			if let issues {
				switch issues {
				case .success(let issues):
					if issues.isEmpty {
						NoContentView(
							"All caught up!", systemImage: "smallcircle.circle",
							description: "There are no Issues")
					} else {
						ForEach(issues, id: \.reference) { issue in
							let fullPath = String(issue.reference.split(separator: "#")[0])
							SmallIssueView(fullPath, issue)
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
			PlatformNavigationView {
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
