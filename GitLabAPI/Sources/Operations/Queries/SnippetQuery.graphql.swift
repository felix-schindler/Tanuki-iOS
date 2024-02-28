// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class SnippetQuery: GraphQLQuery {
  public static let operationName: String = "Snippet"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query Snippet($id: SnippetID!) { snippets(ids: [$id]) { __typename nodes { __typename title description visibilityLevel userPermissions { __typename createNote } author { __typename avatarUrl username name } blobs { __typename nodes { __typename size name rawPlainData } } notes { __typename nodes { __typename id author { __typename avatarUrl username } maxAccessLevelOfAuthor body system systemNoteIconName createdAt updatedAt } } createdAt sshUrlToRepo httpUrlToRepo webUrl } } }"#
    ))

  public var id: SnippetID

  public init(id: SnippetID) {
    self.id = id
  }

  public var __variables: Variables? { ["id": id] }

  public struct Data: GitLabAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("snippets", Snippets?.self, arguments: ["ids": [.variable("id")]]),
    ] }

    /// Find Snippets visible to the current user.
    public var snippets: Snippets? { __data["snippets"] }

    /// Snippets
    ///
    /// Parent Type: `SnippetConnection`
    public struct Snippets: GitLabAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.SnippetConnection }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("nodes", [Node?]?.self),
      ] }

      /// A list of nodes.
      public var nodes: [Node?]? { __data["nodes"] }

      /// Snippets.Node
      ///
      /// Parent Type: `Snippet`
      public struct Node: GitLabAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.Snippet }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("title", String.self),
          .field("description", String?.self),
          .field("visibilityLevel", GraphQLEnum<GitLabAPI.VisibilityLevelsEnum>.self),
          .field("userPermissions", UserPermissions.self),
          .field("author", Author?.self),
          .field("blobs", Blobs?.self),
          .field("notes", Notes.self),
          .field("createdAt", GitLabAPI.Time.self),
          .field("sshUrlToRepo", String?.self),
          .field("httpUrlToRepo", String?.self),
          .field("webUrl", String.self),
        ] }

        /// Title of the snippet.
        public var title: String { __data["title"] }
        /// Description of the snippet.
        public var description: String? { __data["description"] }
        /// Visibility Level of the snippet.
        public var visibilityLevel: GraphQLEnum<GitLabAPI.VisibilityLevelsEnum> { __data["visibilityLevel"] }
        /// Permissions for the current user on the resource
        public var userPermissions: UserPermissions { __data["userPermissions"] }
        /// Owner of the snippet.
        public var author: Author? { __data["author"] }
        /// Snippet blobs.
        public var blobs: Blobs? { __data["blobs"] }
        /// All notes on this noteable.
        public var notes: Notes { __data["notes"] }
        /// Timestamp this snippet was created.
        public var createdAt: GitLabAPI.Time { __data["createdAt"] }
        /// SSH URL to the snippet repository.
        public var sshUrlToRepo: String? { __data["sshUrlToRepo"] }
        /// HTTP URL to the snippet repository.
        public var httpUrlToRepo: String? { __data["httpUrlToRepo"] }
        /// Web URL of the snippet.
        public var webUrl: String { __data["webUrl"] }

        /// Snippets.Node.UserPermissions
        ///
        /// Parent Type: `SnippetPermissions`
        public struct UserPermissions: GitLabAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.SnippetPermissions }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("createNote", Bool.self),
          ] }

          /// If `true`, the user can perform `create_note` on this resource
          public var createNote: Bool { __data["createNote"] }
        }

        /// Snippets.Node.Author
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
            .field("name", String.self),
          ] }

          /// URL of the user's avatar.
          public var avatarUrl: String? { __data["avatarUrl"] }
          /// Username of the user. Unique within this instance of GitLab.
          public var username: String { __data["username"] }
          /// Human-readable name of the user. Returns `****` if the user is a project bot and the requester does not have permission to view the project.
          public var name: String { __data["name"] }
        }

        /// Snippets.Node.Blobs
        ///
        /// Parent Type: `SnippetBlobConnection`
        public struct Blobs: GitLabAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.SnippetBlobConnection }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("nodes", [Node?]?.self),
          ] }

          /// A list of nodes.
          public var nodes: [Node?]? { __data["nodes"] }

          /// Snippets.Node.Blobs.Node
          ///
          /// Parent Type: `SnippetBlob`
          public struct Node: GitLabAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.SnippetBlob }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("size", Int.self),
              .field("name", String?.self),
              .field("rawPlainData", String?.self),
            ] }

            /// Blob size.
            public var size: Int { __data["size"] }
            /// Blob name.
            public var name: String? { __data["name"] }
            /// Raw content of the blob, if the blob is text data.
            public var rawPlainData: String? { __data["rawPlainData"] }
          }
        }

        /// Snippets.Node.Notes
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

          /// Snippets.Node.Notes.Node
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
              .field("body", String.self),
              .field("system", Bool.self),
              .field("systemNoteIconName", String?.self),
              .field("createdAt", GitLabAPI.Time.self),
              .field("updatedAt", GitLabAPI.Time.self),
            ] }

            /// ID of the note.
            public var id: GitLabAPI.NoteID { __data["id"] }
            /// User who wrote this note.
            public var author: Author? { __data["author"] }
            /// Max access level of the note author in the project.
            public var maxAccessLevelOfAuthor: String? { __data["maxAccessLevelOfAuthor"] }
            /// Content of the note.
            public var body: String { __data["body"] }
            /// Indicates whether this note was created by the system or by a user.
            public var system: Bool { __data["system"] }
            /// Name of the icon corresponding to a system note.
            public var systemNoteIconName: String? { __data["systemNoteIconName"] }
            /// Timestamp of the note creation.
            public var createdAt: GitLabAPI.Time { __data["createdAt"] }
            /// Timestamp of the note's last activity.
            public var updatedAt: GitLabAPI.Time { __data["updatedAt"] }

            /// Snippets.Node.Notes.Node.Author
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
          }
        }
      }
    }
  }
}
