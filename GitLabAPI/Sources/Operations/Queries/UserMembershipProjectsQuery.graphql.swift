// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

public struct UserMembershipProjectsQuery: GraphQLQuery {
  public static let operationName: String = "UserMembershipProjects"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query UserMembershipProjects($username: String!) { user(username: $username) { __typename projectMemberships { __typename nodes { __typename project { __typename avatarUrl nameWithNamespace visibility fullPath } } } } }"#
    ))

  public var username: String

  public init(username: String) {
    self.username = username
  }

  @_spi(Unsafe) public var __variables: Variables? { ["username": username] }

  public struct Data: GitLabAPI.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.Query }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("user", User?.self, arguments: ["username": .variable("username")]),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      UserMembershipProjectsQuery.Data.self
    ] }

    /// Find a user.
    public var user: User? { __data["user"] }

    /// User
    ///
    /// Parent Type: `UserCore`
    public struct User: GitLabAPI.SelectionSet {
      @_spi(Unsafe) public let __data: DataDict
      @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

      @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.UserCore }
      @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("projectMemberships", ProjectMemberships?.self),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        UserMembershipProjectsQuery.Data.User.self
      ] }

      /// Project memberships of the user.
      public var projectMemberships: ProjectMemberships? { __data["projectMemberships"] }

      /// User.ProjectMemberships
      ///
      /// Parent Type: `ProjectMemberConnection`
      public struct ProjectMemberships: GitLabAPI.SelectionSet {
        @_spi(Unsafe) public let __data: DataDict
        @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

        @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.ProjectMemberConnection }
        @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("nodes", [Node?]?.self),
        ] }
        @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          UserMembershipProjectsQuery.Data.User.ProjectMemberships.self
        ] }

        /// A list of nodes.
        public var nodes: [Node?]? { __data["nodes"] }

        /// User.ProjectMemberships.Node
        ///
        /// Parent Type: `ProjectMember`
        public struct Node: GitLabAPI.SelectionSet {
          @_spi(Unsafe) public let __data: DataDict
          @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

          @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.ProjectMember }
          @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("project", Project?.self),
          ] }
          @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            UserMembershipProjectsQuery.Data.User.ProjectMemberships.Node.self
          ] }

          /// Project that User is a member of.
          public var project: Project? { __data["project"] }

          /// User.ProjectMemberships.Node.Project
          ///
          /// Parent Type: `Project`
          public struct Project: GitLabAPI.SelectionSet {
            @_spi(Unsafe) public let __data: DataDict
            @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

            @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.Project }
            @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("avatarUrl", String?.self),
              .field("nameWithNamespace", String.self),
              .field("visibility", String?.self),
              .field("fullPath", GitLabAPI.ID.self),
            ] }
            @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
              UserMembershipProjectsQuery.Data.User.ProjectMemberships.Node.Project.self
            ] }

            /// Avatar URL of the project.
            public var avatarUrl: String? { __data["avatarUrl"] }
            /// Name of the project including the namespace.
            public var nameWithNamespace: String { __data["nameWithNamespace"] }
            /// Visibility of the project.
            public var visibility: String? { __data["visibility"] }
            /// Full path of the project.
            public var fullPath: GitLabAPI.ID { __data["fullPath"] }
          }
        }
      }
    }
  }
}
