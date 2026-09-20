import SwiftUI

struct ContentView: View {
	var body: some View {
		TabView {
			NavigationStack {
				InstancesListView()
					.navigationTitle("Instances")
			}
			.tag(0)
			NavigationStack {
				UserIssuesLoader()
					.navigationTitle("Issues")
			}
			.tag(1)
			NavigationStack {
				MergeRequestsHomeView()
					.navigationTitle("Merge Requests")
			}
			.tag(2)
		}
	}
}

#Preview {
	ContentView()
}
