import ApolloAPI
@_exported import ApolloAPI
import Foundation
import GitLabAPI

// Aliases so app code can keep the `GitLabAPI.<Type>` prefix.
public typealias CurrentUserIssuesQuery = GitLabAPI.CurrentUserIssuesQuery
public typealias CurrentUserQuery = GitLabAPI.CurrentUserQuery
public typealias CurrentUserSnippetsQuery = GitLabAPI.CurrentUserSnippetsQuery
public typealias CurrentUserStarredProjectsQuery = GitLabAPI.CurrentUserStarredProjectsQuery
public typealias CurrentUserTodosQuery = GitLabAPI.CurrentUserTodosQuery
public typealias GroupCustomEmojiQuery = GitLabAPI.GroupCustomEmojiQuery
public typealias GroupIssuesQuery = GitLabAPI.GroupIssuesQuery
public typealias GroupLabelsQuery = GitLabAPI.GroupLabelsQuery
public typealias GroupMembersQuery = GitLabAPI.GroupMembersQuery
public typealias GroupMergeRequestsQuery = GitLabAPI.GroupMergeRequestsQuery
public typealias GroupMilestonesQuery = GitLabAPI.GroupMilestonesQuery
public typealias GroupProjectsQuery = GitLabAPI.GroupProjectsQuery
public typealias GroupQuery = GitLabAPI.GroupQuery
public typealias GroupsQuery = GitLabAPI.GroupsQuery
public typealias GroupTimelogsQuery = GitLabAPI.GroupTimelogsQuery
public typealias IssueQuery = GitLabAPI.IssueQuery
public typealias IssueStateMutation = GitLabAPI.IssueStateMutation
public typealias MergeRequestCommitsQuery = GitLabAPI.MergeRequestCommitsQuery
public typealias MergeRequestDiffsQuery = GitLabAPI.MergeRequestDiffsQuery
public typealias MergeRequestQuery = GitLabAPI.MergeRequestQuery
public typealias ProjectIssuesQuery = GitLabAPI.ProjectIssuesQuery
public typealias ProjectLabelsQuery = GitLabAPI.ProjectLabelsQuery
public typealias ProjectMembersQuery = GitLabAPI.ProjectMembersQuery
public typealias ProjectMergeRequestsQuery = GitLabAPI.ProjectMergeRequestsQuery
public typealias ProjectMilestonesQuery = GitLabAPI.ProjectMilestonesQuery
public typealias ProjectPipelinesQuery = GitLabAPI.ProjectPipelinesQuery
public typealias ProjectQuery = GitLabAPI.ProjectQuery
public typealias ProjectReleasesQuery = GitLabAPI.ProjectReleasesQuery
public typealias ProjectsQuery = GitLabAPI.ProjectsQuery
public typealias RepoTreeQuery = GitLabAPI.RepoTreeQuery
public typealias SnippetQuery = GitLabAPI.SnippetQuery
public typealias StarProjectMutation = GitLabAPI.StarProjectMutation
public typealias UserAssignedMergeRequestsQuery = GitLabAPI.UserAssignedMergeRequestsQuery
public typealias UserAuthoredMergeRequestsQuery = GitLabAPI.UserAuthoredMergeRequestsQuery
public typealias UserGroupsQuery = GitLabAPI.UserGroupsQuery
public typealias UserIssuesQuery = GitLabAPI.UserIssuesQuery
public typealias UserMembershipProjectsQuery = GitLabAPI.UserMembershipProjectsQuery
public typealias UserQuery = GitLabAPI.UserQuery
public typealias UserReviewRequestedMergeRequestsQuery = GitLabAPI.UserReviewRequestedMergeRequestsQuery
public typealias UserSnippetsQuery = GitLabAPI.UserSnippetsQuery
public typealias UserStarredProjectsQuery = GitLabAPI.UserStarredProjectsQuery
public typealias UserTimelogsQuery = GitLabAPI.UserTimelogsQuery
public typealias UserTodosQuery = GitLabAPI.UserTodosQuery
public typealias UsersQuery = GitLabAPI.UsersQuery

// On iOS, the wrapper types are aliases to Apollo-generated types
// so existing code that uses switch/case and pattern matching still works.
public typealias AccessLevelEnum = GitLabAPI.AccessLevelEnum
public typealias DetailedMergeStatus = GitLabAPI.DetailedMergeStatus
public typealias IssuableState = GitLabAPI.IssuableState
public typealias IssueState = GitLabAPI.IssueState
public typealias IssueStateEvent = GitLabAPI.IssueStateEvent
public typealias MergeRequestState = GitLabAPI.MergeRequestState
public typealias MilestoneStateEnum = GitLabAPI.MilestoneStateEnum
public typealias PipelineStatusEnum = GitLabAPI.PipelineStatusEnum
public typealias ProjectArchived = GitLabAPI.ProjectArchived
public typealias SubscriptionStatus = GitLabAPI.SubscriptionStatus
public typealias TodoActionEnum = GitLabAPI.TodoActionEnum
public typealias TodoStateEnum = GitLabAPI.TodoStateEnum
public typealias TodoTargetEnum = GitLabAPI.TodoTargetEnum
public typealias UserState = GitLabAPI.UserState
public typealias VerificationStatus = GitLabAPI.VerificationStatus
public typealias VisibilityLevelsEnum = GitLabAPI.VisibilityLevelsEnum

// GraphQLEnum is the Apollo wrapper type; typealias to ApolloAPI.GraphQLEnum
public typealias GraphQLEnum = ApolloAPI.GraphQLEnum
