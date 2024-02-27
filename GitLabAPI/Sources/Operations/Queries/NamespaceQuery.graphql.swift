// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class NamespaceQuery: GraphQLQuery {
  public static let operationName: String = "Namespace"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query Namespace($fullPath: ID!) { namespace(fullPath: $fullPath) { __typename name fullName description projects { __typename nodes { __typename avatarUrl nameWithNamespace visibility fullPath } } } }"#
    ))

  public var fullPath: ID

  public init(fullPath: ID) {
    self.fullPath = fullPath
  }

  public var __variables: Variables? { ["fullPath": fullPath] }

  public struct Data: GitLabAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("namespace", Namespace?.self, arguments: ["fullPath": .variable("fullPath")]),
    ] }

    /// Find a namespace.
    public var namespace: Namespace? { __data["namespace"] }

    /// Namespace
    ///
    /// Parent Type: `Namespace`
    public struct Namespace: GitLabAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.Namespace }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("name", String.self),
        .field("fullName", String.self),
        .field("description", String?.self),
        .field("projects", Projects.self),
      ] }

      /// Name of the namespace.
      public var name: String { __data["name"] }
      /// Full name of the namespace.
      public var fullName: String { __data["fullName"] }
      /// Description of the namespace.
      public var description: String? { __data["description"] }
      /// Projects within this namespace.
      public var projects: Projects { __data["projects"] }

      /// Namespace.Projects
      ///
      /// Parent Type: `ProjectConnection`
      public struct Projects: GitLabAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.ProjectConnection }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("nodes", [Node?]?.self),
        ] }

        /// A list of nodes.
        public var nodes: [Node?]? { __data["nodes"] }

        /// Namespace.Projects.Node
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
