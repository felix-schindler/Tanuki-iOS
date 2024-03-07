// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class EpicQuery: GraphQLQuery {
  public static let operationName: String = "Epic"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query Epic($fullPath: ID!, $iid: ID!) { group(fullPath: $fullPath) { __typename avatarUrl epic(iid: $iid) { __typename iid title description reference(full: true) state dueDate createdAt webUrl startDate dueDate color textColor upvotes downvotes userNotesCount author { __typename avatarUrl name username } ancestors { __typename nodes { __typename iid } } blockedByEpics { __typename nodes { __typename iid } } children { __typename nodes { __typename iid } } userPermissions { __typename updateEpic createNote } labels { __typename nodes { __typename title color textColor } } notes { __typename nodes { __typename id author { __typename avatarUrl name username } maxAccessLevelOfAuthor body system systemNoteIconName createdAt updatedAt } } } } }"#
    ))

  public var fullPath: ID
  public var iid: ID

  public init(
    fullPath: ID,
    iid: ID
  ) {
    self.fullPath = fullPath
    self.iid = iid
  }

  public var __variables: Variables? { [
    "fullPath": fullPath,
    "iid": iid
  ] }

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
        .field("avatarUrl", String?.self),
        .field("epic", Epic?.self, arguments: ["iid": .variable("iid")]),
      ] }

      /// Avatar URL of the group.
      public var avatarUrl: String? { __data["avatarUrl"] }
      /// Find a single epic.
      public var epic: Epic? { __data["epic"] }

      /// Group.Epic
      ///
      /// Parent Type: `Epic`
      public struct Epic: GitLabAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.Epic }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("iid", GitLabAPI.ID.self),
          .field("title", String?.self),
          .field("description", String?.self),
          .field("reference", String.self, arguments: ["full": true]),
          .field("state", GraphQLEnum<GitLabAPI.EpicState>.self),
          .field("dueDate", GitLabAPI.Time?.self),
          .field("createdAt", GitLabAPI.Time?.self),
          .field("webUrl", String.self),
          .field("startDate", GitLabAPI.Time?.self),
          .field("color", String?.self),
          .field("textColor", String?.self),
          .field("upvotes", Int.self),
          .field("downvotes", Int.self),
          .field("userNotesCount", Int.self),
          .field("author", Author.self),
          .field("ancestors", Ancestors?.self),
          .field("blockedByEpics", BlockedByEpics?.self),
          .field("children", Children?.self),
          .field("userPermissions", UserPermissions.self),
          .field("labels", Labels?.self),
          .field("notes", Notes.self),
        ] }

        /// Internal ID of the epic.
        public var iid: GitLabAPI.ID { __data["iid"] }
        /// Title of the epic.
        public var title: String? { __data["title"] }
        /// Description of the epic.
        public var description: String? { __data["description"] }
        /// Internal reference of the epic. Returned in shortened format by default.
        public var reference: String { __data["reference"] }
        /// State of the epic.
        public var state: GraphQLEnum<GitLabAPI.EpicState> { __data["state"] }
        /// Due date of the epic.
        public var dueDate: GitLabAPI.Time? { __data["dueDate"] }
        /// Timestamp of when the epic was created.
        public var createdAt: GitLabAPI.Time? { __data["createdAt"] }
        /// Web URL of the epic.
        public var webUrl: String { __data["webUrl"] }
        /// Start date of the epic.
        public var startDate: GitLabAPI.Time? { __data["startDate"] }
        /// Color of the epic. Returns `null` if `epic_color_highlight` feature flag is disabled.
        public var color: String? { __data["color"] }
        /// Text color generated for the epic. Returns `null` if `epic_color_highlight` feature flag is disabled.
        public var textColor: String? { __data["textColor"] }
        /// Number of upvotes the epic has received.
        public var upvotes: Int { __data["upvotes"] }
        /// Number of downvotes the epic has received.
        public var downvotes: Int { __data["downvotes"] }
        /// Number of user notes of the epic.
        public var userNotesCount: Int { __data["userNotesCount"] }
        /// Author of the epic.
        public var author: Author { __data["author"] }
        /// Ancestors (parents) of the epic.
        public var ancestors: Ancestors? { __data["ancestors"] }
        /// Epics blocking this epic.
        public var blockedByEpics: BlockedByEpics? { __data["blockedByEpics"] }
        /// Children (sub-epics) of the epic.
        public var children: Children? { __data["children"] }
        /// Permissions for the current user on the resource
        public var userPermissions: UserPermissions { __data["userPermissions"] }
        /// Labels assigned to the epic.
        public var labels: Labels? { __data["labels"] }
        /// All notes on this noteable.
        public var notes: Notes { __data["notes"] }

        /// Group.Epic.Author
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

        /// Group.Epic.Ancestors
        ///
        /// Parent Type: `EpicConnection`
        public struct Ancestors: GitLabAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.EpicConnection }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("nodes", [Node?]?.self),
          ] }

          /// A list of nodes.
          public var nodes: [Node?]? { __data["nodes"] }

          /// Group.Epic.Ancestors.Node
          ///
          /// Parent Type: `Epic`
          public struct Node: GitLabAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.Epic }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("iid", GitLabAPI.ID.self),
            ] }

            /// Internal ID of the epic.
            public var iid: GitLabAPI.ID { __data["iid"] }
          }
        }

        /// Group.Epic.BlockedByEpics
        ///
        /// Parent Type: `EpicConnection`
        public struct BlockedByEpics: GitLabAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.EpicConnection }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("nodes", [Node?]?.self),
          ] }

          /// A list of nodes.
          public var nodes: [Node?]? { __data["nodes"] }

          /// Group.Epic.BlockedByEpics.Node
          ///
          /// Parent Type: `Epic`
          public struct Node: GitLabAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.Epic }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("iid", GitLabAPI.ID.self),
            ] }

            /// Internal ID of the epic.
            public var iid: GitLabAPI.ID { __data["iid"] }
          }
        }

        /// Group.Epic.Children
        ///
        /// Parent Type: `EpicConnection`
        public struct Children: GitLabAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.EpicConnection }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("nodes", [Node?]?.self),
          ] }

          /// A list of nodes.
          public var nodes: [Node?]? { __data["nodes"] }

          /// Group.Epic.Children.Node
          ///
          /// Parent Type: `Epic`
          public struct Node: GitLabAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.Epic }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("iid", GitLabAPI.ID.self),
            ] }

            /// Internal ID of the epic.
            public var iid: GitLabAPI.ID { __data["iid"] }
          }
        }

        /// Group.Epic.UserPermissions
        ///
        /// Parent Type: `EpicPermissions`
        public struct UserPermissions: GitLabAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.EpicPermissions }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("updateEpic", Bool.self),
            .field("createNote", Bool.self),
          ] }

          /// If `true`, the user can perform `update_epic` on this resource
          public var updateEpic: Bool { __data["updateEpic"] }
          /// If `true`, the user can perform `create_note` on this resource
          public var createNote: Bool { __data["createNote"] }
        }

        /// Group.Epic.Labels
        ///
        /// Parent Type: `LabelConnection`
        public struct Labels: GitLabAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.LabelConnection }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("nodes", [Node?]?.self),
          ] }

          /// A list of nodes.
          public var nodes: [Node?]? { __data["nodes"] }

          /// Group.Epic.Labels.Node
          ///
          /// Parent Type: `Label`
          public struct Node: GitLabAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.Label }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("title", String.self),
              .field("color", String.self),
              .field("textColor", String.self),
            ] }

            /// Content of the label.
            public var title: String { __data["title"] }
            /// Background color of the label.
            public var color: String { __data["color"] }
            /// Text color of the label.
            public var textColor: String { __data["textColor"] }
          }
        }

        /// Group.Epic.Notes
        ///
        /// Parent Type: `NoteConnection`
        public struct Notes: GitLabAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.NoteConnection }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("nodes", [Node?]?.self),
          ] }

          /// A list of nodes.
          public var nodes: [Node?]? { __data["nodes"] }

          /// Group.Epic.Notes.Node
          ///
          /// Parent Type: `Note`
          public struct Node: GitLabAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.Note }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("id", GitLabAPI.NoteID.self),
              .field("author", Author?.self),
              .field("maxAccessLevelOfAuthor", String?.self),
              .field("body", String.self),
              .field("system", Bool.self),
              .field("systemNoteIconName", String?.self),
              .field("createdAt", GitLabAPI.Time.self),
              .field("updatedAt", GitLabAPI.Time.self),
            ] }

            /// ID of the note.
            public var id: GitLabAPI.NoteID { __data["id"] }
            /// User who wrote this note.
            public var author: Author? { __data["author"] }
            /// Max access level of the note author in the project.
            public var maxAccessLevelOfAuthor: String? { __data["maxAccessLevelOfAuthor"] }
            /// Content of the note.
            public var body: String { __data["body"] }
            /// Indicates whether this note was created by the system or by a user.
            public var system: Bool { __data["system"] }
            /// Name of the icon corresponding to a system note.
            public var systemNoteIconName: String? { __data["systemNoteIconName"] }
            /// Timestamp of the note creation.
            public var createdAt: GitLabAPI.Time { __data["createdAt"] }
            /// Timestamp of the note's last activity.
            public var updatedAt: GitLabAPI.Time { __data["updatedAt"] }

            /// Group.Epic.Notes.Node.Author
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
