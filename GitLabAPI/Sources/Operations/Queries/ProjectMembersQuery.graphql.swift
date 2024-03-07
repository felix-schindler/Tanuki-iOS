// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class ProjectMembersQuery: GraphQLQuery {
  public static let operationName: String = "ProjectMembers"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query ProjectMembers($fullPath: ID!) { project(fullPath: $fullPath) { __typename projectMembers { __typename nodes { __typename id createdBy { __typename avatarUrl name username } createdAt expiresAt accessLevel { __typename stringValue } user { __typename avatarUrl name username } } } } }"#
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
      .field("project", Project?.self, arguments: ["fullPath": .variable("fullPath")]),
    ] }

    /// Find a project.
    public var project: Project? { __data["project"] }

    /// Project
    ///
    /// Parent Type: `Project`
    public struct Project: GitLabAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.Project }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("projectMembers", ProjectMembers?.self),
      ] }

      /// Members of the project.
      public var projectMembers: ProjectMembers? { __data["projectMembers"] }

      /// Project.ProjectMembers
      ///
      /// Parent Type: `MemberInterfaceConnection`
      public struct ProjectMembers: GitLabAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.MemberInterfaceConnection }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("nodes", [Node?]?.self),
        ] }

        /// A list of nodes.
        public var nodes: [Node?]? { __data["nodes"] }

        /// Project.ProjectMembers.Node
        ///
        /// Parent Type: `MemberInterface`
        public struct Node: GitLabAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Interfaces.MemberInterface }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", GitLabAPI.ID.self),
            .field("createdBy", CreatedBy?.self),
            .field("createdAt", GitLabAPI.Time?.self),
            .field("expiresAt", GitLabAPI.Time?.self),
            .field("accessLevel", AccessLevel?.self),
            .field("user", User?.self),
          ] }

          /// ID of the member.
          public var id: GitLabAPI.ID { __data["id"] }
          /// User that authorized membership.
          public var createdBy: CreatedBy? { __data["createdBy"] }
          /// Date and time the membership was created.
          public var createdAt: GitLabAPI.Time? { __data["createdAt"] }
          /// Date and time the membership expires.
          public var expiresAt: GitLabAPI.Time? { __data["expiresAt"] }
          /// GitLab::Access level.
          public var accessLevel: AccessLevel? { __data["accessLevel"] }
          /// User that is associated with the member object.
          public var user: User? { __data["user"] }

          /// Project.ProjectMembers.Node.CreatedBy
          ///
          /// Parent Type: `UserCore`
          public struct CreatedBy: GitLabAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.UserCore }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("avatarUrl", String?.self),
              .field("name", String.self),
              .field("username", String.self),
            ] }

            /// URL of the user's avatar.
            public var avatarUrl: String? { __data["avatarUrl"] }
            /// Human-readable name of the user. Returns `****` if the user is a project bot and the requester does not have permission to view the project.
            public var name: String { __data["name"] }
            /// Username of the user. Unique within this instance of GitLab.
            public var username: String { __data["username"] }
          }

          /// Project.ProjectMembers.Node.AccessLevel
          ///
          /// Parent Type: `AccessLevel`
          public struct AccessLevel: GitLabAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.AccessLevel }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("stringValue", GraphQLEnum<GitLabAPI.AccessLevelEnum>?.self),
            ] }

            /// String representation of access level.
            public var stringValue: GraphQLEnum<GitLabAPI.AccessLevelEnum>? { __data["stringValue"] }
          }

          /// Project.ProjectMembers.Node.User
          ///
          /// Parent Type: `UserCore`
          public struct User: GitLabAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.UserCore }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("avatarUrl", String?.self),
              .field("name", String.self),
              .field("username", String.self),
            ] }

            /// URL of the user's avatar.
            public var avatarUrl: String? { __data["avatarUrl"] }
            /// Human-readable name of the user. Returns `****` if the user is a project bot and the requester does not have permission to view the project.
            public var name: String { __data["name"] }
            /// Username of the user. Unique within this instance of GitLab.
            public var username: String { __data["username"] }
          }
        }
      }
    }
  }
}
