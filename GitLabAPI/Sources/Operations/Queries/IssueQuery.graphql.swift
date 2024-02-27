// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class IssueQuery: GraphQLQuery {
  public static let operationName: String = "Issue"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query Issue($fullPath: ID!, $iid: String!) { project(fullPath: $fullPath) { __typename avatarUrl issue(iid: $iid) { __typename iid title description reference(full: true) state weight dueDate blockedByIssues { __typename nodes { __typename iid } } createdAt webUrl upvotes downvotes userNotesCount author { __typename avatarUrl name username } userPermissions { __typename updateIssue createNote } assignees { __typename nodes { __typename avatarUrl username } } labels { __typename nodes { __typename title color textColor } } milestone { __typename iid title } humanTimeEstimate humanTotalTimeSpent notes { __typename nodes { __typename id author { __typename avatarUrl username } maxAccessLevelOfAuthor createdAt body system internal resolved updatedAt systemNoteIconName systemNoteMetadata { __typename id } } } } } }"#
    ))

  public var fullPath: ID
  public var iid: String

  public init(
    fullPath: ID,
    iid: String
  ) {
    self.fullPath = fullPath
    self.iid = iid
  }

  public var __variables: Variables? { [
    "fullPath": fullPath,
    "iid": iid
  ] }

  public struct Data: GitLabAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("project", Project?.self, arguments: ["fullPath": .variable("fullPath")]),
    ] }

    /// Find a project.
    public var project: Project? { __data["project"] }

    /// Project
    ///
    /// Parent Type: `Project`
    public struct Project: GitLabAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.Project }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("avatarUrl", String?.self),
        .field("issue", Issue?.self, arguments: ["iid": .variable("iid")]),
      ] }

      /// URL to avatar image file of the project.
      public var avatarUrl: String? { __data["avatarUrl"] }
      /// A single issue of the project.
      public var issue: Issue? { __data["issue"] }

      /// Project.Issue
      ///
      /// Parent Type: `Issue`
      public struct Issue: GitLabAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.Issue }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("iid", GitLabAPI.ID.self),
          .field("title", String.self),
          .field("description", String?.self),
          .field("reference", String.self, arguments: ["full": true]),
          .field("state", GraphQLEnum<GitLabAPI.IssueState>.self),
          .field("weight", Int?.self),
          .field("dueDate", GitLabAPI.Time?.self),
          .field("blockedByIssues", BlockedByIssues?.self),
          .field("createdAt", GitLabAPI.Time.self),
          .field("webUrl", String.self),
          .field("upvotes", Int.self),
          .field("downvotes", Int.self),
          .field("userNotesCount", Int.self),
          .field("author", Author.self),
          .field("userPermissions", UserPermissions.self),
          .field("assignees", Assignees?.self),
          .field("labels", Labels?.self),
          .field("milestone", Milestone?.self),
          .field("humanTimeEstimate", String?.self),
          .field("humanTotalTimeSpent", String?.self),
          .field("notes", Notes.self),
        ] }

        /// Internal ID of the issue.
        public var iid: GitLabAPI.ID { __data["iid"] }
        /// Title of the issue.
        public var title: String { __data["title"] }
        /// Description of the issue.
        public var description: String? { __data["description"] }
        /// Internal reference of the issue. Returned in shortened format by default.
        public var reference: String { __data["reference"] }
        /// State of the issue.
        public var state: GraphQLEnum<GitLabAPI.IssueState> { __data["state"] }
        /// Weight of the issue.
        public var weight: Int? { __data["weight"] }
        /// Due date of the issue.
        public var dueDate: GitLabAPI.Time? { __data["dueDate"] }
        /// Issues blocking this issue.
        public var blockedByIssues: BlockedByIssues? { __data["blockedByIssues"] }
        /// Timestamp of when the issue was created.
        public var createdAt: GitLabAPI.Time { __data["createdAt"] }
        /// Web URL of the issue.
        public var webUrl: String { __data["webUrl"] }
        /// Number of upvotes the issue has received.
        public var upvotes: Int { __data["upvotes"] }
        /// Number of downvotes the issue has received.
        public var downvotes: Int { __data["downvotes"] }
        /// Number of user notes of the issue.
        public var userNotesCount: Int { __data["userNotesCount"] }
        /// User that created the issue.
        public var author: Author { __data["author"] }
        /// Permissions for the current user on the resource
        public var userPermissions: UserPermissions { __data["userPermissions"] }
        /// Assignees of the issue.
        public var assignees: Assignees? { __data["assignees"] }
        /// Labels of the issue.
        public var labels: Labels? { __data["labels"] }
        /// Milestone of the issue.
        public var milestone: Milestone? { __data["milestone"] }
        /// Human-readable time estimate of the issue.
        public var humanTimeEstimate: String? { __data["humanTimeEstimate"] }
        /// Human-readable total time reported as spent on the issue.
        public var humanTotalTimeSpent: String? { __data["humanTotalTimeSpent"] }
        /// All notes on this noteable.
        public var notes: Notes { __data["notes"] }

        /// Project.Issue.BlockedByIssues
        ///
        /// Parent Type: `IssueConnection`
        public struct BlockedByIssues: GitLabAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.IssueConnection }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("nodes", [Node?]?.self),
          ] }

          /// A list of nodes.
          public var nodes: [Node?]? { __data["nodes"] }

          /// Project.Issue.BlockedByIssues.Node
          ///
          /// Parent Type: `Issue`
          public struct Node: GitLabAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.Issue }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("iid", GitLabAPI.ID.self),
            ] }

            /// Internal ID of the issue.
            public var iid: GitLabAPI.ID { __data["iid"] }
          }
        }

        /// Project.Issue.Author
        ///
        /// Parent Type: `UserCore`
        public struct Author: GitLabAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.UserCore }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("avatarUrl", String?.self),
            .field("name", String.self),
            .field("username", String.self),
          ] }

          /// URL of the user's avatar.
          public var avatarUrl: String? { __data["avatarUrl"] }
          /// Human-readable name of the user. Returns `****` if the user is a project bot and the requester does not have permission to view the project.
          public var name: String { __data["name"] }
          /// Username of the user. Unique within this instance of GitLab.
          public var username: String { __data["username"] }
        }

        /// Project.Issue.UserPermissions
        ///
        /// Parent Type: `IssuePermissions`
        public struct UserPermissions: GitLabAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.IssuePermissions }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("updateIssue", Bool.self),
            .field("createNote", Bool.self),
          ] }

          /// If `true`, the user can perform `update_issue` on this resource
          public var updateIssue: Bool { __data["updateIssue"] }
          /// If `true`, the user can perform `create_note` on this resource
          public var createNote: Bool { __data["createNote"] }
        }

        /// Project.Issue.Assignees
        ///
        /// Parent Type: `UserCoreConnection`
        public struct Assignees: GitLabAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.UserCoreConnection }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("nodes", [Node?]?.self),
          ] }

          /// A list of nodes.
          public var nodes: [Node?]? { __data["nodes"] }

          /// Project.Issue.Assignees.Node
          ///
          /// Parent Type: `UserCore`
          public struct Node: GitLabAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.UserCore }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("avatarUrl", String?.self),
              .field("username", String.self),
            ] }

            /// URL of the user's avatar.
            public var avatarUrl: String? { __data["avatarUrl"] }
            /// Username of the user. Unique within this instance of GitLab.
            public var username: String { __data["username"] }
          }
        }

        /// Project.Issue.Labels
        ///
        /// Parent Type: `LabelConnection`
        public struct Labels: GitLabAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.LabelConnection }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("nodes", [Node?]?.self),
          ] }

          /// A list of nodes.
          public var nodes: [Node?]? { __data["nodes"] }

          /// Project.Issue.Labels.Node
          ///
          /// Parent Type: `Label`
          public struct Node: GitLabAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.Label }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("title", String.self),
              .field("color", String.self),
              .field("textColor", String.self),
            ] }

            /// Content of the label.
            public var title: String { __data["title"] }
            /// Background color of the label.
            public var color: String { __data["color"] }
            /// Text color of the label.
            public var textColor: String { __data["textColor"] }
          }
        }

        /// Project.Issue.Milestone
        ///
        /// Parent Type: `Milestone`
        public struct Milestone: GitLabAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.Milestone }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("iid", GitLabAPI.ID.self),
            .field("title", String.self),
          ] }

          /// Internal ID of the milestone.
          public var iid: GitLabAPI.ID { __data["iid"] }
          /// Title of the milestone.
          public var title: String { __data["title"] }
        }

        /// Project.Issue.Notes
        ///
        /// Parent Type: `NoteConnection`
        public struct Notes: GitLabAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.NoteConnection }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("nodes", [Node?]?.self),
          ] }

          /// A list of nodes.
          public var nodes: [Node?]? { __data["nodes"] }

          /// Project.Issue.Notes.Node
          ///
          /// Parent Type: `Note`
          public struct Node: GitLabAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.Note }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("id", GitLabAPI.NoteID.self),
              .field("author", Author?.self),
              .field("maxAccessLevelOfAuthor", String?.self),
              .field("createdAt", GitLabAPI.Time.self),
              .field("body", String.self),
              .field("system", Bool.self),
              .field("internal", Bool?.self),
              .field("resolved", Bool.self),
              .field("updatedAt", GitLabAPI.Time.self),
              .field("systemNoteIconName", String?.self),
              .field("systemNoteMetadata", SystemNoteMetadata?.self),
            ] }

            /// ID of the note.
            public var id: GitLabAPI.NoteID { __data["id"] }
            /// User who wrote this note.
            public var author: Author? { __data["author"] }
            /// Max access level of the note author in the project.
            public var maxAccessLevelOfAuthor: String? { __data["maxAccessLevelOfAuthor"] }
            /// Timestamp of the note creation.
            public var createdAt: GitLabAPI.Time { __data["createdAt"] }
            /// Content of the note.
            public var body: String { __data["body"] }
            /// Indicates whether this note was created by the system or by a user.
            public var system: Bool { __data["system"] }
            /// Indicates if this note is internal.
            public var `internal`: Bool? { __data["internal"] }
            /// Indicates if the object is resolved.
            public var resolved: Bool { __data["resolved"] }
            /// Timestamp of the note's last activity.
            public var updatedAt: GitLabAPI.Time { __data["updatedAt"] }
            /// Name of the icon corresponding to a system note.
            public var systemNoteIconName: String? { __data["systemNoteIconName"] }
            /// Metadata for the given note if it is a system note.
            public var systemNoteMetadata: SystemNoteMetadata? { __data["systemNoteMetadata"] }

            /// Project.Issue.Notes.Node.Author
            ///
            /// Parent Type: `UserCore`
            public struct Author: GitLabAPI.SelectionSet {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.UserCore }
              public static var __selections: [ApolloAPI.Selection] { [
                .field("__typename", String.self),
                .field("avatarUrl", String?.self),
                .field("username", String.self),
              ] }

              /// URL of the user's avatar.
              public var avatarUrl: String? { __data["avatarUrl"] }
              /// Username of the user. Unique within this instance of GitLab.
              public var username: String { __data["username"] }
            }

            /// Project.Issue.Notes.Node.SystemNoteMetadata
            ///
            /// Parent Type: `SystemNoteMetadata`
            public struct SystemNoteMetadata: GitLabAPI.SelectionSet {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.SystemNoteMetadata }
              public static var __selections: [ApolloAPI.Selection] { [
                .field("__typename", String.self),
                .field("id", GitLabAPI.SystemNoteMetadataID.self),
              ] }

              /// Global ID of the specific system note metadata.
              public var id: GitLabAPI.SystemNoteMetadataID { __data["id"] }
            }
          }
        }
      }
    }
  }
}
