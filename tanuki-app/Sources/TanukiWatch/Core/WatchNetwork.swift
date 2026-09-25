#if os(watchOS)
	import Apollo
	import ApolloAPI
	import Foundation
	import WatchConnectivity

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
			// In-memory cache: the watch has little storage and instances can
			// switch at any time, so no on-disk SQLite cache like the phone app.
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
		nonisolated func graphQLInterceptors<Operation: GraphQLOperation>(for operation: Operation)
			-> [any GraphQLInterceptor]
		{
			return [
				AuthorizationInterceptor()
			]
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
#endif
