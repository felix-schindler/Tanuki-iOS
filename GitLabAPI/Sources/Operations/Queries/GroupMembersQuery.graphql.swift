// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class GroupMembersQuery: GraphQLQuery {
  public static let operationName: String = "GroupMembers"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query GroupMembers($fullPath: ID!) { group(fullPath: $fullPath) { __typename groupMembers { __typename nodes { __typename id createdBy { __typename avatarUrl name username } createdAt expiresAt accessLevel { __typename stringValue } user { __typename avatarUrl name username } } } } }"#
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
        .field("groupMembers", GroupMembers?.self),
      ] }

      /// A membership of a user within this group.
      public var groupMembers: GroupMembers? { __data["groupMembers"] }

      /// Group.GroupMembers
      ///
      /// Parent Type: `GroupMemberConnection`
      public struct GroupMembers: GitLabAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.GroupMemberConnection }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("nodes", [Node?]?.self),
        ] }

        /// A list of nodes.
        public var nodes: [Node?]? { __data["nodes"] }

        /// Group.GroupMembers.Node
        ///
        /// Parent Type: `GroupMember`
        public struct Node: GitLabAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.GroupMember }
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

          /// Group.GroupMembers.Node.CreatedBy
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

          /// Group.GroupMembers.Node.AccessLevel
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

          /// Group.GroupMembers.Node.User
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
