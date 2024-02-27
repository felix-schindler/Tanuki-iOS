// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class MergeRequestsQuery: GraphQLQuery {
  public static let operationName: String = "MergeRequests"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query MergeRequests($fullPath: ID!) { project(fullPath: $fullPath) { __typename mergeRequestsEnabled userPermissions { __typename createMergeRequestIn } mergeRequests(state: opened) { __typename nodes { __typename iid title reference(full: true) state upvotes downvotes userNotesCount author { __typename name } createdAt webUrl } } } }"#
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
        .field("mergeRequestsEnabled", Bool?.self),
        .field("userPermissions", UserPermissions.self),
        .field("mergeRequests", MergeRequests?.self, arguments: ["state": "opened"]),
      ] }

      /// Indicates if Merge Requests are enabled for the current user
      public var mergeRequestsEnabled: Bool? { __data["mergeRequestsEnabled"] }
      /// Permissions for the current user on the resource
      public var userPermissions: UserPermissions { __data["userPermissions"] }
      /// Merge requests of the project.
      public var mergeRequests: MergeRequests? { __data["mergeRequests"] }

      /// Project.UserPermissions
      ///
      /// Parent Type: `ProjectPermissions`
      public struct UserPermissions: GitLabAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.ProjectPermissions }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("createMergeRequestIn", Bool.self),
        ] }

        /// If `true`, the user can perform `create_merge_request_in` on this resource
        public var createMergeRequestIn: Bool { __data["createMergeRequestIn"] }
      }

      /// Project.MergeRequests
      ///
      /// Parent Type: `MergeRequestConnection`
      public struct MergeRequests: GitLabAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.MergeRequestConnection }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("nodes", [Node?]?.self),
        ] }

        /// A list of nodes.
        public var nodes: [Node?]? { __data["nodes"] }

        /// Project.MergeRequests.Node
        ///
        /// Parent Type: `MergeRequest`
        public struct Node: GitLabAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.MergeRequest }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("iid", String.self),
            .field("title", String.self),
            .field("reference", String.self, arguments: ["full": true]),
            .field("state", GraphQLEnum<GitLabAPI.MergeRequestState>.self),
            .field("upvotes", Int.self),
            .field("downvotes", Int.self),
            .field("userNotesCount", Int?.self),
            .field("author", Author?.self),
            .field("createdAt", GitLabAPI.Time.self),
            .field("webUrl", String?.self),
          ] }

          /// Internal ID of the merge request.
          public var iid: String { __data["iid"] }
          /// Title of the merge request.
          public var title: String { __data["title"] }
          /// Internal reference of the merge request. Returned in shortened format by default.
          public var reference: String { __data["reference"] }
          /// State of the merge request.
          public var state: GraphQLEnum<GitLabAPI.MergeRequestState> { __data["state"] }
          /// Number of upvotes for the merge request.
          public var upvotes: Int { __data["upvotes"] }
          /// Number of downvotes for the merge request.
          public var downvotes: Int { __data["downvotes"] }
          /// User notes count of the merge request.
          public var userNotesCount: Int? { __data["userNotesCount"] }
          /// User who created this merge request.
          public var author: Author? { __data["author"] }
          /// Timestamp of when the merge request was created.
          public var createdAt: GitLabAPI.Time { __data["createdAt"] }
          /// Web URL of the merge request.
          public var webUrl: String? { __data["webUrl"] }

          /// Project.MergeRequests.Node.Author
          ///
          /// Parent Type: `MergeRequestAuthor`
          public struct Author: GitLabAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.MergeRequestAuthor }
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
