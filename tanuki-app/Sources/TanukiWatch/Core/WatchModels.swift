#if os(watchOS)
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

		static func select(_ instance: GitLabInstance) {
			selectedId = instance.id
			watchSelectedId = instance.id
		}

		/// Overwrite local state with instances pushed from the iPhone app, preserving
		/// the watch-side selection when it is still valid.
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
	class API {
		/// GitLab host
		public static var host: String {
			InstanceManager.selected?.host ?? "gitlab.com"
		}

		/// GitLab token
		public static var token: String {
			InstanceManager.selected?.token ?? ""
		}

		public static var url: URL {
			return URL(string: "https://\(host)")!
		}

		public static var graphUrl: URL {
			return URL(string: "https://\(host)/api/graphql")!
		}
	}

	struct MyAuthor: Codable {
		let avatarUrl: String?
		let name: String
		let username: String
	}
#endif
