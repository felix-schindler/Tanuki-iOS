// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class GroupCustomEmojiQuery: GraphQLQuery {
  public static let operationName: String = "GroupCustomEmoji"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query GroupCustomEmoji($fullPath: ID!) { group(fullPath: $fullPath) { __typename customEmoji { __typename nodes { __typename id url name createdAt } } } }"#
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
        .field("customEmoji", CustomEmoji?.self),
      ] }

      /// Custom emoji in this namespace.
      public var customEmoji: CustomEmoji? { __data["customEmoji"] }

      /// Group.CustomEmoji
      ///
      /// Parent Type: `CustomEmojiConnection`
      public struct CustomEmoji: GitLabAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.CustomEmojiConnection }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("nodes", [Node?]?.self),
        ] }

        /// A list of nodes.
        public var nodes: [Node?]? { __data["nodes"] }

        /// Group.CustomEmoji.Node
        ///
        /// Parent Type: `CustomEmoji`
        public struct Node: GitLabAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.CustomEmoji }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", GitLabAPI.CustomEmojiID.self),
            .field("url", String.self),
            .field("name", String.self),
            .field("createdAt", GitLabAPI.Time.self),
          ] }

          /// ID of the emoji.
          public var id: GitLabAPI.CustomEmojiID { __data["id"] }
          /// Link to file of the emoji.
          public var url: String { __data["url"] }
          /// Name of the emoji.
          public var name: String { __data["name"] }
          /// Timestamp of when the custom emoji was created.
          public var createdAt: GitLabAPI.Time { __data["createdAt"] }
        }
      }
    }
  }
}
