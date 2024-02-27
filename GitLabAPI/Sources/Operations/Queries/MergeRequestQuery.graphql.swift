// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class MergeRequestQuery: GraphQLQuery {
  public static let operationName: String = "MergeRequest"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query MergeRequest($fullPath: ID!, $iid: String!) { project(fullPath: $fullPath) { __typename avatarUrl mergeRequest(iid: $iid) { __typename iid title description reference(full: true) state sourceBranch targetBranch sourceProject { __typename fullPath } upvotes downvotes author { __typename avatarUrl name username } userPermissions { __typename canMerge createNote } createdAt webUrl mergeStatusEnum detailedMergeStatus reviewers { __typename nodes { __typename avatarUrl username } } notes { __typename nodes { __typename id author { __typename avatarUrl username } maxAccessLevelOfAuthor createdAt body system internal resolved updatedAt systemNoteIconName systemNoteMetadata { __typename id } } } } } }"#
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
        .field("mergeRequest", MergeRequest?.self, arguments: ["iid": .variable("iid")]),
      ] }

      /// URL to avatar image file of the project.
      public var avatarUrl: String? { __data["avatarUrl"] }
      /// A single merge request of the project.
      public var mergeRequest: MergeRequest? { __data["mergeRequest"] }

      /// Project.MergeRequest
      ///
      /// Parent Type: `MergeRequest`
      public struct MergeRequest: GitLabAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.MergeRequest }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("iid", String.self),
          .field("title", String.self),
          .field("description", String?.self),
          .field("reference", String.self, arguments: ["full": true]),
          .field("state", GraphQLEnum<GitLabAPI.MergeRequestState>.self),
          .field("sourceBranch", String.self),
          .field("targetBranch", String.self),
          .field("sourceProject", SourceProject?.self),
          .field("upvotes", Int.self),
          .field("downvotes", Int.self),
          .field("author", Author?.self),
          .field("userPermissions", UserPermissions.self),
          .field("createdAt", GitLabAPI.Time.self),
          .field("webUrl", String?.self),
          .field("mergeStatusEnum", GraphQLEnum<GitLabAPI.MergeStatus>?.self),
          .field("detailedMergeStatus", GraphQLEnum<GitLabAPI.DetailedMergeStatus>?.self),
          .field("reviewers", Reviewers?.self),
          .field("notes", Notes.self),
        ] }

        /// Internal ID of the merge request.
        public var iid: String { __data["iid"] }
        /// Title of the merge request.
        public var title: String { __data["title"] }
        /// Description of the merge request (Markdown rendered as HTML for caching).
        public var description: String? { __data["description"] }
        /// Internal reference of the merge request. Returned in shortened format by default.
        public var reference: String { __data["reference"] }
        /// State of the merge request.
        public var state: GraphQLEnum<GitLabAPI.MergeRequestState> { __data["state"] }
        /// Source branch of the merge request.
        public var sourceBranch: String { __data["sourceBranch"] }
        /// Target branch of the merge request.
        public var targetBranch: String { __data["targetBranch"] }
        /// Source project of the merge request.
        public var sourceProject: SourceProject? { __data["sourceProject"] }
        /// Number of upvotes for the merge request.
        public var upvotes: Int { __data["upvotes"] }
        /// Number of downvotes for the merge request.
        public var downvotes: Int { __data["downvotes"] }
        /// User who created this merge request.
        public var author: Author? { __data["author"] }
        /// Permissions for the current user on the resource
        public var userPermissions: UserPermissions { __data["userPermissions"] }
        /// Timestamp of when the merge request was created.
        public var createdAt: GitLabAPI.Time { __data["createdAt"] }
        /// Web URL of the merge request.
        public var webUrl: String? { __data["webUrl"] }
        /// Merge status of the merge request.
        public var mergeStatusEnum: GraphQLEnum<GitLabAPI.MergeStatus>? { __data["mergeStatusEnum"] }
        /// Detailed merge status of the merge request.
        public var detailedMergeStatus: GraphQLEnum<GitLabAPI.DetailedMergeStatus>? { __data["detailedMergeStatus"] }
        /// Users from whom a review has been requested.
        public var reviewers: Reviewers? { __data["reviewers"] }
        /// All notes on this noteable.
        public var notes: Notes { __data["notes"] }

        /// Project.MergeRequest.SourceProject
        ///
        /// Parent Type: `Project`
        public struct SourceProject: GitLabAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.Project }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("fullPath", GitLabAPI.ID.self),
          ] }

          /// Full path of the project.
          public var fullPath: GitLabAPI.ID { __data["fullPath"] }
        }

        /// Project.MergeRequest.Author
        ///
        /// Parent Type: `MergeRequestAuthor`
        public struct Author: GitLabAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.MergeRequestAuthor }
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

        /// Project.MergeRequest.UserPermissions
        ///
        /// Parent Type: `MergeRequestPermissions`
        public struct UserPermissions: GitLabAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.MergeRequestPermissions }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("canMerge", Bool.self),
            .field("createNote", Bool.self),
          ] }

          /// If `true`, the user can perform `can_merge` on this resource
          public var canMerge: Bool { __data["canMerge"] }
          /// If `true`, the user can perform `create_note` on this resource
          public var createNote: Bool { __data["createNote"] }
        }

        /// Project.MergeRequest.Reviewers
        ///
        /// Parent Type: `MergeRequestReviewerConnection`
        public struct Reviewers: GitLabAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.MergeRequestReviewerConnection }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("nodes", [Node?]?.self),
          ] }

          /// A list of nodes.
          public var nodes: [Node?]? { __data["nodes"] }

          /// Project.MergeRequest.Reviewers.Node
          ///
          /// Parent Type: `MergeRequestReviewer`
          public struct Node: GitLabAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.MergeRequestReviewer }
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

        /// Project.MergeRequest.Notes
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

          /// Project.MergeRequest.Notes.Node
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

            /// Project.MergeRequest.Notes.Node.Author
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

            /// Project.MergeRequest.Notes.Node.SystemNoteMetadata
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
