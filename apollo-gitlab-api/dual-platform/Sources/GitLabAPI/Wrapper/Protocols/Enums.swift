import Foundation

import ApolloAPI
import IOSGitLabAPI

@_exported import ApolloAPI

// Aliases so app code can keep the `GitLabAPI.<Type>` prefix.
public typealias CurrentUserIssuesQuery = IOSGitLabAPI.CurrentUserIssuesQuery
public typealias CurrentUserQuery = IOSGitLabAPI.CurrentUserQuery
public typealias CurrentUserSnippetsQuery = IOSGitLabAPI.CurrentUserSnippetsQuery
public typealias CurrentUserStarredProjectsQuery = IOSGitLabAPI.CurrentUserStarredProjectsQuery
public typealias CurrentUserTodosQuery = IOSGitLabAPI.CurrentUserTodosQuery
public typealias EpicIssuesQuery = IOSGitLabAPI.EpicIssuesQuery
public typealias EpicQuery = IOSGitLabAPI.EpicQuery
public typealias GroupCustomEmojiQuery = IOSGitLabAPI.GroupCustomEmojiQuery
public typealias GroupEpicsQuery = IOSGitLabAPI.GroupEpicsQuery
public typealias GroupIssuesQuery = IOSGitLabAPI.GroupIssuesQuery
public typealias GroupLabelsQuery = IOSGitLabAPI.GroupLabelsQuery
public typealias GroupMembersQuery = IOSGitLabAPI.GroupMembersQuery
public typealias GroupMergeRequestsQuery = IOSGitLabAPI.GroupMergeRequestsQuery
public typealias GroupMilestonesQuery = IOSGitLabAPI.GroupMilestonesQuery
public typealias GroupQuery = IOSGitLabAPI.GroupQuery
public typealias GroupsQuery = IOSGitLabAPI.GroupsQuery
public typealias GroupTimelogsQuery = IOSGitLabAPI.GroupTimelogsQuery
public typealias IssueQuery = IOSGitLabAPI.IssueQuery
public typealias IssueStateMutation = IOSGitLabAPI.IssueStateMutation
public typealias MergeRequestCommitsQuery = IOSGitLabAPI.MergeRequestCommitsQuery
public typealias MergeRequestDiffsQuery = IOSGitLabAPI.MergeRequestDiffsQuery
public typealias MergeRequestQuery = IOSGitLabAPI.MergeRequestQuery
public typealias ProjectIssuesQuery = IOSGitLabAPI.ProjectIssuesQuery
public typealias ProjectLabelsQuery = IOSGitLabAPI.ProjectLabelsQuery
public typealias ProjectMembersQuery = IOSGitLabAPI.ProjectMembersQuery
public typealias ProjectMergeRequestsQuery = IOSGitLabAPI.ProjectMergeRequestsQuery
public typealias ProjectMilestonesQuery = IOSGitLabAPI.ProjectMilestonesQuery
public typealias ProjectPipelinesQuery = IOSGitLabAPI.ProjectPipelinesQuery
public typealias ProjectQuery = IOSGitLabAPI.ProjectQuery
public typealias ProjectReleasesQuery = IOSGitLabAPI.ProjectReleasesQuery
public typealias ProjectsQuery = IOSGitLabAPI.ProjectsQuery
public typealias RepoTreeQuery = IOSGitLabAPI.RepoTreeQuery
public typealias SnippetQuery = IOSGitLabAPI.SnippetQuery
public typealias StarProjectMutation = IOSGitLabAPI.StarProjectMutation
public typealias UserAssignedMergeRequestsQuery = IOSGitLabAPI.UserAssignedMergeRequestsQuery
public typealias UserAuthoredMergeRequestsQuery = IOSGitLabAPI.UserAuthoredMergeRequestsQuery
public typealias UserGroupsQuery = IOSGitLabAPI.UserGroupsQuery
public typealias UserIssuesQuery = IOSGitLabAPI.UserIssuesQuery
public typealias UserQuery = IOSGitLabAPI.UserQuery
public typealias UserReviewRequestedMergeRequestsQuery = IOSGitLabAPI.UserReviewRequestedMergeRequestsQuery
public typealias UserSnippetsQuery = IOSGitLabAPI.UserSnippetsQuery
public typealias UserStarredProjectsQuery = IOSGitLabAPI.UserStarredProjectsQuery
public typealias UserTimelogsQuery = IOSGitLabAPI.UserTimelogsQuery
public typealias UserTodosQuery = IOSGitLabAPI.UserTodosQuery
public typealias UsersQuery = IOSGitLabAPI.UsersQuery

// On iOS, the wrapper types are aliases to Apollo-generated types
// so existing code that uses switch/case and pattern matching still works.
public typealias AccessLevelEnum = IOSGitLabAPI.AccessLevelEnum
public typealias DetailedMergeStatus = IOSGitLabAPI.DetailedMergeStatus
public typealias EpicState = IOSGitLabAPI.EpicState
public typealias IssuableState = IOSGitLabAPI.IssuableState
public typealias IssueState = IOSGitLabAPI.IssueState
public typealias IssueStateEvent = IOSGitLabAPI.IssueStateEvent
public typealias IssueType = IOSGitLabAPI.IssueType
public typealias MergeRequestState = IOSGitLabAPI.MergeRequestState
public typealias MergeStatus = IOSGitLabAPI.MergeStatus
public typealias MilestoneStateEnum = IOSGitLabAPI.MilestoneStateEnum
public typealias PipelineStatusEnum = IOSGitLabAPI.PipelineStatusEnum
public typealias ProjectArchived = IOSGitLabAPI.ProjectArchived
public typealias SubscriptionStatus = IOSGitLabAPI.SubscriptionStatus
public typealias TodoActionEnum = IOSGitLabAPI.TodoActionEnum
public typealias TodoStateEnum = IOSGitLabAPI.TodoStateEnum
public typealias TodoTargetEnum = IOSGitLabAPI.TodoTargetEnum
public typealias UserState = IOSGitLabAPI.UserState
public typealias VerificationStatus = IOSGitLabAPI.VerificationStatus
public typealias VisibilityLevelsEnum = IOSGitLabAPI.VisibilityLevelsEnum

// GraphQLEnum is the Apollo wrapper type; typealias to ApolloAPI.GraphQLEnum
public typealias GraphQLEnum = ApolloAPI.GraphQLEnum

