// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public protocol SelectionSet: ApolloAPI.SelectionSet & ApolloAPI.RootSelectionSet
where Schema == GitLabAPI.SchemaMetadata {}

public protocol InlineFragment: ApolloAPI.SelectionSet & ApolloAPI.InlineFragment
where Schema == GitLabAPI.SchemaMetadata {}

public protocol MutableSelectionSet: ApolloAPI.MutableRootSelectionSet
where Schema == GitLabAPI.SchemaMetadata {}

public protocol MutableInlineFragment: ApolloAPI.MutableSelectionSet & ApolloAPI.InlineFragment
where Schema == GitLabAPI.SchemaMetadata {}

public enum SchemaMetadata: ApolloAPI.SchemaMetadata {
  public static let configuration: any ApolloAPI.SchemaConfiguration.Type = SchemaConfiguration.self

  public static func objectType(forTypename typename: String) -> ApolloAPI.Object? {
    switch typename {
    case "AbuseReportDiscussion": return GitLabAPI.Objects.AbuseReportDiscussion
    case "AbuseReportLabel": return GitLabAPI.Objects.AbuseReportLabel
    case "AbuseReportNote": return GitLabAPI.Objects.AbuseReportNote
    case "AccessLevel": return GitLabAPI.Objects.AccessLevel
    case "AddOnUser": return GitLabAPI.Objects.AddOnUser
    case "AlertManagementAlert": return GitLabAPI.Objects.AlertManagementAlert
    case "AutocompletedUser": return GitLabAPI.Objects.AutocompletedUser
    case "Blob": return GitLabAPI.Objects.Blob
    case "BlobConnection": return GitLabAPI.Objects.BlobConnection
    case "BoardEpic": return GitLabAPI.Objects.BoardEpic
    case "Commit": return GitLabAPI.Objects.Commit
    case "CommitConnection": return GitLabAPI.Objects.CommitConnection
    case "CountableVulnerability": return GitLabAPI.Objects.CountableVulnerability
    case "CurrentUser": return GitLabAPI.Objects.CurrentUser
    case "CustomEmoji": return GitLabAPI.Objects.CustomEmoji
    case "CustomEmojiConnection": return GitLabAPI.Objects.CustomEmojiConnection
    case "Design": return GitLabAPI.Objects.Design
    case "DesignAtVersion": return GitLabAPI.Objects.DesignAtVersion
    case "DiffStats": return GitLabAPI.Objects.DiffStats
    case "DiffStatsSummary": return GitLabAPI.Objects.DiffStatsSummary
    case "Discussion": return GitLabAPI.Objects.Discussion
    case "Epic": return GitLabAPI.Objects.Epic
    case "EpicConnection": return GitLabAPI.Objects.EpicConnection
    case "EpicIssue": return GitLabAPI.Objects.EpicIssue
    case "EpicIssueConnection": return GitLabAPI.Objects.EpicIssueConnection
    case "EpicPermissions": return GitLabAPI.Objects.EpicPermissions
    case "GpgSignature": return GitLabAPI.Objects.GpgSignature
    case "Group": return GitLabAPI.Objects.Group
    case "GroupConnection": return GitLabAPI.Objects.GroupConnection
    case "GroupMember": return GitLabAPI.Objects.GroupMember
    case "GroupMemberConnection": return GitLabAPI.Objects.GroupMemberConnection
    case "GroupMinimalAccess": return GitLabAPI.Objects.GroupMinimalAccess
    case "GroupPermissions": return GitLabAPI.Objects.GroupPermissions
    case "Issue": return GitLabAPI.Objects.Issue
    case "IssueConnection": return GitLabAPI.Objects.IssueConnection
    case "IssuePermissions": return GitLabAPI.Objects.IssuePermissions
    case "Iteration": return GitLabAPI.Objects.Iteration
    case "Key": return GitLabAPI.Objects.Key
    case "Label": return GitLabAPI.Objects.Label
    case "LabelConnection": return GitLabAPI.Objects.LabelConnection
    case "MemberInterfaceConnection": return GitLabAPI.Objects.MemberInterfaceConnection
    case "MergeRequest": return GitLabAPI.Objects.MergeRequest
    case "MergeRequestAssignee": return GitLabAPI.Objects.MergeRequestAssignee
    case "MergeRequestAssigneeConnection": return GitLabAPI.Objects.MergeRequestAssigneeConnection
    case "MergeRequestAuthor": return GitLabAPI.Objects.MergeRequestAuthor
    case "MergeRequestConnection": return GitLabAPI.Objects.MergeRequestConnection
    case "MergeRequestParticipant": return GitLabAPI.Objects.MergeRequestParticipant
    case "MergeRequestPermissions": return GitLabAPI.Objects.MergeRequestPermissions
    case "MergeRequestReviewer": return GitLabAPI.Objects.MergeRequestReviewer
    case "MergeRequestReviewerConnection": return GitLabAPI.Objects.MergeRequestReviewerConnection
    case "Milestone": return GitLabAPI.Objects.Milestone
    case "MilestoneConnection": return GitLabAPI.Objects.MilestoneConnection
    case "MilestoneStats": return GitLabAPI.Objects.MilestoneStats
    case "Namespace": return GitLabAPI.Objects.Namespace
    case "Note": return GitLabAPI.Objects.Note
    case "NoteConnection": return GitLabAPI.Objects.NoteConnection
    case "PendingGroupMember": return GitLabAPI.Objects.PendingGroupMember
    case "PendingProjectMember": return GitLabAPI.Objects.PendingProjectMember
    case "Pipeline": return GitLabAPI.Objects.Pipeline
    case "PipelineConnection": return GitLabAPI.Objects.PipelineConnection
    case "PipelineMinimalAccess": return GitLabAPI.Objects.PipelineMinimalAccess
    case "Project": return GitLabAPI.Objects.Project
    case "ProjectComplianceViolation": return GitLabAPI.Objects.ProjectComplianceViolation
    case "ProjectConnection": return GitLabAPI.Objects.ProjectConnection
    case "ProjectMember": return GitLabAPI.Objects.ProjectMember
    case "ProjectMemberConnection": return GitLabAPI.Objects.ProjectMemberConnection
    case "ProjectMinimalAccess": return GitLabAPI.Objects.ProjectMinimalAccess
    case "ProjectPermissions": return GitLabAPI.Objects.ProjectPermissions
    case "Query": return GitLabAPI.Objects.Query
    case "Release": return GitLabAPI.Objects.Release
    case "ReleaseAssetLink": return GitLabAPI.Objects.ReleaseAssetLink
    case "ReleaseAssetLinkConnection": return GitLabAPI.Objects.ReleaseAssetLinkConnection
    case "ReleaseAssets": return GitLabAPI.Objects.ReleaseAssets
    case "ReleaseConnection": return GitLabAPI.Objects.ReleaseConnection
    case "ReleaseSource": return GitLabAPI.Objects.ReleaseSource
    case "ReleaseSourceConnection": return GitLabAPI.Objects.ReleaseSourceConnection
    case "Repository": return GitLabAPI.Objects.Repository
    case "RepositoryBlob": return GitLabAPI.Objects.RepositoryBlob
    case "RepositoryBlobConnection": return GitLabAPI.Objects.RepositoryBlobConnection
    case "RepositoryLanguage": return GitLabAPI.Objects.RepositoryLanguage
    case "Snippet": return GitLabAPI.Objects.Snippet
    case "SnippetBlob": return GitLabAPI.Objects.SnippetBlob
    case "SnippetBlobConnection": return GitLabAPI.Objects.SnippetBlobConnection
    case "SnippetConnection": return GitLabAPI.Objects.SnippetConnection
    case "SnippetPermissions": return GitLabAPI.Objects.SnippetPermissions
    case "SshSignature": return GitLabAPI.Objects.SshSignature
    case "Submodule": return GitLabAPI.Objects.Submodule
    case "Timelog": return GitLabAPI.Objects.Timelog
    case "TimelogConnection": return GitLabAPI.Objects.TimelogConnection
    case "Todo": return GitLabAPI.Objects.Todo
    case "TodoConnection": return GitLabAPI.Objects.TodoConnection
    case "Tree": return GitLabAPI.Objects.Tree
    case "TreeEntry": return GitLabAPI.Objects.TreeEntry
    case "TreeEntryConnection": return GitLabAPI.Objects.TreeEntryConnection
    case "UserCore": return GitLabAPI.Objects.UserCore
    case "UserCoreConnection": return GitLabAPI.Objects.UserCoreConnection
    case "UserStatus": return GitLabAPI.Objects.UserStatus
    case "Vulnerability": return GitLabAPI.Objects.Vulnerability
    case "WikiPage": return GitLabAPI.Objects.WikiPage
    case "WorkItem": return GitLabAPI.Objects.WorkItem
    case "WorkItemWidgetAssignees": return GitLabAPI.Objects.WorkItemWidgetAssignees
    case "WorkItemWidgetAwardEmoji": return GitLabAPI.Objects.WorkItemWidgetAwardEmoji
    case "WorkItemWidgetColor": return GitLabAPI.Objects.WorkItemWidgetColor
    case "WorkItemWidgetCrmContacts": return GitLabAPI.Objects.WorkItemWidgetCrmContacts
    case "WorkItemWidgetCurrentUserTodos": return GitLabAPI.Objects.WorkItemWidgetCurrentUserTodos
    case "WorkItemWidgetCustomFields": return GitLabAPI.Objects.WorkItemWidgetCustomFields
    case "WorkItemWidgetDescription": return GitLabAPI.Objects.WorkItemWidgetDescription
    case "WorkItemWidgetDesigns": return GitLabAPI.Objects.WorkItemWidgetDesigns
    case "WorkItemWidgetDevelopment": return GitLabAPI.Objects.WorkItemWidgetDevelopment
    case "WorkItemWidgetEmailParticipants": return GitLabAPI.Objects.WorkItemWidgetEmailParticipants
    case "WorkItemWidgetErrorTracking": return GitLabAPI.Objects.WorkItemWidgetErrorTracking
    case "WorkItemWidgetHealthStatus": return GitLabAPI.Objects.WorkItemWidgetHealthStatus
    case "WorkItemWidgetHierarchy": return GitLabAPI.Objects.WorkItemWidgetHierarchy
    case "WorkItemWidgetIteration": return GitLabAPI.Objects.WorkItemWidgetIteration
    case "WorkItemWidgetLabels": return GitLabAPI.Objects.WorkItemWidgetLabels
    case "WorkItemWidgetLinkedItems": return GitLabAPI.Objects.WorkItemWidgetLinkedItems
    case "WorkItemWidgetLinkedResources": return GitLabAPI.Objects.WorkItemWidgetLinkedResources
    case "WorkItemWidgetMilestone": return GitLabAPI.Objects.WorkItemWidgetMilestone
    case "WorkItemWidgetNotes": return GitLabAPI.Objects.WorkItemWidgetNotes
    case "WorkItemWidgetNotifications": return GitLabAPI.Objects.WorkItemWidgetNotifications
    case "WorkItemWidgetParticipants": return GitLabAPI.Objects.WorkItemWidgetParticipants
    case "WorkItemWidgetProgress": return GitLabAPI.Objects.WorkItemWidgetProgress
    case "WorkItemWidgetRequirementLegacy": return GitLabAPI.Objects.WorkItemWidgetRequirementLegacy
    case "WorkItemWidgetStartAndDueDate": return GitLabAPI.Objects.WorkItemWidgetStartAndDueDate
    case "WorkItemWidgetStatus": return GitLabAPI.Objects.WorkItemWidgetStatus
    case "WorkItemWidgetTestReports": return GitLabAPI.Objects.WorkItemWidgetTestReports
    case "WorkItemWidgetTimeTracking": return GitLabAPI.Objects.WorkItemWidgetTimeTracking
    case "WorkItemWidgetVerificationStatus": return GitLabAPI.Objects.WorkItemWidgetVerificationStatus
    case "WorkItemWidgetVulnerabilities": return GitLabAPI.Objects.WorkItemWidgetVulnerabilities
    case "WorkItemWidgetWeight": return GitLabAPI.Objects.WorkItemWidgetWeight
    case "X509Signature": return GitLabAPI.Objects.X509Signature
    default: return nil
    }
  }
}

public enum Objects {}
public enum Interfaces {}
public enum Unions {}
