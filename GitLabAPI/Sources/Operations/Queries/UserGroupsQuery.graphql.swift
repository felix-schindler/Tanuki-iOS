// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class UserGroupsQuery: GraphQLQuery {
  public static let operationName: String = "UserGroups"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query UserGroups { currentUser { __typename groups { __typename nodes { __typename avatarUrl name fullPath visibility groupMembersCount projectsCount maxAccessLevel { __typename stringValue } } } } }"#
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
        .field("groups", Groups?.self),
      ] }

      /// Groups where the user has access.
      public var groups: Groups? { __data["groups"] }

      /// CurrentUser.Groups
      ///
      /// Parent Type: `GroupConnection`
      public struct Groups: GitLabAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.GroupConnection }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("nodes", [Node?]?.self),
        ] }

        /// A list of nodes.
        public var nodes: [Node?]? { __data["nodes"] }

        /// CurrentUser.Groups.Node
        ///
        /// Parent Type: `Group`
        public struct Node: GitLabAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.Group }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("avatarUrl", String?.self),
            .field("name", String.self),
            .field("fullPath", GitLabAPI.ID.self),
            .field("visibility", String?.self),
            .field("groupMembersCount", Int.self),
            .field("projectsCount", Int.self),
            .field("maxAccessLevel", MaxAccessLevel.self),
          ] }

          /// Avatar URL of the group.
          public var avatarUrl: String? { __data["avatarUrl"] }
          /// Name of the namespace.
          public var name: String { __data["name"] }
          /// Full path of the namespace.
          public var fullPath: GitLabAPI.ID { __data["fullPath"] }
          /// Visibility of the namespace.
          public var visibility: String? { __data["visibility"] }
          /// Count of direct members of this group.
          public var groupMembersCount: Int { __data["groupMembersCount"] }
          /// Count of direct projects in this group.
          public var projectsCount: Int { __data["projectsCount"] }
          /// The maximum access level of the current user in the group.
          public var maxAccessLevel: MaxAccessLevel { __data["maxAccessLevel"] }

          /// CurrentUser.Groups.Node.MaxAccessLevel
          ///
          /// Parent Type: `AccessLevel`
          public struct MaxAccessLevel: GitLabAPI.SelectionSet {
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
        }
      }
    }
  }
}
