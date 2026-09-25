import SwiftUI

struct InstancesListView: View {
	@State
	private var instances: [GitLabInstance] = InstanceManager.instances
	@State
	private var selectedId: String? = InstanceManager.selectedId

	private func select(_ instance: GitLabInstance) {
		InstanceManager.select(instance)
		Network.shared.resetApolloClient()
		instances = InstanceManager.instances
		selectedId = InstanceManager.selectedId
	}

	public var body: some View {
		List {
			if instances.isEmpty {
				NoContentView(
					"No Instances",
					systemImage: "server.rack"
				)
			} else {
				ForEach(instances) { instance in
					HStack {
						VStack(alignment: .leading) {
							Text(instance.host)
								.font(.headline)
							Text(instance.isOAuth ? "GitLab.com (OAuth)" : "Self-Hosted")
								.font(.caption)
								.foregroundStyle(.secondary)
						}

						Spacer()

						if instance.id == selectedId {
							Image(systemName: "checkmark.circle.fill")
								.foregroundColor(.accentColor)
						}
					}
					.contentShape(.rect)
					.onTapGesture {
						select(instance)
					}
				}
			}
		}
		.navigationTitle("Instances")
		.onAppear {
			WatchSync.shared.requestContextRefresh()
			instances = InstanceManager.instances
			selectedId = InstanceManager.selectedId
		}
	}
}

#Preview {
	NavigationStack {
		InstancesListView()
	}
}
