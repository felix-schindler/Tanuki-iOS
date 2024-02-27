// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class StarredProjectsQuery: GraphQLQuery {
  public static let operationName: String = "StarredProjects"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query StarredProjects { currentUser { __typename starredProjects { __typename nodes { __typename avatarUrl nameWithNamespace visibility fullPath } } } }"#
    ))

  public init() {}

  public struct Data: GitLabAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("currentUser", CurrentUser?.self),
    ] }

    /// Get information about current user.
    public var currentUser: CurrentUser? { __data["currentUser"] }

    /// CurrentUser
    ///
    /// Parent Type: `CurrentUser`
    public struct CurrentUser: GitLabAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.CurrentUser }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("starredProjects", StarredProjects?.self),
      ] }

      /// Projects starred by the user.
      public var starredProjects: StarredProjects? { __data["starredProjects"] }

      /// CurrentUser.StarredProjects
      ///
      /// Parent Type: `ProjectConnection`
      public struct StarredProjects: GitLabAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.ProjectConnection }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("nodes", [Node?]?.self),
        ] }

        /// A list of nodes.
        public var nodes: [Node?]? { __data["nodes"] }

        /// CurrentUser.StarredProjects.Node
        ///
        /// Parent Type: `Project`
        public struct Node: GitLabAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.Project }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("avatarUrl", String?.self),
            .field("nameWithNamespace", String.self),
            .field("visibility", String?.self),
            .field("fullPath", GitLabAPI.ID.self),
          ] }

          /// URL to avatar image file of the project.
          public var avatarUrl: String? { __data["avatarUrl"] }
          /// Full name of the project with its namespace.
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
