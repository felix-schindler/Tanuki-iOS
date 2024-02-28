// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public typealias ID = String

public protocol SelectionSet: ApolloAPI.SelectionSet & ApolloAPI.RootSelectionSet
where Schema == GitLabAPI.SchemaMetadata {}

public protocol InlineFragment: ApolloAPI.SelectionSet & ApolloAPI.InlineFragment
where Schema == GitLabAPI.SchemaMetadata {}

public protocol MutableSelectionSet: ApolloAPI.MutableRootSelectionSet
where Schema == GitLabAPI.SchemaMetadata {}

public protocol MutableInlineFragment: ApolloAPI.MutableSelectionSet & ApolloAPI.InlineFragment
where Schema == GitLabAPI.SchemaMetadata {}

public enum SchemaMetadata: ApolloAPI.SchemaMetadata {
  public static let configuration: ApolloAPI.SchemaConfiguration.Type = SchemaConfiguration.self

  public static func objectType(forTypename typename: String) -> ApolloAPI.Object? {
    switch typename {
    case "Query": return GitLabAPI.Objects.Query
    case "Namespace": return GitLabAPI.Objects.Namespace
    case "ProjectConnection": return GitLabAPI.Objects.ProjectConnection
    case "Project": return GitLabAPI.Objects.Project
    case "CurrentUser": return GitLabAPI.Objects.CurrentUser
    case "AddOnUser": return GitLabAPI.Objects.AddOnUser
    case "AutocompletedUser": return GitLabAPI.Objects.AutocompletedUser
    case "MergeRequestAssignee": return GitLabAPI.Objects.MergeRequestAssignee
    case "MergeRequestAuthor": return GitLabAPI.Objects.MergeRequestAuthor
    case "MergeRequestParticipant": return GitLabAPI.Objects.MergeRequestParticipant
    case "MergeRequestReviewer": return GitLabAPI.Objects.MergeRequestReviewer
    case "UserCore": return GitLabAPI.Objects.UserCore
    case "MergeRequestConnection": return GitLabAPI.Objects.MergeRequestConnection
    case "MergeRequest": return GitLabAPI.Objects.MergeRequest
    case "BoardEpic": return GitLabAPI.Objects.BoardEpic
    case "Epic": return GitLabAPI.Objects.Epic
    case "AbuseReport": return GitLabAPI.Objects.AbuseReport
    case "AlertManagementAlert": return GitLabAPI.Objects.AlertManagementAlert
    case "Commit": return GitLabAPI.Objects.Commit
    case "Design": return GitLabAPI.Objects.Design
    case "DesignAtVersion": return GitLabAPI.Objects.DesignAtVersion
    case "EpicIssue": return GitLabAPI.Objects.EpicIssue
    case "Issue": return GitLabAPI.Objects.Issue
    case "WorkItem": return GitLabAPI.Objects.WorkItem
    case "Snippet": return GitLabAPI.Objects.Snippet
    case "Vulnerability": return GitLabAPI.Objects.Vulnerability
    case "WorkItemWidgetCurrentUserTodos": return GitLabAPI.Objects.WorkItemWidgetCurrentUserTodos
    case "WorkItemWidgetAssignees": return GitLabAPI.Objects.WorkItemWidgetAssignees
    case "WorkItemWidgetAwardEmoji": return GitLabAPI.Objects.WorkItemWidgetAwardEmoji
    case "WorkItemWidgetColor": return GitLabAPI.Objects.WorkItemWidgetColor
    case "WorkItemWidgetDescription": return GitLabAPI.Objects.WorkItemWidgetDescription
    case "WorkItemWidgetDesigns": return GitLabAPI.Objects.WorkItemWidgetDesigns
    case "WorkItemWidgetHealthStatus": return GitLabAPI.Objects.WorkItemWidgetHealthStatus
    case "WorkItemWidgetHierarchy": return GitLabAPI.Objects.WorkItemWidgetHierarchy
    case "WorkItemWidgetIteration": return GitLabAPI.Objects.WorkItemWidgetIteration
    case "WorkItemWidgetLabels": return GitLabAPI.Objects.WorkItemWidgetLabels
    case "WorkItemWidgetLinkedItems": return GitLabAPI.Objects.WorkItemWidgetLinkedItems
    case "WorkItemWidgetMilestone": return GitLabAPI.Objects.WorkItemWidgetMilestone
    case "WorkItemWidgetNotes": return GitLabAPI.Objects.WorkItemWidgetNotes
    case "WorkItemWidgetNotifications": return GitLabAPI.Objects.WorkItemWidgetNotifications
    case "WorkItemWidgetParticipants": return GitLabAPI.Objects.WorkItemWidgetParticipants
    case "WorkItemWidgetProgress": return GitLabAPI.Objects.WorkItemWidgetProgress
    case "WorkItemWidgetRequirementLegacy": return GitLabAPI.Objects.WorkItemWidgetRequirementLegacy
    case "WorkItemWidgetRolledupDates": return GitLabAPI.Objects.WorkItemWidgetRolledupDates
    case "WorkItemWidgetStartAndDueDate": return GitLabAPI.Objects.WorkItemWidgetStartAndDueDate
    case "WorkItemWidgetStatus": return GitLabAPI.Objects.WorkItemWidgetStatus
    case "WorkItemWidgetTestReports": return GitLabAPI.Objects.WorkItemWidgetTestReports
    case "WorkItemWidgetTimeTracking": return GitLabAPI.Objects.WorkItemWidgetTimeTracking
    case "WorkItemWidgetWeight": return GitLabAPI.Objects.WorkItemWidgetWeight
    case "SnippetConnection": return GitLabAPI.Objects.SnippetConnection
    case "SnippetPermissions": return GitLabAPI.Objects.SnippetPermissions
    case "SnippetBlobConnection": return GitLabAPI.Objects.SnippetBlobConnection
    case "SnippetBlob": return GitLabAPI.Objects.SnippetBlob
    case "NoteConnection": return GitLabAPI.Objects.NoteConnection
    case "Note": return GitLabAPI.Objects.Note
    case "Discussion": return GitLabAPI.Objects.Discussion
    case "DiffStatsSummary": return GitLabAPI.Objects.DiffStatsSummary
    case "MergeRequestPermissions": return GitLabAPI.Objects.MergeRequestPermissions
    case "MergeRequestAssigneeConnection": return GitLabAPI.Objects.MergeRequestAssigneeConnection
    case "MergeRequestReviewerConnection": return GitLabAPI.Objects.MergeRequestReviewerConnection
    case "LabelConnection": return GitLabAPI.Objects.LabelConnection
    case "Label": return GitLabAPI.Objects.Label
    case "Milestone": return GitLabAPI.Objects.Milestone
    case "Iteration": return GitLabAPI.Objects.Iteration
    case "ProjectMemberConnection": return GitLabAPI.Objects.ProjectMemberConnection
    case "ProjectMember": return GitLabAPI.Objects.ProjectMember
    case "GroupMember": return GitLabAPI.Objects.GroupMember
    case "PendingGroupMember": return GitLabAPI.Objects.PendingGroupMember
    case "Repository": return GitLabAPI.Objects.Repository
    case "RepositoryBlobConnection": return GitLabAPI.Objects.RepositoryBlobConnection
    case "RepositoryBlob": return GitLabAPI.Objects.RepositoryBlob
    case "Tree": return GitLabAPI.Objects.Tree
    case "GpgSignature": return GitLabAPI.Objects.GpgSignature
    case "SshSignature": return GitLabAPI.Objects.SshSignature
    case "X509Signature": return GitLabAPI.Objects.X509Signature
    case "PipelineConnection": return GitLabAPI.Objects.PipelineConnection
    case "Pipeline": return GitLabAPI.Objects.Pipeline
    case "RepositoryLanguage": return GitLabAPI.Objects.RepositoryLanguage
    case "ProjectPermissions": return GitLabAPI.Objects.ProjectPermissions
    case "GroupConnection": return GitLabAPI.Objects.GroupConnection
    case "Group": return GitLabAPI.Objects.Group
    case "AccessLevel": return GitLabAPI.Objects.AccessLevel
    case "GroupPermissions": return GitLabAPI.Objects.GroupPermissions
    case "IssueConnection": return GitLabAPI.Objects.IssueConnection
    case "IssuePermissions": return GitLabAPI.Objects.IssuePermissions
    case "UserCoreConnection": return GitLabAPI.Objects.UserCoreConnection
    default: return nil
    }
  }
}

public enum Objects {}
public enum Interfaces {}
public enum Unions {}
