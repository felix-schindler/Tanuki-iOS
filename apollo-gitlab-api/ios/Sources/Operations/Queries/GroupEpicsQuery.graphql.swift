// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct GroupEpicsQuery: GraphQLQuery {
  public static let operationName: String = "GroupEpics"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query GroupEpics($fullPath: ID!) { group(fullPath: $fullPath) { __typename epics(state: opened) { __typename nodes { __typename iid title reference(full: true) state upvotes downvotes userNotesCount author { __typename avatarUrl name username } createdAt webUrl } } } }"#
    ))

  public var fullPath: ID

  public init(fullPath: ID) {
    self.fullPath = fullPath
  }

  @_spi(Unsafe) public var __variables: Variables? { ["fullPath": fullPath] }

  nonisolated public struct Data: IOSGitLabAPI.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { IOSGitLabAPI.Objects.Query }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("group", Group?.self, arguments: ["fullPath": .variable("fullPath")]),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      GroupEpicsQuery.Data.self
    ] }

    /// Find a group.
    public var group: Group? { __data["group"] }

    /// Group
    ///
    /// Parent Type: `Group`
    nonisolated public struct Group: IOSGitLabAPI.SelectionSet {
      @_spi(Unsafe) public let __data: DataDict
      @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

      @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { IOSGitLabAPI.Objects.Group }
      @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("epics", Epics?.self, arguments: ["state": "opened"]),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        GroupEpicsQuery.Data.Group.self
      ] }

      /// Find epics. Deprecated in GitLab 17.5: Replaced by `WorkItem` type. For more information, see [migration guide](https://docs.gitlab.com/api/graphql/epic_work_items_api_migration_guide/).
      @available(*, deprecated, message: "Replaced by `WorkItem` type. For more information, see [migration guide](https://docs.gitlab.com/api/graphql/epic_work_items_api_migration_guide/). Deprecated in GitLab 17.5.")
      public var epics: Epics? { __data["epics"] }

      /// Group.Epics
      ///
      /// Parent Type: `EpicConnection`
      nonisolated public struct Epics: IOSGitLabAPI.SelectionSet {
        @_spi(Unsafe) public let __data: DataDict
        @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

        @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { IOSGitLabAPI.Objects.EpicConnection }
        @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("nodes", [Node?]?.self),
        ] }
        @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          GroupEpicsQuery.Data.Group.Epics.self
        ] }

        /// A list of nodes.
        public var nodes: [Node?]? { __data["nodes"] }

        /// Group.Epics.Node
        ///
        /// Parent Type: `Epic`
        nonisolated public struct Node: IOSGitLabAPI.SelectionSet {
          @_spi(Unsafe) public let __data: DataDict
          @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

          @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { IOSGitLabAPI.Objects.Epic }
          @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("iid", String.self),
            .field("title", String?.self),
            .field("reference", String.self, arguments: ["full": true]),
            .field("state", GraphQLEnum<IOSGitLabAPI.EpicState>.self),
            .field("upvotes", Int.self),
            .field("downvotes", Int.self),
            .field("userNotesCount", Int.self),
            .field("author", Author.self),
            .field("createdAt", IOSGitLabAPI.Time?.self),
            .field("webUrl", String.self),
          ] }
          @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            GroupEpicsQuery.Data.Group.Epics.Node.self
          ] }

          /// Internal ID of the epic.
          public var iid: String { __data["iid"] }
          /// Title of the epic.
          public var title: String? { __data["title"] }
          /// Internal reference of the epic. Returned in shortened format by default.
          public var reference: String { __data["reference"] }
          /// State of the epic.
          public var state: GraphQLEnum<IOSGitLabAPI.EpicState> { __data["state"] }
          /// Number of upvotes the epic has received.
          public var upvotes: Int { __data["upvotes"] }
          /// Number of downvotes the epic has received.
          public var downvotes: Int { __data["downvotes"] }
          /// Number of user notes of the epic.
          public var userNotesCount: Int { __data["userNotesCount"] }
          /// Author of the epic.
          public var author: Author { __data["author"] }
          /// Timestamp of when the epic was created.
          public var createdAt: IOSGitLabAPI.Time? { __data["createdAt"] }
          /// Web URL of the epic.
          public var webUrl: String { __data["webUrl"] }

          /// Group.Epics.Node.Author
          ///
          /// Parent Type: `UserCore`
          nonisolated public struct Author: IOSGitLabAPI.SelectionSet {
            @_spi(Unsafe) public let __data: DataDict
            @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

            @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { IOSGitLabAPI.Objects.UserCore }
            @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("avatarUrl", String?.self),
              .field("name", String.self),
              .field("username", String.self),
            ] }
            @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
              GroupEpicsQuery.Data.Group.Epics.Node.Author.self
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
