// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

public struct CurrentUserMembershipProjectsQuery: GraphQLQuery {
  public static let operationName: String = "CurrentUserMembershipProjects"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query CurrentUserMembershipProjects { currentUser { __typename projectMemberships { __typename nodes { __typename project { __typename avatarUrl nameWithNamespace visibility fullPath } } } } }"#
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
      CurrentUserMembershipProjectsQuery.Data.self
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
        .field("projectMemberships", ProjectMemberships?.self),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        CurrentUserMembershipProjectsQuery.Data.CurrentUser.self
      ] }

      /// Project memberships of the user.
      public var projectMemberships: ProjectMemberships? { __data["projectMemberships"] }

      /// CurrentUser.ProjectMemberships
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
          CurrentUserMembershipProjectsQuery.Data.CurrentUser.ProjectMemberships.self
        ] }

        /// A list of nodes.
        public var nodes: [Node?]? { __data["nodes"] }

        /// CurrentUser.ProjectMemberships.Node
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
            CurrentUserMembershipProjectsQuery.Data.CurrentUser.ProjectMemberships.Node.self
          ] }

          /// Project that User is a member of.
          public var project: Project? { __data["project"] }

          /// CurrentUser.ProjectMemberships.Node.Project
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
              CurrentUserMembershipProjectsQuery.Data.CurrentUser.ProjectMemberships.Node.Project.self
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
