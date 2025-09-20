// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

public struct CurrentUserGroupsQuery: GraphQLQuery {
  public static let operationName: String = "CurrentUserGroups"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query CurrentUserGroups { currentUser { __typename groups { __typename nodes { __typename avatarUrl name fullPath visibility groupMembersCount projectsCount maxAccessLevel { __typename stringValue } } } } }"#
    ))

  public init() {}

  public struct Data: GitLabAPI.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.Query }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("currentUser", CurrentUser?.self),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      CurrentUserGroupsQuery.Data.self
    ] }

    /// Get information about current user.
    public var currentUser: CurrentUser? { __data["currentUser"] }

    /// CurrentUser
    ///
    /// Parent Type: `CurrentUser`
    public struct CurrentUser: GitLabAPI.SelectionSet {
      @_spi(Unsafe) public let __data: DataDict
      @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

      @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.CurrentUser }
      @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("groups", Groups?.self),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        CurrentUserGroupsQuery.Data.CurrentUser.self
      ] }

      /// Groups where the user has access.
      public var groups: Groups? { __data["groups"] }

      /// CurrentUser.Groups
      ///
      /// Parent Type: `GroupConnection`
      public struct Groups: GitLabAPI.SelectionSet {
        @_spi(Unsafe) public let __data: DataDict
        @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

        @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.GroupConnection }
        @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("nodes", [Node?]?.self),
        ] }
        @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          CurrentUserGroupsQuery.Data.CurrentUser.Groups.self
        ] }

        /// A list of nodes.
        public var nodes: [Node?]? { __data["nodes"] }

        /// CurrentUser.Groups.Node
        ///
        /// Parent Type: `Group`
        public struct Node: GitLabAPI.SelectionSet {
          @_spi(Unsafe) public let __data: DataDict
          @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

          @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.Group }
          @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("avatarUrl", String?.self),
            .field("name", String?.self),
            .field("fullPath", GitLabAPI.ID.self),
            .field("visibility", String?.self),
            .field("groupMembersCount", Int.self),
            .field("projectsCount", Int.self),
            .field("maxAccessLevel", MaxAccessLevel.self),
          ] }
          @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            CurrentUserGroupsQuery.Data.CurrentUser.Groups.Node.self
          ] }

          /// Avatar URL of the group.
          public var avatarUrl: String? { __data["avatarUrl"] }
          /// Name of the group.
          public var name: String? { __data["name"] }
          /// Full path of the group.
          public var fullPath: GitLabAPI.ID { __data["fullPath"] }
          /// Visibility of the namespace.
          public var visibility: String? { __data["visibility"] }
          /// Count of direct members of the group.
          public var groupMembersCount: Int { __data["groupMembersCount"] }
          /// Count of direct projects in the group.
          public var projectsCount: Int { __data["projectsCount"] }
          /// Maximum access level of the current user in the group.
          public var maxAccessLevel: MaxAccessLevel { __data["maxAccessLevel"] }

          /// CurrentUser.Groups.Node.MaxAccessLevel
          ///
          /// Parent Type: `AccessLevel`
          public struct MaxAccessLevel: GitLabAPI.SelectionSet {
            @_spi(Unsafe) public let __data: DataDict
            @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

            @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.AccessLevel }
            @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("stringValue", GraphQLEnum<GitLabAPI.AccessLevelEnum>?.self),
            ] }
            @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
              CurrentUserGroupsQuery.Data.CurrentUser.Groups.Node.MaxAccessLevel.self
            ] }

            /// Enum string of the the access level.
            public var stringValue: GraphQLEnum<GitLabAPI.AccessLevelEnum>? { __data["stringValue"] }
          }
        }
      }
    }
  }
}
