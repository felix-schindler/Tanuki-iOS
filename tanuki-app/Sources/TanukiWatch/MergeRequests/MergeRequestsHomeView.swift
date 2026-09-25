import SwiftUI

struct MergeRequestsHomeView: View {
	public var body: some View {
		List {
			NavigationLink("Assigned", destination: UserMergeLoader(.assigned))
			NavigationLink("Authored", destination: UserMergeLoader(.authored))
			NavigationLink("Review Requested", destination: UserMergeLoader(.reviewRequested))
		}
		.navigationTitle("Merge Requests")
	}
}

#Preview {
	NavigationStack {
		MergeRequestsHomeView()
	}
}
