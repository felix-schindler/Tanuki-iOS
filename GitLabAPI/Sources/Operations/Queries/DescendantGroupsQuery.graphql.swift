// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class DescendantGroupsQuery: GraphQLQuery {
  public static let operationName: String = "DescendantGroups"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query DescendantGroups($fullPath: ID!) { group(fullPath: $fullPath) { __typename descendantGroups { __typename nodes { __typename avatarUrl name fullPath visibility groupMembersCount projectsCount maxAccessLevel { __typename stringValue } } } } }"#
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
      .field("group", Group?.self, arguments: ["fullPath": .variable("fullPath")]),
    ] }

    /// Find a group.
    public var group: Group? { __data["group"] }

    /// Group
    ///
    /// Parent Type: `Group`
    public struct Group: GitLabAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.Group }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("descendantGroups", DescendantGroups?.self),
      ] }

      /// List of descendant groups of this group.
      public var descendantGroups: DescendantGroups? { __data["descendantGroups"] }

      /// Group.DescendantGroups
      ///
      /// Parent Type: `GroupConnection`
      public struct DescendantGroups: GitLabAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.GroupConnection }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("nodes", [Node?]?.self),
        ] }

        /// A list of nodes.
        public var nodes: [Node?]? { __data["nodes"] }

        /// Group.DescendantGroups.Node
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

          /// Group.DescendantGroups.Node.MaxAccessLevel
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
