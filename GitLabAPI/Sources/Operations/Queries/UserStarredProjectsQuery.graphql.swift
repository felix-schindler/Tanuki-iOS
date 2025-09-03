// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class UserStarredProjectsQuery: GraphQLQuery {
  public static let operationName: String = "UserStarredProjects"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query UserStarredProjects($username: String!) { user(username: $username) { __typename starredProjects { __typename nodes { __typename avatarUrl nameWithNamespace visibility fullPath } } } }"#
    ))

  public var username: String

  public init(username: String) {
    self.username = username
  }

  public var __variables: Variables? { ["username": username] }

  public struct Data: GitLabAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("user", User?.self, arguments: ["username": .variable("username")]),
    ] }

    /// Find a user.
    public var user: User? { __data["user"] }

    /// User
    ///
    /// Parent Type: `UserCore`
    public struct User: GitLabAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.UserCore }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("starredProjects", StarredProjects?.self),
      ] }

      /// Projects starred by the user.
      public var starredProjects: StarredProjects? { __data["starredProjects"] }

      /// User.StarredProjects
      ///
      /// Parent Type: `ProjectConnection`
      public struct StarredProjects: GitLabAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.ProjectConnection }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("nodes", [Node?]?.self),
        ] }

        /// A list of nodes.
        public var nodes: [Node?]? { __data["nodes"] }

        /// User.StarredProjects.Node
        ///
        /// Parent Type: `Project`
        public struct Node: GitLabAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.Project }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("avatarUrl", String?.self),
            .field("nameWithNamespace", String.self),
            .field("visibility", String?.self),
            .field("fullPath", GitLabAPI.ID.self),
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
