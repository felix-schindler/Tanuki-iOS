//
//  InstancesView.swift
//  Tanuki
//
//  Created by Felix Schindler on 12.04.26.
//

import SwiftUI

struct InstancesView: View {
	@State var instances: [GitLabInstance] = InstanceManager.instances
	@State var selectedId: String? = InstanceManager.selectedId

	var body: some View {
		List {
			if instances.isEmpty {
				NoContentView(
					"No Instances",
					systemImage: "server.rack",
					description: "Add a GitLab instance to get started"
				)
			} else {
				Section {
					ForEach(instances) { instance in
						InstanceRowView(instance: instance, selectedId: selectedId, onUpdate: {
							instances = InstanceManager.instances
							selectedId = InstanceManager.selectedId
						})
					}
				} header: {
					Text("Instances")
				}
			}

			Section {
				NavigationLink(destination: ConfigView(showSetup: nil)) {
					Label("Add Instance", systemImage: "plus.circle")
				}
			}
		}.onAppear {
			instances = InstanceManager.instances
			selectedId = InstanceManager.selectedId
		}.toolbar {
			NavigationLink(destination: ConfigView(showSetup: nil)) {
				Label("Add Instance", systemImage: "plus")
			}
		}.navigationTitle("Instances")
	}
}

struct InstanceRowView: View {
	let instance: GitLabInstance
	let selectedId: String?
	let onUpdate: () -> Void

	var body: some View {
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
			Task {
				await Auth.switchInstance(to: instance)
				onUpdate()
			}
		}
		.swipeActions(edge: .trailing) {
			Button(role: .destructive) {
				let wasSelected = instance.id == InstanceManager.selectedId
				InstanceManager.remove(instance)
				onUpdate()
				if wasSelected {
					Task {
						if let next = InstanceManager.selected {
							await Auth.switchInstance(to: next)
						} else {
							await Auth.logout()
						}
					}
				}
			} label: {
				Label("Delete", systemImage: "trash").labelStyle(.iconOnly)
			}
		}
	}
}
