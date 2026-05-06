//
//  Network.swift
//  Tanuki
//
//  Created by Felix Schindler on 26.02.24.
//

import Apollo
import ApolloAPI
import SwiftUI
import WatchConnectivity

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
	private static let instancesKey = "instances"
	private static let selectedKey = "selectedInstance"
	private static let watchSelectedKey = "watchSelectedInstance"

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

	static var watchSelectedId: String? {
		get {
			UserDefaults.standard.string(forKey: watchSelectedKey)
		}
		set {
			UserDefaults.standard.set(newValue, forKey: watchSelectedKey)
		}
	}

	static var selected: GitLabInstance? {
		guard let id = selectedId else { return nil }
		return instances.first { $0.id == id }
	}

	static func add(_ instance: GitLabInstance) {
		var current = instances
		current.removeAll { $0.id == instance.id }
		current.append(instance)
		instances = current
		selectedId = instance.id
	}

	static func remove(_ instance: GitLabInstance) {
		var current = instances
		current.removeAll { $0.id == instance.id }
		instances = current

		if selectedId == instance.id {
			selectedId = current.last?.id
		}
	}

	static func select(_ instance: GitLabInstance) {
		selectedId = instance.id
		watchSelectedId = instance.id
	}

	static func overwrite(instances: [GitLabInstance], selectedId: String?) {
		self.instances = instances
		let watchSelected = watchSelectedId
		let watchIsValid = watchSelected != nil && instances.contains { $0.id == watchSelected }
		if watchIsValid {
			self.selectedId = watchSelected
			return
		}

		let phoneIsValid = selectedId != nil && instances.contains { $0.id == selectedId }
		if phoneIsValid {
			self.selectedId = selectedId
			watchSelectedId = selectedId
			return
		}

		let fallback = instances.last?.id
		self.selectedId = fallback
		watchSelectedId = fallback
	}
}

@MainActor
final class WatchSync: NSObject, WCSessionDelegate {
	static let shared = WatchSync()
	private let decoder = JSONDecoder()
	private var didActivate = false

	func activate() {
		guard WCSession.isSupported() else { return }
		let session = WCSession.default
		session.delegate = self
		session.activate()
	}

	func requestContextRefresh() {
		guard WCSession.isSupported() else { return }
		let session = WCSession.default
		if !didActivate {
			activate()
		}
		apply(session.receivedApplicationContext)
	}

	private func apply(_ context: [String: Any]) {
		let data = context["instances"] as? Data
		let selectedId = context["selectedId"] as? String
		apply(instancesData: data, selectedId: selectedId)
	}

	private func apply(instancesData: Data?, selectedId: String?) {
		guard let data = instancesData,
			let instances = try? decoder.decode([GitLabInstance].self, from: data)
		else {
			return
		}
		InstanceManager.overwrite(instances: instances, selectedId: selectedId)
		Network.shared.resetApolloClient()
	}

	nonisolated func session(
		_ session: WCSession,
		activationDidCompleteWith activationState: WCSessionActivationState,
		error: Error?
	) {
		Task { @MainActor in
			didActivate = activationState == .activated
			if didActivate {
				requestContextRefresh()
			}
		}
	}

	nonisolated func session(
		_ session: WCSession,
		didReceiveApplicationContext applicationContext: [String: Any]
	) {
		let instancesData = applicationContext["instances"] as? Data
		let selectedId = applicationContext["selectedId"] as? String
		Task { @MainActor in
			apply(instancesData: instancesData, selectedId: selectedId)
		}
	}
}

@MainActor
class API {
	/// GitLab host
	public static var host: String {
		get {
			InstanceManager.selected?.host ?? "gitlab.com"
		}
		set {
			var instance = InstanceManager.selected ?? GitLabInstance(host: "gitlab.com", token: "")
			instance = GitLabInstance(host: newValue, token: instance.token, isOAuth: instance.isOAuth)
			InstanceManager.add(instance)
		}
	}

	/// GitLab token
	public static var token: String {
		get {
			InstanceManager.selected?.token ?? ""
		}
		set {
			var instance = InstanceManager.selected ?? GitLabInstance(host: "gitlab.com", token: "")
			instance = GitLabInstance(host: instance.host, token: newValue, isOAuth: instance.isOAuth)
			InstanceManager.add(instance)
		}
	}

	public static var url: URL {
		return URL(string: "https://\(host)")!
	}

	public static var graphUrl: URL {
		return URL(string: "https://\(host)/api/graphql")!
	}
}

@MainActor
final class Network {
	static let shared = Network()

	private(set) var apollo: ApolloClient

	init() {
		self.apollo = Network.buildApolloClient()
	}

	func resetApolloClient() {
		self.apollo = Network.buildApolloClient()
	}

	private static func buildApolloClient() -> ApolloClient {
		let store = ApolloStore(cache: InMemoryNormalizedCache())

		let transport = RequestChainNetworkTransport(
			urlSession: URLSession.shared,
			interceptorProvider: NetworkInterceptorProvider(),
			store: store,
			endpointURL: API.graphUrl
		)

		return ApolloClient(networkTransport: transport, store: store)
	}
}

@MainActor
final class AuthorizationInterceptor: GraphQLInterceptor {
	func intercept<Request: GraphQLRequest>(
		request: Request,
		next: NextInterceptorFunction<Request>
	) async throws -> InterceptorResultStream<Request> {
		var req = request
		req.addHeader(name: "Authorization", value: "Bearer \(API.token)")

		return await next(req)
	}
}

final class NetworkInterceptorProvider: InterceptorProvider {
	func graphQLInterceptors<Operation: GraphQLOperation>(for operation: Operation)
		-> [any GraphQLInterceptor]
	{
		return [
			AuthorizationInterceptor()
		]
	}
}
