// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

public struct UserReviewRequestedMergeRequestsQuery: GraphQLQuery {
  public static let operationName: String = "UserReviewRequestedMergeRequests"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query UserReviewRequestedMergeRequests { currentUser { __typename reviewRequestedMergeRequests(state: opened) { __typename count nodes { __typename project { __typename fullPath } iid title reference(full: true) state upvotes downvotes userNotesCount author { __typename avatarUrl name username } createdAt webUrl } } } }"#
    ))

  public init() {}

  public struct Data: GitLabAPI.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.Query }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("currentUser", CurrentUser?.self),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      UserReviewRequestedMergeRequestsQuery.Data.self
    ] }

    /// Get information about current user.
    public var currentUser: CurrentUser? { __data["currentUser"] }

    /// CurrentUser
    ///
    /// Parent Type: `CurrentUser`
    public struct CurrentUser: GitLabAPI.SelectionSet {
      @_spi(Unsafe) public let __data: DataDict
      @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

      @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.CurrentUser }
      @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("reviewRequestedMergeRequests", ReviewRequestedMergeRequests?.self, arguments: ["state": "opened"]),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        UserReviewRequestedMergeRequestsQuery.Data.CurrentUser.self
      ] }

      /// Merge requests assigned to the user for review.
      public var reviewRequestedMergeRequests: ReviewRequestedMergeRequests? { __data["reviewRequestedMergeRequests"] }

      /// CurrentUser.ReviewRequestedMergeRequests
      ///
      /// Parent Type: `MergeRequestConnection`
      public struct ReviewRequestedMergeRequests: GitLabAPI.SelectionSet {
        @_spi(Unsafe) public let __data: DataDict
        @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

        @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.MergeRequestConnection }
        @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("count", Int.self),
          .field("nodes", [Node?]?.self),
        ] }
        @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          UserReviewRequestedMergeRequestsQuery.Data.CurrentUser.ReviewRequestedMergeRequests.self
        ] }

        /// Total count of collection. Returns limit + 1 for counts greater than the limit.
        public var count: Int { __data["count"] }
        /// A list of nodes.
        public var nodes: [Node?]? { __data["nodes"] }

        /// CurrentUser.ReviewRequestedMergeRequests.Node
        ///
        /// Parent Type: `MergeRequest`
        public struct Node: GitLabAPI.SelectionSet {
          @_spi(Unsafe) public let __data: DataDict
          @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

          @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.MergeRequest }
          @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("project", Project.self),
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
          @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            UserReviewRequestedMergeRequestsQuery.Data.CurrentUser.ReviewRequestedMergeRequests.Node.self
          ] }

          /// Alias for target_project.
          public var project: Project { __data["project"] }
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
          /// User who created the merge request.
          public var author: Author? { __data["author"] }
          /// Timestamp of when the merge request was created.
          public var createdAt: GitLabAPI.Time { __data["createdAt"] }
          /// Web URL of the merge request.
          public var webUrl: String? { __data["webUrl"] }

          /// CurrentUser.ReviewRequestedMergeRequests.Node.Project
          ///
          /// Parent Type: `Project`
          public struct Project: GitLabAPI.SelectionSet {
            @_spi(Unsafe) public let __data: DataDict
            @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

            @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.Project }
            @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("fullPath", GitLabAPI.ID.self),
            ] }
            @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
              UserReviewRequestedMergeRequestsQuery.Data.CurrentUser.ReviewRequestedMergeRequests.Node.Project.self
            ] }

            /// Full path of the project.
            public var fullPath: GitLabAPI.ID { __data["fullPath"] }
          }

          /// CurrentUser.ReviewRequestedMergeRequests.Node.Author
          ///
          /// Parent Type: `MergeRequestAuthor`
          public struct Author: GitLabAPI.SelectionSet {
            @_spi(Unsafe) public let __data: DataDict
            @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

            @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.MergeRequestAuthor }
            @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("avatarUrl", String?.self),
              .field("name", String.self),
              .field("username", String.self),
            ] }
            @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
              UserReviewRequestedMergeRequestsQuery.Data.CurrentUser.ReviewRequestedMergeRequests.Node.Author.self
            ] }

            /// URL of the user's avatar.
            public var avatarUrl: String? { __data["avatarUrl"] }
            /// Human-readable name of the user. Returns `****` if the user is a project bot and the requester does not have permission to view the project.
            public var name: String { __data["name"] }
            /// Username of the user. Unique within the instance of GitLab.
            public var username: String { __data["username"] }
          }
        }
      }
    }
  }
}
