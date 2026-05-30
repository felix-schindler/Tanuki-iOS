//
//  Network.swift
//  Tanuki
//
//  Created by Felix Schindler on 26.02.24.
//

import Foundation
import GitLabAPI

@MainActor
final class Network {
    static let shared = Network()

    private(set) var service: any GitLabServiceType

    init() {
        self.service = GitLabService.make(host: API.host, token: API.token)
    }

    func recreateService() {
        self.service = GitLabService.make(host: API.host, token: API.token)
    }
}
