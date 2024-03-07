// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class CurrentUserIssuesQuery: GraphQLQuery {
  public static let operationName: String = "CurrentUserIssues"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query CurrentUserIssues { currentUser { __typename projectMemberships { __typename nodes { __typename project { __typename fullPath issues(state: opened) { __typename nodes { __typename iid title reference(full: true) state upvotes downvotes userNotesCount author { __typename avatarUrl name username } createdAt webUrl } } } } } } }"#
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
        .field("projectMemberships", ProjectMemberships?.self),
      ] }

      /// Project memberships of the user.
      public var projectMemberships: ProjectMemberships? { __data["projectMemberships"] }

      /// CurrentUser.ProjectMemberships
      ///
      /// Parent Type: `ProjectMemberConnection`
      public struct ProjectMemberships: GitLabAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.ProjectMemberConnection }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("nodes", [Node?]?.self),
        ] }

        /// A list of nodes.
        public var nodes: [Node?]? { __data["nodes"] }

        /// CurrentUser.ProjectMemberships.Node
        ///
        /// Parent Type: `ProjectMember`
        public struct Node: GitLabAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.ProjectMember }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("project", Project?.self),
          ] }

          /// Project that User is a member of.
          public var project: Project? { __data["project"] }

          /// CurrentUser.ProjectMemberships.Node.Project
          ///
          /// Parent Type: `Project`
          public struct Project: GitLabAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.Project }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("fullPath", GitLabAPI.ID.self),
              .field("issues", Issues?.self, arguments: ["state": "opened"]),
            ] }

            /// Full path of the project.
            public var fullPath: GitLabAPI.ID { __data["fullPath"] }
            /// Issues of the project.
            public var issues: Issues? { __data["issues"] }

            /// CurrentUser.ProjectMemberships.Node.Project.Issues
            ///
            /// Parent Type: `IssueConnection`
            public struct Issues: GitLabAPI.SelectionSet {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.IssueConnection }
              public static var __selections: [ApolloAPI.Selection] { [
                .field("__typename", String.self),
                .field("nodes", [Node?]?.self),
              ] }

              /// A list of nodes.
              public var nodes: [Node?]? { __data["nodes"] }

              /// CurrentUser.ProjectMemberships.Node.Project.Issues.Node
              ///
              /// Parent Type: `Issue`
              public struct Node: GitLabAPI.SelectionSet {
                public let __data: DataDict
                public init(_dataDict: DataDict) { __data = _dataDict }

                public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.Issue }
                public static var __selections: [ApolloAPI.Selection] { [
                  .field("__typename", String.self),
                  .field("iid", GitLabAPI.ID.self),
                  .field("title", String.self),
                  .field("reference", String.self, arguments: ["full": true]),
                  .field("state", GraphQLEnum<GitLabAPI.IssueState>.self),
                  .field("upvotes", Int.self),
                  .field("downvotes", Int.self),
                  .field("userNotesCount", Int.self),
                  .field("author", Author.self),
                  .field("createdAt", GitLabAPI.Time.self),
                  .field("webUrl", String.self),
                ] }

                /// Internal ID of the issue.
                public var iid: GitLabAPI.ID { __data["iid"] }
                /// Title of the issue.
                public var title: String { __data["title"] }
                /// Internal reference of the issue. Returned in shortened format by default.
                public var reference: String { __data["reference"] }
                /// State of the issue.
                public var state: GraphQLEnum<GitLabAPI.IssueState> { __data["state"] }
                /// Number of upvotes the issue has received.
                public var upvotes: Int { __data["upvotes"] }
                /// Number of downvotes the issue has received.
                public var downvotes: Int { __data["downvotes"] }
                /// Number of user notes of the issue.
                public var userNotesCount: Int { __data["userNotesCount"] }
                /// User that created the issue.
                public var author: Author { __data["author"] }
                /// Timestamp of when the issue was created.
                public var createdAt: GitLabAPI.Time { __data["createdAt"] }
                /// Web URL of the issue.
                public var webUrl: String { __data["webUrl"] }

                /// CurrentUser.ProjectMemberships.Node.Project.Issues.Node.Author
                ///
                /// Parent Type: `UserCore`
                public struct Author: GitLabAPI.SelectionSet {
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
    }
  }
}
