//
//  UsersLoader.swift
//  Tanuki
//
//  Created by Felix Schindler on 12.10.25.
//

import GitLabAPI
import SwiftUI

struct UsersLoader: View {
	@State var users: Result<[Author], Error>? = nil

	@State var showFilters = false

	@State var loadTask: Task<Void, Never>?

	// MARK: - Filters
	@State public private(set) var search: String? = nil
	@State public private(set) var admins = false
	@State public private(set) var active: Bool? = nil
	@State public private(set) var humans: Bool? = nil

	// MARK: - Data loading
	private var filter: UsersFilter {
		return UsersFilter(
			search: self.search,
			admins: self.admins,
			active: self.active,
			humans: self.humans
		)
	}

	private func loadUsers() {
		self.loadTask?.cancel()
		self.loadTask = Task {
			do {
				let users = try await Network.shared.service.fetchUsers(filter: self.filter)
				if !Task.isCancelled {
					self.users = .success(users)
				}
			} catch {
				if !Task.isCancelled {
					self.users = .failure(error)
					Notify.status(.error)
				}
			}
		}
	}

	private func reloadUsers() async {
		do {
			let users = try await Network.shared.service.fetchUsers(filter: self.filter)
			self.users = .success(users)
			Notify.status(.success)
		} catch let error {
			self.users = .failure(error)
			Notify.status(.error)
		}
	}

	public var body: some View {
		List {
			if let users {
				switch users {
				case .success(let users):
					if users.isEmpty {
						NoContentView("There are no users", systemImage: "person.2")
					} else {
						ForEach(users, id: \.username) { user in
							AuthorView(user)
						}
					}
				case .failure(let error):
					FailedView(error)
				}
			} else {
				LoadingView("Loading Users", systemImage: "person.2")
			}
		}.onAppear {
			loadUsers()
		}.refreshable {
			await reloadUsers()
		}.toolbar {
			Button("Filter", systemImage: "line.3.horizontal.decrease") {
				showFilters = true
			}
		}.sheet(isPresented: $showFilters, onDismiss: { showFilters = false }) {
			NavigationView {
				Form {
					Section {
						VStack(alignment: .leading) {
							Toggle("Admins", isOn: $admins)
							Text("Return only admin users.")
								.foregroundStyle(.secondary)
								.font(.footnote)
						}
						Picker("Active", selection: $active) {
							Text("Any").tag(nil as Bool?)
							Text("Only active").tag(true)
							Text("Only non-active").tag(false)
						}
						Picker("Humans", selection: $humans) {
							Text("Any").tag(nil as Bool?)
							Text("Only not bot or internal users").tag(true)
							Text("Only bot or internal users").tag(false)
						}
					}
				}.toolbar {
					AsyncButton("Apply filter", systemImage: "checkmark") {
						await reloadUsers()
						self.showFilters = false
					}
				}
				.navigationBarTitleDisplayMode(.inline)
				.navigationTitle("Users Filter")
			}
		}.searchable(
			text: Binding(get: { self.search ?? "" }, set: { self.search = $0.isNotEmpty ? $0 : nil }),
			prompt: "Name, username, or primary email"
		).onChange(of: search) { _ in
			self.users = nil
			loadUsers()
		}.navigationTitle("Users")
	}
}

#Preview {
	UsersLoader()
}
