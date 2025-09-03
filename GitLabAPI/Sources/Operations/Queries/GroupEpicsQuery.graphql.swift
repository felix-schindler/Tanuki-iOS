// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class GroupEpicsQuery: GraphQLQuery {
  public static let operationName: String = "GroupEpics"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query GroupEpics($fullPath: ID!) { group(fullPath: $fullPath) { __typename epics(state: opened) { __typename nodes { __typename iid title reference(full: true) state upvotes downvotes userNotesCount author { __typename avatarUrl name username } createdAt webUrl } } } }"#
    ))

  public var fullPath: ID

  public init(fullPath: ID) {
    self.fullPath = fullPath
  }

  public var __variables: Variables? { ["fullPath": fullPath] }

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
        .field("epics", Epics?.self, arguments: ["state": "opened"]),
      ] }

      /// Find epics. Deprecated in GitLab 17.5: Replaced by `WorkItem` type. For more information, see [migration guide](https://docs.gitlab.com/api/graphql/epic_work_items_api_migration_guide/).
      @available(*, deprecated, message: "Replaced by `WorkItem` type. For more information, see [migration guide](https://docs.gitlab.com/api/graphql/epic_work_items_api_migration_guide/). Deprecated in GitLab 17.5.")
      public var epics: Epics? { __data["epics"] }

      /// Group.Epics
      ///
      /// Parent Type: `EpicConnection`
      public struct Epics: GitLabAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.EpicConnection }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("nodes", [Node?]?.self),
        ] }

        /// A list of nodes.
        public var nodes: [Node?]? { __data["nodes"] }

        /// Group.Epics.Node
        ///
        /// Parent Type: `Epic`
        public struct Node: GitLabAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.Epic }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("iid", String.self),
            .field("title", String?.self),
            .field("reference", String.self, arguments: ["full": true]),
            .field("state", GraphQLEnum<GitLabAPI.EpicState>.self),
            .field("upvotes", Int.self),
            .field("downvotes", Int.self),
            .field("userNotesCount", Int.self),
            .field("author", Author.self),
            .field("createdAt", GitLabAPI.Time?.self),
            .field("webUrl", String.self),
          ] }

          /// Internal ID of the epic.
          public var iid: String { __data["iid"] }
          /// Title of the epic.
          public var title: String? { __data["title"] }
          /// Internal reference of the epic. Returned in shortened format by default.
          public var reference: String { __data["reference"] }
          /// State of the epic.
          public var state: GraphQLEnum<GitLabAPI.EpicState> { __data["state"] }
          /// Number of upvotes the epic has received.
          public var upvotes: Int { __data["upvotes"] }
          /// Number of downvotes the epic has received.
          public var downvotes: Int { __data["downvotes"] }
          /// Number of user notes of the epic.
          public var userNotesCount: Int { __data["userNotesCount"] }
          /// Author of the epic.
          public var author: Author { __data["author"] }
          /// Timestamp of when the epic was created.
          public var createdAt: GitLabAPI.Time? { __data["createdAt"] }
          /// Web URL of the epic.
          public var webUrl: String { __data["webUrl"] }

          /// Group.Epics.Node.Author
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
