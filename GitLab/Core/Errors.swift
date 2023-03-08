//
//  Errors.swift
//  GitLab
//
//  Created by Felix Schindler on 12.11.21.
//

import Foundation

enum DateError: String, Error {
    case invalidDate
}

enum UrlError: String, Error {
    case invalid
}
