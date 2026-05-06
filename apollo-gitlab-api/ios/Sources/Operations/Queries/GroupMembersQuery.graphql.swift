// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct GroupMembersQuery: GraphQLQuery {
  public static let operationName: String = "GroupMembers"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query GroupMembers($fullPath: ID!) { group(fullPath: $fullPath) { __typename groupMembers { __typename nodes { __typename id createdBy { __typename avatarUrl name username } createdAt expiresAt accessLevel { __typename stringValue } user { __typename avatarUrl name username } } } } }"#
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
      GroupMembersQuery.Data.self
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
        .field("groupMembers", GroupMembers?.self),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        GroupMembersQuery.Data.Group.self
      ] }

      /// A membership of a user within this group.
      public var groupMembers: GroupMembers? { __data["groupMembers"] }

      /// Group.GroupMembers
      ///
      /// Parent Type: `GroupMemberConnection`
      nonisolated public struct GroupMembers: IOSGitLabAPI.SelectionSet {
        @_spi(Unsafe) public let __data: DataDict
        @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

        @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { IOSGitLabAPI.Objects.GroupMemberConnection }
        @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("nodes", [Node?]?.self),
        ] }
        @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          GroupMembersQuery.Data.Group.GroupMembers.self
        ] }

        /// A list of nodes.
        public var nodes: [Node?]? { __data["nodes"] }

        /// Group.GroupMembers.Node
        ///
        /// Parent Type: `GroupMember`
        nonisolated public struct Node: IOSGitLabAPI.SelectionSet {
          @_spi(Unsafe) public let __data: DataDict
          @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

          @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { IOSGitLabAPI.Objects.GroupMember }
          @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", IOSGitLabAPI.ID.self),
            .field("createdBy", CreatedBy?.self),
            .field("createdAt", IOSGitLabAPI.Time?.self),
            .field("expiresAt", IOSGitLabAPI.Time?.self),
            .field("accessLevel", AccessLevel?.self),
            .field("user", User?.self),
          ] }
          @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            GroupMembersQuery.Data.Group.GroupMembers.Node.self
          ] }

          /// ID of the member.
          public var id: IOSGitLabAPI.ID { __data["id"] }
          /// User that authorized membership.
          public var createdBy: CreatedBy? { __data["createdBy"] }
          /// Date and time the membership was created.
          public var createdAt: IOSGitLabAPI.Time? { __data["createdAt"] }
          /// Date and time the membership expires.
          public var expiresAt: IOSGitLabAPI.Time? { __data["expiresAt"] }
          /// GitLab::Access level.
          public var accessLevel: AccessLevel? { __data["accessLevel"] }
          /// User that is associated with the member object.
          public var user: User? { __data["user"] }

          /// Group.GroupMembers.Node.CreatedBy
          ///
          /// Parent Type: `UserCore`
          nonisolated public struct CreatedBy: IOSGitLabAPI.SelectionSet {
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
              GroupMembersQuery.Data.Group.GroupMembers.Node.CreatedBy.self
            ] }

            /// URL of the user's avatar.
            public var avatarUrl: String? { __data["avatarUrl"] }
            /// Human-readable name of the user. Returns `****` if the user is a project bot and the requester does not have permission to view the project.
            public var name: String { __data["name"] }
            /// Username of the user. Unique within the instance of GitLab.
            public var username: String { __data["username"] }
          }

          /// Group.GroupMembers.Node.AccessLevel
          ///
          /// Parent Type: `AccessLevel`
          nonisolated public struct AccessLevel: IOSGitLabAPI.SelectionSet {
            @_spi(Unsafe) public let __data: DataDict
            @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

            @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { IOSGitLabAPI.Objects.AccessLevel }
            @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("stringValue", GraphQLEnum<IOSGitLabAPI.AccessLevelEnum>?.self),
            ] }
            @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
              GroupMembersQuery.Data.Group.GroupMembers.Node.AccessLevel.self
            ] }

            /// Enum string of the the access level.
            public var stringValue: GraphQLEnum<IOSGitLabAPI.AccessLevelEnum>? { __data["stringValue"] }
          }

          /// Group.GroupMembers.Node.User
          ///
          /// Parent Type: `UserCore`
          nonisolated public struct User: IOSGitLabAPI.SelectionSet {
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
              GroupMembersQuery.Data.Group.GroupMembers.Node.User.self
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
