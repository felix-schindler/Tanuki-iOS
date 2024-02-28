// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class PorjectIssuesQuery: GraphQLQuery {
  public static let operationName: String = "PorjectIssues"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query PorjectIssues($fullPath: ID!) { project(fullPath: $fullPath) { __typename issuesEnabled userPermissions { __typename createIssue } issues(state: opened) { __typename nodes { __typename iid title reference(full: true) state upvotes downvotes userNotesCount author { __typename name } createdAt webUrl } } } }"#
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
        .field("issuesEnabled", Bool?.self),
        .field("userPermissions", UserPermissions.self),
        .field("issues", Issues?.self, arguments: ["state": "opened"]),
      ] }

      /// Indicates if Issues are enabled for the current user
      public var issuesEnabled: Bool? { __data["issuesEnabled"] }
      /// Permissions for the current user on the resource
      public var userPermissions: UserPermissions { __data["userPermissions"] }
      /// Issues of the project.
      public var issues: Issues? { __data["issues"] }

      /// Project.UserPermissions
      ///
      /// Parent Type: `ProjectPermissions`
      public struct UserPermissions: GitLabAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.ProjectPermissions }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("createIssue", Bool.self),
        ] }

        /// If `true`, the user can perform `create_issue` on this resource
        public var createIssue: Bool { __data["createIssue"] }
      }

      /// Project.Issues
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

        /// Project.Issues.Node
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

          /// Project.Issues.Node.Author
          ///
          /// Parent Type: `UserCore`
          public struct Author: GitLabAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.UserCore }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("name", String.self),
            ] }

            /// Human-readable name of the user. Returns `****` if the user is a project bot and the requester does not have permission to view the project.
            public var name: String { __data["name"] }
          }
        }
      }
    }
  }
}
