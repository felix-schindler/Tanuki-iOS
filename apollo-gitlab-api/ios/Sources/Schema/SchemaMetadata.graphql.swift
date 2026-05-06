// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

nonisolated public protocol SelectionSet: ApolloAPI.SelectionSet & ApolloAPI.RootSelectionSet
where Schema == IOSGitLabAPI.SchemaMetadata {}

nonisolated public protocol InlineFragment: ApolloAPI.SelectionSet & ApolloAPI.InlineFragment
where Schema == IOSGitLabAPI.SchemaMetadata {}

nonisolated public protocol MutableSelectionSet: ApolloAPI.MutableRootSelectionSet
where Schema == IOSGitLabAPI.SchemaMetadata {}

nonisolated public protocol MutableInlineFragment: ApolloAPI.MutableSelectionSet & ApolloAPI.InlineFragment
where Schema == IOSGitLabAPI.SchemaMetadata {}

nonisolated public enum SchemaMetadata: ApolloAPI.SchemaMetadata {
  public static let configuration: any ApolloAPI.SchemaConfiguration.Type = SchemaConfiguration.self

  private static let objectTypeMap: [String: ApolloAPI.Object] = [
    "AccessLevel": IOSGitLabAPI.Objects.AccessLevel,
    "AddOnUser": IOSGitLabAPI.Objects.AddOnUser,
    "AlertManagementAlert": IOSGitLabAPI.Objects.AlertManagementAlert,
    "AutocompletedUser": IOSGitLabAPI.Objects.AutocompletedUser,
    "Blob": IOSGitLabAPI.Objects.Blob,
    "BlobConnection": IOSGitLabAPI.Objects.BlobConnection,
    "BoardEpic": IOSGitLabAPI.Objects.BoardEpic,
    "Commit": IOSGitLabAPI.Objects.Commit,
    "CommitConnection": IOSGitLabAPI.Objects.CommitConnection,
    "CountableVulnerability": IOSGitLabAPI.Objects.CountableVulnerability,
    "CurrentUser": IOSGitLabAPI.Objects.CurrentUser,
    "CustomEmoji": IOSGitLabAPI.Objects.CustomEmoji,
    "CustomEmojiConnection": IOSGitLabAPI.Objects.CustomEmojiConnection,
    "Design": IOSGitLabAPI.Objects.Design,
    "DesignAtVersion": IOSGitLabAPI.Objects.DesignAtVersion,
    "DiffStats": IOSGitLabAPI.Objects.DiffStats,
    "DiffStatsSummary": IOSGitLabAPI.Objects.DiffStatsSummary,
    "Discussion": IOSGitLabAPI.Objects.Discussion,
    "DuoWorkflow": IOSGitLabAPI.Objects.DuoWorkflow,
    "Epic": IOSGitLabAPI.Objects.Epic,
    "EpicConnection": IOSGitLabAPI.Objects.EpicConnection,
    "EpicIssue": IOSGitLabAPI.Objects.EpicIssue,
    "EpicIssueConnection": IOSGitLabAPI.Objects.EpicIssueConnection,
    "EpicPermissions": IOSGitLabAPI.Objects.EpicPermissions,
    "GpgSignature": IOSGitLabAPI.Objects.GpgSignature,
    "Group": IOSGitLabAPI.Objects.Group,
    "GroupConnection": IOSGitLabAPI.Objects.GroupConnection,
    "GroupMember": IOSGitLabAPI.Objects.GroupMember,
    "GroupMemberConnection": IOSGitLabAPI.Objects.GroupMemberConnection,
    "GroupMinimalAccess": IOSGitLabAPI.Objects.GroupMinimalAccess,
    "GroupPermissions": IOSGitLabAPI.Objects.GroupPermissions,
    "Issue": IOSGitLabAPI.Objects.Issue,
    "IssueConnection": IOSGitLabAPI.Objects.IssueConnection,
    "IssuePermissions": IOSGitLabAPI.Objects.IssuePermissions,
    "Iteration": IOSGitLabAPI.Objects.Iteration,
    "Key": IOSGitLabAPI.Objects.Key,
    "Label": IOSGitLabAPI.Objects.Label,
    "LabelConnection": IOSGitLabAPI.Objects.LabelConnection,
    "MemberInterfaceConnection": IOSGitLabAPI.Objects.MemberInterfaceConnection,
    "MergeRequest": IOSGitLabAPI.Objects.MergeRequest,
    "MergeRequestAssignee": IOSGitLabAPI.Objects.MergeRequestAssignee,
    "MergeRequestAssigneeConnection": IOSGitLabAPI.Objects.MergeRequestAssigneeConnection,
    "MergeRequestAuthor": IOSGitLabAPI.Objects.MergeRequestAuthor,
    "MergeRequestConnection": IOSGitLabAPI.Objects.MergeRequestConnection,
    "MergeRequestParticipant": IOSGitLabAPI.Objects.MergeRequestParticipant,
    "MergeRequestPermissions": IOSGitLabAPI.Objects.MergeRequestPermissions,
    "MergeRequestReviewer": IOSGitLabAPI.Objects.MergeRequestReviewer,
    "MergeRequestReviewerConnection": IOSGitLabAPI.Objects.MergeRequestReviewerConnection,
    "Milestone": IOSGitLabAPI.Objects.Milestone,
    "MilestoneConnection": IOSGitLabAPI.Objects.MilestoneConnection,
    "MilestoneStats": IOSGitLabAPI.Objects.MilestoneStats,
    "Mutation": IOSGitLabAPI.Objects.Mutation,
    "Namespace": IOSGitLabAPI.Objects.Namespace,
    "Note": IOSGitLabAPI.Objects.Note,
    "NoteConnection": IOSGitLabAPI.Objects.NoteConnection,
    "PendingGroupMember": IOSGitLabAPI.Objects.PendingGroupMember,
    "PendingProjectMember": IOSGitLabAPI.Objects.PendingProjectMember,
    "Pipeline": IOSGitLabAPI.Objects.Pipeline,
    "PipelineConnection": IOSGitLabAPI.Objects.PipelineConnection,
    "PipelineMinimalAccess": IOSGitLabAPI.Objects.PipelineMinimalAccess,
    "Project": IOSGitLabAPI.Objects.Project,
    "ProjectComplianceViolation": IOSGitLabAPI.Objects.ProjectComplianceViolation,
    "ProjectConnection": IOSGitLabAPI.Objects.ProjectConnection,
    "ProjectMember": IOSGitLabAPI.Objects.ProjectMember,
    "ProjectMemberConnection": IOSGitLabAPI.Objects.ProjectMemberConnection,
    "ProjectMinimalAccess": IOSGitLabAPI.Objects.ProjectMinimalAccess,
    "ProjectPermissions": IOSGitLabAPI.Objects.ProjectPermissions,
    "Query": IOSGitLabAPI.Objects.Query,
    "Release": IOSGitLabAPI.Objects.Release,
    "ReleaseAssetLink": IOSGitLabAPI.Objects.ReleaseAssetLink,
    "ReleaseAssetLinkConnection": IOSGitLabAPI.Objects.ReleaseAssetLinkConnection,
    "ReleaseAssets": IOSGitLabAPI.Objects.ReleaseAssets,
    "ReleaseConnection": IOSGitLabAPI.Objects.ReleaseConnection,
    "ReleaseSource": IOSGitLabAPI.Objects.ReleaseSource,
    "ReleaseSourceConnection": IOSGitLabAPI.Objects.ReleaseSourceConnection,
    "Repository": IOSGitLabAPI.Objects.Repository,
    "RepositoryBlob": IOSGitLabAPI.Objects.RepositoryBlob,
    "RepositoryBlobConnection": IOSGitLabAPI.Objects.RepositoryBlobConnection,
    "RepositoryLanguage": IOSGitLabAPI.Objects.RepositoryLanguage,
    "Snippet": IOSGitLabAPI.Objects.Snippet,
    "SnippetBlob": IOSGitLabAPI.Objects.SnippetBlob,
    "SnippetBlobConnection": IOSGitLabAPI.Objects.SnippetBlobConnection,
    "SnippetConnection": IOSGitLabAPI.Objects.SnippetConnection,
    "SnippetPermissions": IOSGitLabAPI.Objects.SnippetPermissions,
    "SshSignature": IOSGitLabAPI.Objects.SshSignature,
    "StarProjectPayload": IOSGitLabAPI.Objects.StarProjectPayload,
    "Submodule": IOSGitLabAPI.Objects.Submodule,
    "Timelog": IOSGitLabAPI.Objects.Timelog,
    "TimelogConnection": IOSGitLabAPI.Objects.TimelogConnection,
    "Todo": IOSGitLabAPI.Objects.Todo,
    "TodoConnection": IOSGitLabAPI.Objects.TodoConnection,
    "Tree": IOSGitLabAPI.Objects.Tree,
    "TreeEntry": IOSGitLabAPI.Objects.TreeEntry,
    "TreeEntryConnection": IOSGitLabAPI.Objects.TreeEntryConnection,
    "UpdateIssuePayload": IOSGitLabAPI.Objects.UpdateIssuePayload,
    "UserCore": IOSGitLabAPI.Objects.UserCore,
    "UserCoreConnection": IOSGitLabAPI.Objects.UserCoreConnection,
    "UserStatus": IOSGitLabAPI.Objects.UserStatus,
    "Vulnerability": IOSGitLabAPI.Objects.Vulnerability,
    "WikiPage": IOSGitLabAPI.Objects.WikiPage,
    "WorkItem": IOSGitLabAPI.Objects.WorkItem,
    "WorkItemWidgetAiSession": IOSGitLabAPI.Objects.WorkItemWidgetAiSession,
    "WorkItemWidgetAssignees": IOSGitLabAPI.Objects.WorkItemWidgetAssignees,
    "WorkItemWidgetAwardEmoji": IOSGitLabAPI.Objects.WorkItemWidgetAwardEmoji,
    "WorkItemWidgetColor": IOSGitLabAPI.Objects.WorkItemWidgetColor,
    "WorkItemWidgetCrmContacts": IOSGitLabAPI.Objects.WorkItemWidgetCrmContacts,
    "WorkItemWidgetCurrentUserTodos": IOSGitLabAPI.Objects.WorkItemWidgetCurrentUserTodos,
    "WorkItemWidgetCustomFields": IOSGitLabAPI.Objects.WorkItemWidgetCustomFields,
    "WorkItemWidgetDescription": IOSGitLabAPI.Objects.WorkItemWidgetDescription,
    "WorkItemWidgetDesigns": IOSGitLabAPI.Objects.WorkItemWidgetDesigns,
    "WorkItemWidgetDevelopment": IOSGitLabAPI.Objects.WorkItemWidgetDevelopment,
    "WorkItemWidgetEmailParticipants": IOSGitLabAPI.Objects.WorkItemWidgetEmailParticipants,
    "WorkItemWidgetErrorTracking": IOSGitLabAPI.Objects.WorkItemWidgetErrorTracking,
    "WorkItemWidgetHealthStatus": IOSGitLabAPI.Objects.WorkItemWidgetHealthStatus,
    "WorkItemWidgetHierarchy": IOSGitLabAPI.Objects.WorkItemWidgetHierarchy,
    "WorkItemWidgetIteration": IOSGitLabAPI.Objects.WorkItemWidgetIteration,
    "WorkItemWidgetLabels": IOSGitLabAPI.Objects.WorkItemWidgetLabels,
    "WorkItemWidgetLinkedItems": IOSGitLabAPI.Objects.WorkItemWidgetLinkedItems,
    "WorkItemWidgetLinkedResources": IOSGitLabAPI.Objects.WorkItemWidgetLinkedResources,
    "WorkItemWidgetMilestone": IOSGitLabAPI.Objects.WorkItemWidgetMilestone,
    "WorkItemWidgetNotes": IOSGitLabAPI.Objects.WorkItemWidgetNotes,
    "WorkItemWidgetNotifications": IOSGitLabAPI.Objects.WorkItemWidgetNotifications,
    "WorkItemWidgetParticipants": IOSGitLabAPI.Objects.WorkItemWidgetParticipants,
    "WorkItemWidgetProgress": IOSGitLabAPI.Objects.WorkItemWidgetProgress,
    "WorkItemWidgetRequirementLegacy": IOSGitLabAPI.Objects.WorkItemWidgetRequirementLegacy,
    "WorkItemWidgetStartAndDueDate": IOSGitLabAPI.Objects.WorkItemWidgetStartAndDueDate,
    "WorkItemWidgetStatus": IOSGitLabAPI.Objects.WorkItemWidgetStatus,
    "WorkItemWidgetTestReports": IOSGitLabAPI.Objects.WorkItemWidgetTestReports,
    "WorkItemWidgetTimeTracking": IOSGitLabAPI.Objects.WorkItemWidgetTimeTracking,
    "WorkItemWidgetVerificationStatus": IOSGitLabAPI.Objects.WorkItemWidgetVerificationStatus,
    "WorkItemWidgetVulnerabilities": IOSGitLabAPI.Objects.WorkItemWidgetVulnerabilities,
    "WorkItemWidgetWeight": IOSGitLabAPI.Objects.WorkItemWidgetWeight,
    "X509Signature": IOSGitLabAPI.Objects.X509Signature
  ]

  @_spi(Execution) public static func objectType(forTypename typename: String) -> ApolloAPI.Object? {
    objectTypeMap[typename]
  }
}

nonisolated public enum Objects {}
nonisolated public enum Interfaces {}
nonisolated public enum Unions {}
