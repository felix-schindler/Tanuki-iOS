//
//  InstanceManager.swift
//  Tanuki
//
//  Created by Felix Schindler on 06.05.26.
//

import Foundation

struct GitLabInstance: Codable, Identifiable, Equatable {
	var id: String { host }
	let host: String
	let token: String
	let isOAuth: Bool

	init(host: String, token: String, isOAuth: Bool = false) {
		self.host = host
		self.token = token
		self.isOAuth = isOAuth
	}
}

@MainActor
class InstanceManager {
	private static let userDefaults = UserDefaults(suiteName: "group.de.schindlerfelix.GitLab")!
	private static let legacyUserDefaults = UserDefaults(suiteName: "de.schindlerfelix.GitLab")
	private static let instancesKey = "instances"
	private static let selectedKey = "selectedInstance"
	private static let legacyHostKey = "domain"
	private static let legacyTokenKey = "token"
	private static let migrationDoneKey = "migration_done"

	static var instances: [GitLabInstance] {
		get {
			guard let data = userDefaults.data(forKey: instancesKey),
				let instances = try? JSONDecoder().decode([GitLabInstance].self, from: data)
			else {
				return []
			}
			return instances
		}
		set {
			if let data = try? JSONEncoder().encode(newValue) {
				userDefaults.set(data, forKey: instancesKey)
			}
		}
	}

	static var selectedId: String? {
		get {
			userDefaults.string(forKey: selectedKey)
		}
		set {
			userDefaults.set(newValue, forKey: selectedKey)
		}
	}

	static var selected: GitLabInstance? {
		guard let id = selectedId else { return nil }
		return instances.first { $0.id == id }
	}

	static func migrate() {
		guard !userDefaults.bool(forKey: migrationDoneKey) else { return }

		let legacyStore = legacyUserDefaults
		let oldHost =
			legacyStore?.string(forKey: legacyHostKey)
			?? userDefaults.string(forKey: legacyHostKey)
			?? "gitlab.com"
		let oldToken =
			legacyStore?.string(forKey: legacyTokenKey)
			?? userDefaults.string(forKey: legacyTokenKey)
			?? ""

		guard oldHost.isNotEmpty || oldToken.isNotEmpty else {
			userDefaults.set(true, forKey: migrationDoneKey)
			return
		}

		let instance = GitLabInstance(
			host: oldHost,
			token: oldToken,
			isOAuth: oldHost == "gitlab.com" && oldToken.isNotEmpty
		)
		add(instance)

		userDefaults.removeObject(forKey: legacyHostKey)
		userDefaults.removeObject(forKey: legacyTokenKey)
		legacyStore?.removeObject(forKey: legacyHostKey)
		legacyStore?.removeObject(forKey: legacyTokenKey)
		userDefaults.set(true, forKey: migrationDoneKey)
		#if canImport(WatchConnectivity)
			WatchSync.shared.pushInstances()
		#endif
	}

	static func add(_ instance: GitLabInstance) {
		var current = instances
		current.removeAll { $0.id == instance.id }
		current.append(instance)
		instances = current
		selectedId = instance.id
		#if canImport(WatchConnectivity)
			WatchSync.shared.pushInstances()
		#endif
	}

	static func remove(_ instance: GitLabInstance) {
		var current = instances
		current.removeAll { $0.id == instance.id }
		instances = current

		if selectedId == instance.id {
			selectedId = current.last?.id
		}
		#if canImport(WatchConnectivity)
			WatchSync.shared.pushInstances()
		#endif
	}

	static func select(_ instance: GitLabInstance) {
		selectedId = instance.id
		#if canImport(WatchConnectivity)
			WatchSync.shared.pushInstances()
		#endif
	}

	static func update(_ instance: GitLabInstance) {
		remove(instance)
		add(instance)
		#if canImport(WatchConnectivity)
			WatchSync.shared.pushInstances()
		#endif
	}
}
