// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

public struct DescendantGroupsQuery: GraphQLQuery {
  public static let operationName: String = "DescendantGroups"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query DescendantGroups($fullPath: ID!) { group(fullPath: $fullPath) { __typename descendantGroups { __typename nodes { __typename avatarUrl name fullPath visibility groupMembersCount projectsCount maxAccessLevel { __typename stringValue } } } } }"#
    ))

  public var fullPath: ID

  public init(fullPath: ID) {
    self.fullPath = fullPath
  }

  @_spi(Unsafe) public var __variables: Variables? { ["fullPath": fullPath] }

  public struct Data: GitLabAPI.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.Query }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("group", Group?.self, arguments: ["fullPath": .variable("fullPath")]),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      DescendantGroupsQuery.Data.self
    ] }

    /// Find a group.
    public var group: Group? { __data["group"] }

    /// Group
    ///
    /// Parent Type: `Group`
    public struct Group: GitLabAPI.SelectionSet {
      @_spi(Unsafe) public let __data: DataDict
      @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

      @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.Group }
      @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("descendantGroups", DescendantGroups?.self),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        DescendantGroupsQuery.Data.Group.self
      ] }

      /// List of descendant groups of this group.
      public var descendantGroups: DescendantGroups? { __data["descendantGroups"] }

      /// Group.DescendantGroups
      ///
      /// Parent Type: `GroupConnection`
      public struct DescendantGroups: GitLabAPI.SelectionSet {
        @_spi(Unsafe) public let __data: DataDict
        @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

        @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.GroupConnection }
        @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("nodes", [Node?]?.self),
        ] }
        @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          DescendantGroupsQuery.Data.Group.DescendantGroups.self
        ] }

        /// A list of nodes.
        public var nodes: [Node?]? { __data["nodes"] }

        /// Group.DescendantGroups.Node
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
            DescendantGroupsQuery.Data.Group.DescendantGroups.Node.self
          ] }

          /// Avatar URL of the group.
          public var avatarUrl: String? { __data["avatarUrl"] }
          /// Name of the group.
          public var name: String? { __data["name"] }
          /// Full path of the namespace.
          public var fullPath: GitLabAPI.ID { __data["fullPath"] }
          /// Visibility of the namespace.
          public var visibility: String? { __data["visibility"] }
          /// Count of direct members of the group.
          public var groupMembersCount: Int { __data["groupMembersCount"] }
          /// Count of direct projects in the group.
          public var projectsCount: Int { __data["projectsCount"] }
          /// Maximum access level of the current user in the group.
          public var maxAccessLevel: MaxAccessLevel { __data["maxAccessLevel"] }

          /// Group.DescendantGroups.Node.MaxAccessLevel
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
              DescendantGroupsQuery.Data.Group.DescendantGroups.Node.MaxAccessLevel.self
            ] }

            /// Enum string of the the access level.
            public var stringValue: GraphQLEnum<GitLabAPI.AccessLevelEnum>? { __data["stringValue"] }
          }
        }
      }
    }
  }
}
