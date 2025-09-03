// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class EpicIssuesQuery: GraphQLQuery {
  public static let operationName: String = "EpicIssues"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query EpicIssues($fullPath: ID!, $iid: ID!) { group(fullPath: $fullPath) { __typename epic(iid: $iid) { __typename issues { __typename nodes { __typename iid title reference(full: true) state upvotes downvotes userNotesCount author { __typename avatarUrl name username } createdAt webUrl } } } } }"#
    ))

  public var fullPath: ID
  public var iid: ID

  public init(
    fullPath: ID,
    iid: ID
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

    public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("group", Group?.self, arguments: ["fullPath": .variable("fullPath")]),
    ] }

    /// Find a group.
    public var group: Group? { __data["group"] }

    /// Group
    ///
    /// Parent Type: `Group`
    public struct Group: GitLabAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.Group }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("epic", Epic?.self, arguments: ["iid": .variable("iid")]),
      ] }

      /// Find a single epic. Deprecated in GitLab 17.5: Replaced by `WorkItem` type. For more information, see [migration guide](https://docs.gitlab.com/api/graphql/epic_work_items_api_migration_guide/).
      @available(*, deprecated, message: "Replaced by `WorkItem` type. For more information, see [migration guide](https://docs.gitlab.com/api/graphql/epic_work_items_api_migration_guide/). Deprecated in GitLab 17.5.")
      public var epic: Epic? { __data["epic"] }

      /// Group.Epic
      ///
      /// Parent Type: `Epic`
      public struct Epic: GitLabAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.Epic }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("issues", Issues?.self),
        ] }

        /// A list of issues associated with the epic.
        public var issues: Issues? { __data["issues"] }

        /// Group.Epic.Issues
        ///
        /// Parent Type: `EpicIssueConnection`
        public struct Issues: GitLabAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.EpicIssueConnection }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("nodes", [Node?]?.self),
          ] }

          /// A list of nodes.
          public var nodes: [Node?]? { __data["nodes"] }

          /// Group.Epic.Issues.Node
          ///
          /// Parent Type: `EpicIssue`
          public struct Node: GitLabAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.EpicIssue }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("iid", String.self),
              .field("title", String.self),
              .field("reference", String.self, arguments: ["full": true]),
              .field("state", GraphQLEnum<GitLabAPI.IssueState>.self),
              .field("upvotes", Int.self),
              .field("downvotes", Int.self),
              .field("userNotesCount", Int.self),
              .field("author", Author.self),
              .field("createdAt", GitLabAPI.Time.self),
              .field("webUrl", String.self),
            ] }

            /// Internal ID of the issue.
            public var iid: String { __data["iid"] }
            /// Title of the issue.
            public var title: String { __data["title"] }
            /// Internal reference of the issue. Returned in shortened format by default.
            public var reference: String { __data["reference"] }
            /// State of the issue.
            public var state: GraphQLEnum<GitLabAPI.IssueState> { __data["state"] }
            /// Number of upvotes the issue has received.
            public var upvotes: Int { __data["upvotes"] }
            /// Number of downvotes the issue has received.
            public var downvotes: Int { __data["downvotes"] }
            /// Number of user notes of the issue.
            public var userNotesCount: Int { __data["userNotesCount"] }
            /// User that created the issue.
            public var author: Author { __data["author"] }
            /// Timestamp of when the issue was created.
            public var createdAt: GitLabAPI.Time { __data["createdAt"] }
            /// Web URL of the issue.
            public var webUrl: String { __data["webUrl"] }

            /// Group.Epic.Issues.Node.Author
            ///
            /// Parent Type: `UserCore`
            public struct Author: GitLabAPI.SelectionSet {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.UserCore }
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
              /// Username of the user. Unique within the instance of GitLab.
              public var username: String { __data["username"] }
            }
          }
        }
      }
    }
  }
}
