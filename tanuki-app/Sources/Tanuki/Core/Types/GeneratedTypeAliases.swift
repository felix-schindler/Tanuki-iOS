//
//  GeneratedTypeAliases.swift
//  Tanuki
//
//  The generated `GitLabAPI` module declares the GraphQL custom scalars as
//  top-level typealiases (`Color` and `Date` are both `String`). Importing that
//  module alongside Foundation/SwiftUI therefore makes unqualified `Color` and
//  `Date` ambiguous. Module-local declarations take precedence over imported
//  ones, so this file restores the Foundation/SwiftUI meaning the app expects.
//  Use `GitLabAPI.Color` / `GitLabAPI.Date` explicitly for the GraphQL scalars.
//

import Foundation
import SwiftUI

typealias Color = SwiftUI.Color
typealias Date = Foundation.Date
