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
						#if !SKIP_BRIDGE
							.contentShape(.rect)
						#endif
						.onTapGesture {
							Task {
								await Auth.switchInstance(to: instance)
								refresh()
							}
						}
						.swipeActions(edge: .trailing) {
							Button(role: .destructive) {
								let wasSelected = instance.id == InstanceManager.selectedId
								InstanceManager.remove(instance)
								refresh()
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
								Image(systemName: "trash")
									.accessibilityLabel("Delete")
							}
						}
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
			refresh()
		}.toolbar {
			NavigationLink(destination: ConfigView(showSetup: nil)) {
				Label("Add Instance", systemImage: "plus")
			}
		}.navigationTitle("Instances")
	}
	private func refresh() {
		instances = InstanceManager.instances
		selectedId = InstanceManager.selectedId
	}
}
