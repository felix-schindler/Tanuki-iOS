// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct ProjectIssuesQuery: GraphQLQuery {
  public static let operationName: String = "ProjectIssues"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query ProjectIssues($fullPath: ID!, $state: IssuableState, $search: String, $confidential: Boolean, $subscribed: SubscriptionStatus, $types: [IssueType!]) { project(fullPath: $fullPath) { __typename id issuesEnabled userPermissions { __typename createIssue } issues( state: $state search: $search confidential: $confidential subscribed: $subscribed types: $types ) { __typename nodes { __typename iid title reference(full: true) state upvotes downvotes userNotesCount author { __typename avatarUrl name username } createdAt webUrl } } } }"#
    ))

  public var fullPath: ID
  public var state: GraphQLNullable<GraphQLEnum<IssuableState>>
  public var search: GraphQLNullable<String>
  public var confidential: GraphQLNullable<Bool>
  public var subscribed: GraphQLNullable<GraphQLEnum<SubscriptionStatus>>
  public var types: GraphQLNullable<[GraphQLEnum<IssueType>]>

  public init(
    fullPath: ID,
    state: GraphQLNullable<GraphQLEnum<IssuableState>>,
    search: GraphQLNullable<String>,
    confidential: GraphQLNullable<Bool>,
    subscribed: GraphQLNullable<GraphQLEnum<SubscriptionStatus>>,
    types: GraphQLNullable<[GraphQLEnum<IssueType>]>
  ) {
    self.fullPath = fullPath
    self.state = state
    self.search = search
    self.confidential = confidential
    self.subscribed = subscribed
    self.types = types
  }

  @_spi(Unsafe) public var __variables: Variables? { [
    "fullPath": fullPath,
    "state": state,
    "search": search,
    "confidential": confidential,
    "subscribed": subscribed,
    "types": types
  ] }

  nonisolated public struct Data: IOSGitLabAPI.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { IOSGitLabAPI.Objects.Query }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("project", Project?.self, arguments: ["fullPath": .variable("fullPath")]),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      ProjectIssuesQuery.Data.self
    ] }

    /// Find a project.
    public var project: Project? { __data["project"] }

    /// Project
    ///
    /// Parent Type: `Project`
    nonisolated public struct Project: IOSGitLabAPI.SelectionSet {
      @_spi(Unsafe) public let __data: DataDict
      @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

      @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { IOSGitLabAPI.Objects.Project }
      @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", IOSGitLabAPI.ID.self),
        .field("issuesEnabled", Bool?.self),
        .field("userPermissions", UserPermissions.self),
        .field("issues", Issues?.self, arguments: [
          "state": .variable("state"),
          "search": .variable("search"),
          "confidential": .variable("confidential"),
          "subscribed": .variable("subscribed"),
          "types": .variable("types")
        ]),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        ProjectIssuesQuery.Data.Project.self
      ] }

      /// ID of the project.
      public var id: IOSGitLabAPI.ID { __data["id"] }
      /// Indicates if Issues are enabled for the current user
      public var issuesEnabled: Bool? { __data["issuesEnabled"] }
      /// Permissions for the current user on the resource
      public var userPermissions: UserPermissions { __data["userPermissions"] }
      /// Issues of the project.
      public var issues: Issues? { __data["issues"] }

      /// Project.UserPermissions
      ///
      /// Parent Type: `ProjectPermissions`
      nonisolated public struct UserPermissions: IOSGitLabAPI.SelectionSet {
        @_spi(Unsafe) public let __data: DataDict
        @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

        @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { IOSGitLabAPI.Objects.ProjectPermissions }
        @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("createIssue", Bool.self),
        ] }
        @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          ProjectIssuesQuery.Data.Project.UserPermissions.self
        ] }

        /// If `true`, the user can perform `create_issue` on this resource
        public var createIssue: Bool { __data["createIssue"] }
      }

      /// Project.Issues
      ///
      /// Parent Type: `IssueConnection`
      nonisolated public struct Issues: IOSGitLabAPI.SelectionSet {
        @_spi(Unsafe) public let __data: DataDict
        @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

        @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { IOSGitLabAPI.Objects.IssueConnection }
        @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("nodes", [Node?]?.self),
        ] }
        @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          ProjectIssuesQuery.Data.Project.Issues.self
        ] }

        /// A list of nodes.
        public var nodes: [Node?]? { __data["nodes"] }

        /// Project.Issues.Node
        ///
        /// Parent Type: `Issue`
        nonisolated public struct Node: IOSGitLabAPI.SelectionSet {
          @_spi(Unsafe) public let __data: DataDict
          @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

          @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { IOSGitLabAPI.Objects.Issue }
          @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("iid", String.self),
            .field("title", String.self),
            .field("reference", String.self, arguments: ["full": true]),
            .field("state", GraphQLEnum<IOSGitLabAPI.IssueState>.self),
            .field("upvotes", Int.self),
            .field("downvotes", Int.self),
            .field("userNotesCount", Int.self),
            .field("author", Author.self),
            .field("createdAt", IOSGitLabAPI.Time.self),
            .field("webUrl", String.self),
          ] }
          @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            ProjectIssuesQuery.Data.Project.Issues.Node.self
          ] }

          /// Internal ID of the issue.
          public var iid: String { __data["iid"] }
          /// Title of the issue.
          public var title: String { __data["title"] }
          /// Internal reference of the issue. Returned in shortened format by default.
          public var reference: String { __data["reference"] }
          /// State of the issue.
          public var state: GraphQLEnum<IOSGitLabAPI.IssueState> { __data["state"] }
          /// Number of upvotes the issue has received.
          public var upvotes: Int { __data["upvotes"] }
          /// Number of downvotes the issue has received.
          public var downvotes: Int { __data["downvotes"] }
          /// Number of user notes of the issue.
          public var userNotesCount: Int { __data["userNotesCount"] }
          /// User that created the issue.
          public var author: Author { __data["author"] }
          /// Timestamp of when the issue was created.
          public var createdAt: IOSGitLabAPI.Time { __data["createdAt"] }
          /// Web URL of the issue.
          public var webUrl: String { __data["webUrl"] }

          /// Project.Issues.Node.Author
          ///
          /// Parent Type: `UserCore`
          nonisolated public struct Author: IOSGitLabAPI.SelectionSet {
            @_spi(Unsafe) public let __data: DataDict
            @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

            @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { IOSGitLabAPI.Objects.UserCore }
            @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("avatarUrl", String?.self),
              .field("name", String.self),
              .field("username", String.self),
            ] }
            @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
              ProjectIssuesQuery.Data.Project.Issues.Node.Author.self
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
