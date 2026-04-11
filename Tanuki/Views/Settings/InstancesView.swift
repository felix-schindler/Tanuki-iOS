//
//  InstancesView.swift
//  Tanuki
//
//  Created by Felix Schindler on 12.04.26.
//

import SwiftUI

struct InstancesView: View {
	@State
	private var showAddInstance = false

	var body: some View {
		List {
			if InstanceManager.instances.isEmpty {
				ContentUnavailableView(
					"No Instances",
					systemImage: "server.rack",
					description: Text("Add a GitLab instance to get started")
				)
			} else {
				Section {
					ForEach(InstanceManager.instances) { instance in
						HStack {
							VStack(alignment: .leading) {
								Text(instance.host)
									.font(.headline)
								Text(instance.isOAuth ? "GitLab.com (OAuth)" : "Self-Hosted")
									.font(.caption)
									.foregroundStyle(.secondary)
							}

							Spacer()

							if instance.id == InstanceManager.selectedId {
								Image(systemName: "checkmark.circle.fill")
									.foregroundStyle(.accentColor)
							}
						}
						.contentShape(.rect)
						.onTapGesture {
							InstanceManager.select(instance)
						}
						.swipeActions(edge: .trailing) {
							Button(role: .destructive) {
								InstanceManager.remove(instance)
							} label: {
								Label("Delete", systemImage: "trash")
							}
						}
					}
				} header: {
					Text("Instances")
				}
			}

			Section {
				NavigationLink(destination: ConfigView(showSetup: .constant(false))) {
					Label("Add Instance", systemImage: "plus.circle")
				}
			}
		}
		.navigationTitle("Instances")
	}
}

#Preview {
	NavigationView {
		InstancesView()
	}
}
