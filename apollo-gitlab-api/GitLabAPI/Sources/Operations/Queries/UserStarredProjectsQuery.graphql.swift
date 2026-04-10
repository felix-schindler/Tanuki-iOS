// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

public struct UserStarredProjectsQuery: GraphQLQuery {
  public static let operationName: String = "UserStarredProjects"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query UserStarredProjects($username: String!) { user(username: $username) { __typename starredProjects { __typename nodes { __typename avatarUrl nameWithNamespace visibility fullPath } } } }"#
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
      UserStarredProjectsQuery.Data.self
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
        .field("starredProjects", StarredProjects?.self),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        UserStarredProjectsQuery.Data.User.self
      ] }

      /// Projects starred by the user.
      public var starredProjects: StarredProjects? { __data["starredProjects"] }

      /// User.StarredProjects
      ///
      /// Parent Type: `ProjectConnection`
      public struct StarredProjects: GitLabAPI.SelectionSet {
        @_spi(Unsafe) public let __data: DataDict
        @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

        @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.ProjectConnection }
        @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("nodes", [Node?]?.self),
        ] }
        @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          UserStarredProjectsQuery.Data.User.StarredProjects.self
        ] }

        /// A list of nodes.
        public var nodes: [Node?]? { __data["nodes"] }

        /// User.StarredProjects.Node
        ///
        /// Parent Type: `Project`
        public struct Node: GitLabAPI.SelectionSet {
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
            UserStarredProjectsQuery.Data.User.StarredProjects.Node.self
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
