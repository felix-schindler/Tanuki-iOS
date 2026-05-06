// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct CurrentUserTodosQuery: GraphQLQuery {
  public static let operationName: String = "CurrentUserTodos"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query CurrentUserTodos { currentUser { __typename todos { __typename nodes { __typename id body group { __typename id } state action author { __typename avatarUrl name username } targetEntity { __typename webUrl } project { __typename avatarUrl fullPath nameWithNamespace visibility } createdAt targetType } } } }"#
    ))

  public init() {}

  nonisolated public struct Data: IOSGitLabAPI.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { IOSGitLabAPI.Objects.Query }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("currentUser", CurrentUser?.self),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      CurrentUserTodosQuery.Data.self
    ] }

    /// Get information about current user.
    public var currentUser: CurrentUser? { __data["currentUser"] }

    /// CurrentUser
    ///
    /// Parent Type: `CurrentUser`
    nonisolated public struct CurrentUser: IOSGitLabAPI.SelectionSet {
      @_spi(Unsafe) public let __data: DataDict
      @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

      @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { IOSGitLabAPI.Objects.CurrentUser }
      @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("todos", Todos?.self),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        CurrentUserTodosQuery.Data.CurrentUser.self
      ] }

      /// To-do items of the user.
      public var todos: Todos? { __data["todos"] }

      /// CurrentUser.Todos
      ///
      /// Parent Type: `TodoConnection`
      nonisolated public struct Todos: IOSGitLabAPI.SelectionSet {
        @_spi(Unsafe) public let __data: DataDict
        @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

        @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { IOSGitLabAPI.Objects.TodoConnection }
        @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("nodes", [Node?]?.self),
        ] }
        @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          CurrentUserTodosQuery.Data.CurrentUser.Todos.self
        ] }

        /// A list of nodes.
        public var nodes: [Node?]? { __data["nodes"] }

        /// CurrentUser.Todos.Node
        ///
        /// Parent Type: `Todo`
        nonisolated public struct Node: IOSGitLabAPI.SelectionSet {
          @_spi(Unsafe) public let __data: DataDict
          @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

          @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { IOSGitLabAPI.Objects.Todo }
          @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", IOSGitLabAPI.ID.self),
            .field("body", String.self),
            .field("group", Group?.self),
            .field("state", GraphQLEnum<IOSGitLabAPI.TodoStateEnum>.self),
            .field("action", GraphQLEnum<IOSGitLabAPI.TodoActionEnum>.self),
            .field("author", Author.self),
            .field("targetEntity", TargetEntity?.self),
            .field("project", Project?.self),
            .field("createdAt", IOSGitLabAPI.Time.self),
            .field("targetType", GraphQLEnum<IOSGitLabAPI.TodoTargetEnum>.self),
          ] }
          @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            CurrentUserTodosQuery.Data.CurrentUser.Todos.Node.self
          ] }

          /// ID of the to-do item.
          public var id: IOSGitLabAPI.ID { __data["id"] }
          /// Body of the to-do item.
          public var body: String { __data["body"] }
          /// Group the to-do item is associated with.
          public var group: Group? { __data["group"] }
          /// State of the to-do item.
          public var state: GraphQLEnum<IOSGitLabAPI.TodoStateEnum> { __data["state"] }
          /// Action of the to-do item.
          public var action: GraphQLEnum<IOSGitLabAPI.TodoActionEnum> { __data["action"] }
          /// Author of the to-do item.
          public var author: Author { __data["author"] }
          /// Target of the to-do item.
          public var targetEntity: TargetEntity? { __data["targetEntity"] }
          /// Project the to-do item is associated with.
          public var project: Project? { __data["project"] }
          /// Timestamp the to-do item was created.
          public var createdAt: IOSGitLabAPI.Time { __data["createdAt"] }
          /// Target type of the to-do item.
          public var targetType: GraphQLEnum<IOSGitLabAPI.TodoTargetEnum> { __data["targetType"] }

          /// CurrentUser.Todos.Node.Group
          ///
          /// Parent Type: `Group`
          nonisolated public struct Group: IOSGitLabAPI.SelectionSet {
            @_spi(Unsafe) public let __data: DataDict
            @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

            @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { IOSGitLabAPI.Objects.Group }
            @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("id", IOSGitLabAPI.ID?.self),
            ] }
            @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
              CurrentUserTodosQuery.Data.CurrentUser.Todos.Node.Group.self
            ] }

            /// ID of the group.
            public var id: IOSGitLabAPI.ID? { __data["id"] }
          }

          /// CurrentUser.Todos.Node.Author
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
              CurrentUserTodosQuery.Data.CurrentUser.Todos.Node.Author.self
            ] }

            /// URL of the user's avatar.
            public var avatarUrl: String? { __data["avatarUrl"] }
            /// Human-readable name of the user. Returns `****` if the user is a project bot and the requester does not have permission to view the project.
            public var name: String { __data["name"] }
            /// Username of the user. Unique within the instance of GitLab.
            public var username: String { __data["username"] }
          }

          /// CurrentUser.Todos.Node.TargetEntity
          ///
          /// Parent Type: `Todoable`
          nonisolated public struct TargetEntity: IOSGitLabAPI.SelectionSet {
            @_spi(Unsafe) public let __data: DataDict
            @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

            @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { IOSGitLabAPI.Interfaces.Todoable }
            @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("webUrl", String?.self),
            ] }
            @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
              CurrentUserTodosQuery.Data.CurrentUser.Todos.Node.TargetEntity.self
            ] }

            /// URL of the object.
            public var webUrl: String? { __data["webUrl"] }
          }

          /// CurrentUser.Todos.Node.Project
          ///
          /// Parent Type: `Project`
          nonisolated public struct Project: IOSGitLabAPI.SelectionSet {
            @_spi(Unsafe) public let __data: DataDict
            @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

            @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { IOSGitLabAPI.Objects.Project }
            @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("avatarUrl", String?.self),
              .field("fullPath", IOSGitLabAPI.ID.self),
              .field("nameWithNamespace", String.self),
              .field("visibility", String?.self),
            ] }
            @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
              CurrentUserTodosQuery.Data.CurrentUser.Todos.Node.Project.self
            ] }

            /// Avatar URL of the project.
            public var avatarUrl: String? { __data["avatarUrl"] }
            /// Full path of the project.
            public var fullPath: IOSGitLabAPI.ID { __data["fullPath"] }
            /// Name of the project including the namespace.
            public var nameWithNamespace: String { __data["nameWithNamespace"] }
            /// Visibility of the project.
            public var visibility: String? { __data["visibility"] }
          }
        }
      }
    }
  }
}
