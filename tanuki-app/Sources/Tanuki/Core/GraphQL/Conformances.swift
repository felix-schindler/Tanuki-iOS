import GitLabAPI

// MARK: - Author
extension GitLabAPI.UsersQuery.Data.Users.Node: Author {}

// MARK: - SmallProject
extension GitLabAPI.ProjectsQuery.Data.Projects.Node: SmallProject {}
extension GitLabAPI.CurrentUserStarredProjectsQuery.Data.CurrentUser.StarredProjects.Node: SmallProject {}
extension GitLabAPI.UserStarredProjectsQuery.Data.User.StarredProjects.Node: SmallProject {}

// MARK: - SmallGroup
extension GitLabAPI.GroupsQuery.Data.Groups.Node: SmallGroup {
	public var _name: String? { name }
	public var _accessLevel: String? { maxAccessLevel.stringValue?.rawValue }
}
extension GitLabAPI.UserGroupsQuery.Data.User.Groups.Node: SmallGroup {
	public var _name: String? { name }
	public var _accessLevel: String? { maxAccessLevel.stringValue?.rawValue }
}

// MARK: - Member
extension GitLabAPI.ProjectMembersQuery.Data.Project.ProjectMembers.Node: Member {
	public var _accessLevel: String? { accessLevel?.stringValue?.rawValue }
	public var _user: MyAuthor? {
		guard let u = user else { return nil }
		return MyAuthor(avatarUrl: u.avatarUrl, name: u.name, username: u.username)
	}
	public var _createdBy: MyAuthor? {
		guard let c = createdBy else { return nil }
		return MyAuthor(avatarUrl: c.avatarUrl, name: c.name, username: c.username)
	}
}
extension GitLabAPI.GroupMembersQuery.Data.Group.GroupMembers.Node: Member {
	public var _accessLevel: String? { accessLevel?.stringValue?.rawValue }
	public var _user: MyAuthor? {
		guard let u = user else { return nil }
		return MyAuthor(avatarUrl: u.avatarUrl, name: u.name, username: u.username)
	}
	public var _createdBy: MyAuthor? {
		guard let c = createdBy else { return nil }
		return MyAuthor(avatarUrl: c.avatarUrl, name: c.name, username: c.username)
	}
}

// MARK: - Note
extension GitLabAPI.IssueQuery.Data.Project.Issue.Notes.Node: Note {
	public var _author: MyAuthor? {
		guard let a = author else { return nil }
		return MyAuthor(avatarUrl: a.avatarUrl, name: a.name, username: a.username)
	}
}
extension GitLabAPI.MergeRequestQuery.Data.Project.MergeRequest.Notes.Node: Note {
	public var _author: MyAuthor? {
		guard let a = author else { return nil }
		return MyAuthor(avatarUrl: a.avatarUrl, name: a.name, username: a.username)
	}
}
extension GitLabAPI.SnippetQuery.Data.Snippets.Node.Notes.Node: Note {
	public var _author: MyAuthor? {
		guard let a = author else { return nil }
		return MyAuthor(avatarUrl: a.avatarUrl, name: a.name, username: a.username)
	}
}
extension GitLabAPI.EpicQuery.Data.Group.Epic.Notes.Node: Note {
	public var _author: MyAuthor? {
		guard let a = author else { return nil }
		return MyAuthor(avatarUrl: a.avatarUrl, name: a.name, username: a.username)
	}
}

// MARK: - SmallMergeRequest
extension GitLabAPI.ProjectMergeRequestsQuery.Data.Project.MergeRequests.Node: SmallMergeRequest {
	public var _author: MyAuthor? {
		guard let a = author else { return nil }
		return MyAuthor(avatarUrl: a.avatarUrl, name: a.name, username: a.username)
	}
}
extension GitLabAPI.GroupMergeRequestsQuery.Data.Group.MergeRequests.Node: SmallMergeRequest {
	public var _author: MyAuthor? {
		guard let a = author else { return nil }
		return MyAuthor(avatarUrl: a.avatarUrl, name: a.name, username: a.username)
	}
}
extension GitLabAPI.MergeRequestQuery.Data.Project.MergeRequest: MergeRequest {
	public var _author: MyAuthor? {
		guard let a = author else { return nil }
		return MyAuthor(avatarUrl: a.avatarUrl, name: a.name, username: a.username)
	}
}

// MARK: - UserSmallMergeRequest
extension GitLabAPI.UserAssignedMergeRequestsQuery.Data.CurrentUser.AssignedMergeRequests.Node: UserSmallMergeRequest {
	public var _project: ProjectPath { ProjectPath(fullPath: project.fullPath) }
	public var _author: MyAuthor? {
		guard let a = author else { return nil }
		return MyAuthor(avatarUrl: a.avatarUrl, name: a.name, username: a.username)
	}
}
extension GitLabAPI.UserAuthoredMergeRequestsQuery.Data.CurrentUser.AuthoredMergeRequests.Node: UserSmallMergeRequest {
	public var _project: ProjectPath { ProjectPath(fullPath: project.fullPath) }
	public var _author: MyAuthor? {
		guard let a = author else { return nil }
		return MyAuthor(avatarUrl: a.avatarUrl, name: a.name, username: a.username)
	}
}
extension GitLabAPI.UserReviewRequestedMergeRequestsQuery.Data.CurrentUser.ReviewRequestedMergeRequests.Node: UserSmallMergeRequest {
	public var _project: ProjectPath { ProjectPath(fullPath: project.fullPath) }
	public var _author: MyAuthor? {
		guard let a = author else { return nil }
		return MyAuthor(avatarUrl: a.avatarUrl, name: a.name, username: a.username)
	}
}

// MARK: - SmallIssue
extension GitLabAPI.IssueQuery.Data.Project.Issue: HasAuthor {
	public var _author: MyAuthor {
		MyAuthor(avatarUrl: author.avatarUrl, name: author.name, username: author.username)
	}
}
extension GitLabAPI.ProjectIssuesQuery.Data.Project.Issues.Node: SmallIssue {
	public var _author: MyAuthor {
		MyAuthor(avatarUrl: author.avatarUrl, name: author.name, username: author.username)
	}
}
extension GitLabAPI.GroupIssuesQuery.Data.Group.Issues.Node: SmallIssue {
	public var _author: MyAuthor {
		MyAuthor(avatarUrl: author.avatarUrl, name: author.name, username: author.username)
	}
}
extension GitLabAPI.EpicIssuesQuery.Data.Group.Epic.Issues.Node: SmallIssue {
	public var _author: MyAuthor {
		MyAuthor(avatarUrl: author.avatarUrl, name: author.name, username: author.username)
	}
}
extension GitLabAPI.UserIssuesQuery.Data.User.ProjectMemberships.Node.Project.Issues.Node: SmallIssue {
	public var _author: MyAuthor {
		MyAuthor(avatarUrl: author.avatarUrl, name: author.name, username: author.username)
	}
}
extension GitLabAPI.CurrentUserIssuesQuery.Data.CurrentUser.ProjectMemberships.Node.Project.Issues.Node: SmallIssue {
	public var _author: MyAuthor {
		MyAuthor(avatarUrl: author.avatarUrl, name: author.name, username: author.username)
	}
}

// MARK: - IssueProjectMembership
extension GitLabAPI.UserIssuesQuery.Data.User.ProjectMemberships.Node: IssueProjectMembership {
	public var fullPath: String? { project?.fullPath }
	public var _issues: [SmallIssue?]? { project?.issues?.nodes }
}
extension GitLabAPI.CurrentUserIssuesQuery.Data.CurrentUser.ProjectMemberships.Node: IssueProjectMembership {
	public var fullPath: String? { project?.fullPath }
	public var _issues: [SmallIssue?]? { project?.issues?.nodes }
}

// MARK: - User
extension GitLabAPI.CurrentUserQuery.Data.CurrentUser: User {
	public var _status: UserStatus? {
		guard let s = status else { return nil }
		return UserStatus(emoji: s.emoji, message: s.message)
	}
}
extension GitLabAPI.UserQuery.Data.User: User {
	public var _status: UserStatus? {
		guard let s = status else { return nil }
		return UserStatus(emoji: s.emoji, message: s.message)
	}
}

// MARK: - Snippet
extension GitLabAPI.SnippetQuery.Data.Snippets.Node: Snippet {
	public var _author: MyAuthor? {
		guard let a = author else { return nil }
		return MyAuthor(avatarUrl: a.avatarUrl, name: a.name, username: a.username)
	}
}
extension GitLabAPI.CurrentUserSnippetsQuery.Data.CurrentUser.Snippets.Node: Snippet {
	public var _author: MyAuthor? {
		guard let a = author else { return nil }
		return MyAuthor(avatarUrl: a.avatarUrl, name: a.name, username: a.username)
	}
}
extension GitLabAPI.UserSnippetsQuery.Data.User.Snippets.Node: Snippet {
	public var _author: MyAuthor? {
		guard let a = author else { return nil }
		return MyAuthor(avatarUrl: a.avatarUrl, name: a.name, username: a.username)
	}
}

// MARK: - Release
extension GitLabAPI.ProjectReleasesQuery.Data.Project.Releases.Node: Release {
	public var _author: MyAuthor? {
		guard let a = author else { return nil }
		return MyAuthor(avatarUrl: a.avatarUrl, name: a.name, username: a.username)
	}
}

// MARK: - MyLabel
extension GitLabAPI.GroupLabelsQuery.Data.Group.Labels.Node: MyLabel {}
extension GitLabAPI.ProjectLabelsQuery.Data.Project.Labels.Node: MyLabel {}

// MARK: - Milestone
extension GitLabAPI.GroupMilestonesQuery.Data.Group.Milestones.Node: Milestone {
	public var _stats: MyStats? {
		guard let s = stats else { return nil }
		return MyStats(closedIssuesCount: s.closedIssuesCount, totalIssuesCount: s.totalIssuesCount)
	}
}
extension GitLabAPI.ProjectMilestonesQuery.Data.Project.Milestones.Node: Milestone {
	public var _stats: MyStats? {
		guard let s = stats else { return nil }
		return MyStats(closedIssuesCount: s.closedIssuesCount, totalIssuesCount: s.totalIssuesCount)
	}
}

// MARK: - Timelog
extension GitLabAPI.GroupTimelogsQuery.Data.Group.Timelogs.Node: Timelog {
	public var _user: MyAuthor {
		MyAuthor(avatarUrl: user.avatarUrl, name: user.name, username: user.username)
	}
	public var _project: T_Project {
		T_Project(fullPath: project.fullPath, nameWithNamespace: project.nameWithNamespace)
	}
	public var _issue: T_Issue? {
		guard let i = issue else { return nil }
		return T_Issue(iid: i.iid)
	}
	public var _mergeRequest: T_MR? {
		guard let m = mergeRequest else { return nil }
		return T_MR(iid: m.iid)
	}
}
extension GitLabAPI.UserTimelogsQuery.Data.User.Timelogs.Node: Timelog {
	public var _user: MyAuthor {
		MyAuthor(avatarUrl: user.avatarUrl, name: user.name, username: user.username)
	}
	public var _project: T_Project {
		T_Project(fullPath: project.fullPath, nameWithNamespace: project.nameWithNamespace)
	}
	public var _issue: T_Issue? {
		guard let i = issue else { return nil }
		return T_Issue(iid: i.iid)
	}
	public var _mergeRequest: T_MR? {
		guard let m = mergeRequest else { return nil }
		return T_MR(iid: m.iid)
	}
}

// MARK: - Todo
extension GitLabAPI.UserTodosQuery.Data.User.Todos.Node: Todo {
	public var _project: SmallProject? {
		guard let p = project else { return nil }
		return SmallProjectStruct(avatarUrl: p.avatarUrl, nameWithNamespace: p.nameWithNamespace, visibility: p.visibility, fullPath: p.fullPath)
	}
	public var _groupPath: String? { group?.id }
	public var _author: MyAuthor {
		MyAuthor(avatarUrl: author.avatarUrl, name: author.name, username: author.username)
	}
	public var _webUrl: String? { targetEntity?.webUrl }
}
extension GitLabAPI.CurrentUserTodosQuery.Data.CurrentUser.Todos.Node: Todo {
	public var _project: SmallProject? {
		guard let p = project else { return nil }
		return SmallProjectStruct(avatarUrl: p.avatarUrl, nameWithNamespace: p.nameWithNamespace, visibility: p.visibility, fullPath: p.fullPath)
	}
	public var _groupPath: String? { group?.id }
	public var _author: MyAuthor {
		MyAuthor(avatarUrl: author.avatarUrl, name: author.name, username: author.username)
	}
	public var _webUrl: String? { targetEntity?.webUrl }
}

// MARK: - NewCommit
extension GitLabAPI.ProjectQuery.Data.Project.Repository.Tree.LastCommit: NewCommit {
	public var _signatureVerificationStatus: String? { signature?.verificationStatus?.rawValue }
	public var _lastPipelineStatus: GraphQLEnum<PipelineStatusEnum>? {
		if let pipelines = pipelines?.nodes, !pipelines.isEmpty {
			return pipelines[0]?.status
		}
		return nil
	}
}
extension GitLabAPI.MergeRequestCommitsQuery.Data.Project.MergeRequest.Commits.Node: NewCommit {
	public var _signatureVerificationStatus: String? { signature?.verificationStatus?.rawValue }
	public var _lastPipelineStatus: GraphQLEnum<PipelineStatusEnum>? {
		if let pipelines = pipelines?.nodes, !pipelines.isEmpty {
			return pipelines[0]?.status
		}
		return nil
	}
}

// MARK: - HasAuthor / MaybeHasAuthor
extension GitLabAPI.EpicQuery.Data.Group.Epic: HasAuthor {
	public var _author: MyAuthor {
		MyAuthor(avatarUrl: author.avatarUrl, name: author.name, username: author.username)
	}
}
extension GitLabAPI.GroupEpicsQuery.Data.Group.Epics.Node: HasAuthor {
	public var _author: MyAuthor {
		MyAuthor(avatarUrl: author.avatarUrl, name: author.name, username: author.username)
	}
}
extension GitLabAPI.ProjectPipelinesQuery.Data.Project.Pipelines.Node: MaybeHasAuthor {
	public var _author: MyAuthor? {
		guard let u = user else { return nil }
		return MyAuthor(avatarUrl: u.avatarUrl, name: u.name, username: u.username)
	}
}
