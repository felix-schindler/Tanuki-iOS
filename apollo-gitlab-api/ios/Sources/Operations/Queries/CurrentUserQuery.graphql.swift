// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct CurrentUserQuery: GraphQLQuery {
  public static let operationName: String = "CurrentUser"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query CurrentUser { currentUser { __typename id avatarUrl name username bot pronouns state status { __typename emoji message } bio location jobTitle organization createdAt discord twitter linkedin publicEmail groupCount webUrl } }"#
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
      CurrentUserQuery.Data.self
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
        .field("id", IOSGitLabAPI.UserID.self),
        .field("avatarUrl", String?.self),
        .field("name", String.self),
        .field("username", String.self),
        .field("bot", Bool.self),
        .field("pronouns", String?.self),
        .field("state", GraphQLEnum<IOSGitLabAPI.UserState>.self),
        .field("status", Status?.self),
        .field("bio", String?.self),
        .field("location", String?.self),
        .field("jobTitle", String?.self),
        .field("organization", String?.self),
        .field("createdAt", IOSGitLabAPI.Time?.self),
        .field("discord", String?.self),
        .field("twitter", String?.self),
        .field("linkedin", String?.self),
        .field("publicEmail", String?.self),
        .field("groupCount", Int?.self),
        .field("webUrl", String.self),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        CurrentUserQuery.Data.CurrentUser.self
      ] }

      /// Global ID of the user.
      public var id: IOSGitLabAPI.UserID { __data["id"] }
      /// URL of the user's avatar.
      public var avatarUrl: String? { __data["avatarUrl"] }
      /// Human-readable name of the user. Returns `****` if the user is a project bot and the requester does not have permission to view the project.
      public var name: String { __data["name"] }
      /// Username of the user. Unique within the instance of GitLab.
      public var username: String { __data["username"] }
      /// Indicates if the user is a bot.
      public var bot: Bool { __data["bot"] }
      /// Pronouns of the user.
      public var pronouns: String? { __data["pronouns"] }
      /// State of the user.
      public var state: GraphQLEnum<IOSGitLabAPI.UserState> { __data["state"] }
      /// User status.
      public var status: Status? { __data["status"] }
      /// Bio of the user.
      public var bio: String? { __data["bio"] }
      /// Location of the user.
      public var location: String? { __data["location"] }
      /// Job title of the user.
      public var jobTitle: String? { __data["jobTitle"] }
      /// Who the user represents or works for.
      public var organization: String? { __data["organization"] }
      /// Timestamp of when the user was created.
      public var createdAt: IOSGitLabAPI.Time? { __data["createdAt"] }
      /// Discord ID of the user.
      public var discord: String? { __data["discord"] }
      /// X (formerly Twitter) username of the user.
      public var twitter: String? { __data["twitter"] }
      /// LinkedIn profile name of the user.
      public var linkedin: String? { __data["linkedin"] }
      /// User's public email.
      public var publicEmail: String? { __data["publicEmail"] }
      /// Group count for the user.
      public var groupCount: Int? { __data["groupCount"] }
      /// Web URL of the user.
      public var webUrl: String { __data["webUrl"] }

      /// CurrentUser.Status
      ///
      /// Parent Type: `UserStatus`
      nonisolated public struct Status: IOSGitLabAPI.SelectionSet {
        @_spi(Unsafe) public let __data: DataDict
        @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

        @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { IOSGitLabAPI.Objects.UserStatus }
        @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("emoji", String?.self),
          .field("message", String?.self),
        ] }
        @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          CurrentUserQuery.Data.CurrentUser.Status.self
        ] }

        /// String representation of emoji.
        public var emoji: String? { __data["emoji"] }
        /// User status message.
        public var message: String? { __data["message"] }
      }
    }
  }
}
