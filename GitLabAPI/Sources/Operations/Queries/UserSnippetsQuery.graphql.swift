// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class UserSnippetsQuery: GraphQLQuery {
  public static let operationName: String = "UserSnippets"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query UserSnippets($username: String!) { user(username: $username) { __typename snippets { __typename nodes { __typename id title visibilityLevel author { __typename avatarUrl name username } createdAt webUrl } } } }"#
    ))

  public var username: String

  public init(username: String) {
    self.username = username
  }

  public var __variables: Variables? { ["username": username] }

  public struct Data: GitLabAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("user", User?.self, arguments: ["username": .variable("username")]),
    ] }

    /// Find a user.
    public var user: User? { __data["user"] }

    /// User
    ///
    /// Parent Type: `UserCore`
    public struct User: GitLabAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.UserCore }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("snippets", Snippets?.self),
      ] }

      /// Snippets authored by the user.
      public var snippets: Snippets? { __data["snippets"] }

      /// User.Snippets
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

        /// User.Snippets.Node
        ///
        /// Parent Type: `Snippet`
        public struct Node: GitLabAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.Snippet }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", GitLabAPI.SnippetID.self),
            .field("title", String.self),
            .field("visibilityLevel", GraphQLEnum<GitLabAPI.VisibilityLevelsEnum>.self),
            .field("author", Author?.self),
            .field("createdAt", GitLabAPI.Time.self),
            .field("webUrl", String.self),
          ] }

          /// ID of the snippet.
          public var id: GitLabAPI.SnippetID { __data["id"] }
          /// Title of the snippet.
          public var title: String { __data["title"] }
          /// Visibility Level of the snippet.
          public var visibilityLevel: GraphQLEnum<GitLabAPI.VisibilityLevelsEnum> { __data["visibilityLevel"] }
          /// Owner of the snippet.
          public var author: Author? { __data["author"] }
          /// Timestamp this snippet was created.
          public var createdAt: GitLabAPI.Time { __data["createdAt"] }
          /// Web URL of the snippet.
          public var webUrl: String { __data["webUrl"] }

          /// User.Snippets.Node.Author
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
        }
      }
    }
  }
}
