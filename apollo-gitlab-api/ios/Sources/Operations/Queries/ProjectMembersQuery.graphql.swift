// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct ProjectMembersQuery: GraphQLQuery {
  public static let operationName: String = "ProjectMembers"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query ProjectMembers($fullPath: ID!) { project(fullPath: $fullPath) { __typename projectMembers { __typename nodes { __typename id createdBy { __typename avatarUrl name username } createdAt expiresAt accessLevel { __typename stringValue } user { __typename avatarUrl name username } } } } }"#
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
      .field("project", Project?.self, arguments: ["fullPath": .variable("fullPath")]),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      ProjectMembersQuery.Data.self
    ] }

    /// Find a project.
    public var project: Project? { __data["project"] }

    /// Project
    ///
    /// Parent Type: `Project`
    nonisolated public struct Project: IOSGitLabAPI.SelectionSet {
      @_spi(Unsafe) public let __data: DataDict
      @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

      @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { IOSGitLabAPI.Objects.Project }
      @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("projectMembers", ProjectMembers?.self),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        ProjectMembersQuery.Data.Project.self
      ] }

      /// Members of the project.
      public var projectMembers: ProjectMembers? { __data["projectMembers"] }

      /// Project.ProjectMembers
      ///
      /// Parent Type: `MemberInterfaceConnection`
      nonisolated public struct ProjectMembers: IOSGitLabAPI.SelectionSet {
        @_spi(Unsafe) public let __data: DataDict
        @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

        @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { IOSGitLabAPI.Objects.MemberInterfaceConnection }
        @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("nodes", [Node?]?.self),
        ] }
        @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          ProjectMembersQuery.Data.Project.ProjectMembers.self
        ] }

        /// A list of nodes.
        public var nodes: [Node?]? { __data["nodes"] }

        /// Project.ProjectMembers.Node
        ///
        /// Parent Type: `MemberInterface`
        nonisolated public struct Node: IOSGitLabAPI.SelectionSet {
          @_spi(Unsafe) public let __data: DataDict
          @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

          @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { IOSGitLabAPI.Interfaces.MemberInterface }
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
            ProjectMembersQuery.Data.Project.ProjectMembers.Node.self
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

          /// Project.ProjectMembers.Node.CreatedBy
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
              ProjectMembersQuery.Data.Project.ProjectMembers.Node.CreatedBy.self
            ] }

            /// URL of the user's avatar.
            public var avatarUrl: String? { __data["avatarUrl"] }
            /// Human-readable name of the user. Returns `****` if the user is a project bot and the requester does not have permission to view the project.
            public var name: String { __data["name"] }
            /// Username of the user. Unique within the instance of GitLab.
            public var username: String { __data["username"] }
          }

          /// Project.ProjectMembers.Node.AccessLevel
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
              ProjectMembersQuery.Data.Project.ProjectMembers.Node.AccessLevel.self
            ] }

            /// Enum string of the the access level.
            public var stringValue: GraphQLEnum<IOSGitLabAPI.AccessLevelEnum>? { __data["stringValue"] }
          }

          /// Project.ProjectMembers.Node.User
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
              ProjectMembersQuery.Data.Project.ProjectMembers.Node.User.self
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
