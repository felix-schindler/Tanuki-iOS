@file:JvmName("GitLabAPIAdapters")

package de.schindlerfelix.gitlab.bridge

import de.schindlerfelix.gitlab.api.ProjectsQuery
import de.schindlerfelix.gitlab.api.CurrentUserStarredProjectsQuery
import de.schindlerfelix.gitlab.api.UserStarredProjectsQuery
import de.schindlerfelix.gitlab.api.GroupsQuery
import de.schindlerfelix.gitlab.api.UserGroupsQuery
import de.schindlerfelix.gitlab.api.ProjectMergeRequestsQuery
import de.schindlerfelix.gitlab.api.GroupMergeRequestsQuery
import de.schindlerfelix.gitlab.api.MergeRequestQuery
import de.schindlerfelix.gitlab.api.UserAssignedMergeRequestsQuery
import de.schindlerfelix.gitlab.api.UserAuthoredMergeRequestsQuery
import de.schindlerfelix.gitlab.api.UserReviewRequestedMergeRequestsQuery
import de.schindlerfelix.gitlab.api.ProjectIssuesQuery
import de.schindlerfelix.gitlab.api.GroupIssuesQuery
import de.schindlerfelix.gitlab.api.EpicIssuesQuery
import de.schindlerfelix.gitlab.api.IssueQuery
import de.schindlerfelix.gitlab.api.UserIssuesQuery
import de.schindlerfelix.gitlab.api.CurrentUserIssuesQuery
import de.schindlerfelix.gitlab.api.GroupLabelsQuery
import de.schindlerfelix.gitlab.api.ProjectLabelsQuery
import de.schindlerfelix.gitlab.api.GroupMilestonesQuery
import de.schindlerfelix.gitlab.api.ProjectMilestonesQuery
import de.schindlerfelix.gitlab.api.GroupTimelogsQuery
import de.schindlerfelix.gitlab.api.UserTimelogsQuery
import de.schindlerfelix.gitlab.api.UserTodosQuery
import de.schindlerfelix.gitlab.api.CurrentUserTodosQuery
import de.schindlerfelix.gitlab.api.SnippetQuery
import de.schindlerfelix.gitlab.api.CurrentUserSnippetsQuery
import de.schindlerfelix.gitlab.api.UserSnippetsQuery
import de.schindlerfelix.gitlab.api.ProjectReleasesQuery
import de.schindlerfelix.gitlab.api.ProjectPipelinesQuery
import de.schindlerfelix.gitlab.api.MergeRequestCommitsQuery
import de.schindlerfelix.gitlab.api.CurrentUserQuery
import de.schindlerfelix.gitlab.api.UserQuery
import de.schindlerfelix.gitlab.api.ProjectMembersQuery
import de.schindlerfelix.gitlab.api.GroupMembersQuery
import de.schindlerfelix.gitlab.api.UsersQuery
import de.schindlerfelix.gitlab.api.EpicQuery
import de.schindlerfelix.gitlab.api.GroupEpicsQuery
import git.lab.api.MyAuthor
import git.lab.api.SmallProjectStruct
import git.lab.api.T_Project
import git.lab.api.T_Issue
import git.lab.api.T_MR
import git.lab.api.MyStats
import git.lab.api.UserStatus
import git.lab.api.ProjectPath

// SmallProject converters

public fun ProjectsQuery.Node.toSmallProjectStruct(): SmallProjectStruct = SmallProjectStruct(
    avatarUrl = avatarUrl,
    nameWithNamespace = nameWithNamespace,
    visibility = visibility,
    fullPath = fullPath,
)

public fun CurrentUserStarredProjectsQuery.Node.toSmallProjectStruct(): SmallProjectStruct = SmallProjectStruct(
    avatarUrl = avatarUrl,
    nameWithNamespace = nameWithNamespace,
    visibility = visibility,
    fullPath = fullPath,
)

public fun UserStarredProjectsQuery.Node.toSmallProjectStruct(): SmallProjectStruct = SmallProjectStruct(
    avatarUrl = avatarUrl,
    nameWithNamespace = nameWithNamespace,
    visibility = visibility,
    fullPath = fullPath,
)

// MyAuthor converters

public fun UsersQuery.Node.toMyAuthor(): MyAuthor = MyAuthor(
    avatarUrl = avatarUrl,
    name = name,
    username = username,
)

// Group helper

public fun GroupsQuery.Node.accessLevelString(): String? = maxAccessLevel.stringValue?.rawValue

public fun UserGroupsQuery.Node.accessLevelString(): String? = maxAccessLevel.stringValue?.rawValue

// ProjectPath helper

public fun userSmallMRProjectPath(fullPath: String): ProjectPath = ProjectPath(fullPath)

// Timelog helpers

public fun T_Project.Companion.from(fullPath: String, nameWithNamespace: String): T_Project =
    T_Project(fullPath = fullPath, nameWithNamespace = nameWithNamespace)

public fun T_Issue.Companion.from(iid: String): T_Issue = T_Issue(iid = iid)

public fun T_MR.Companion.from(iid: String): T_MR = T_MR(iid = iid)

// MyStats helper

public fun MyStats.Companion.from(closedIssuesCount: Int?, totalIssuesCount: Int?): MyStats =
    MyStats(closedIssuesCount = closedIssuesCount, totalIssuesCount = totalIssuesCount)

// UserStatus helper

public fun UserStatus.Companion.from(emoji: String?, message: String?): UserStatus =
    UserStatus(emoji = emoji, message = message)
