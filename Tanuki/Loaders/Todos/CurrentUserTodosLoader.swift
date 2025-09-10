//
//  CurrentUserTodosLoader.swift
//  Tanuki
//
//  Created by Felix Schindler on 08.03.24.
//

import GitLabAPI
import SwiftUI

struct CurrentUserTodosLoader: View {
	@State
	private var todos: Result<[Todo?], Error>? = nil

	@State
	private var isLoading = false

	private func loadTodos() {
		isLoading = true

		defer {
			isLoading = false
		}

		do {
			let responses = try Network.shared.apollo.fetch(
				query: CurrentUserTodosQuery(), cachePolicy: .cacheAndNetwork)

			Task {
				for try await response in responses {
					if let todos = response.data?.currentUser?.todos?.nodes {
						self.todos = .success(todos)
						Notify.status(.success)
					} else if let errors = response.errors {
						for error in errors {
							Notify.status(.error, error.localizedDescription)
						}
					}
				}
			}
		} catch let error {
			todos = .failure(error)
			Notify.status(.error)
		}
	}

	public func reloadTodos() async {
		do {
			let response = try await Network.shared.apollo.fetch(
				query: CurrentUserTodosQuery(), cachePolicy: .networkOnly)

			if let todos = response.data?.currentUser?.todos?.nodes {
				self.todos = .success(todos)
			}

			Notify.status(.success)
		} catch let error {
			todos = .failure(error)
			Notify.status(.error)
		}
	}

	public var body: some View {
		List {
			if isLoading {
				ProgressView("Loading your todos")
			} else if let todos {
				switch todos {
				case .success(let todos):
					if todos.isEmpty {
						ContentUnavailableView(
							"All caught up!", systemImage: "checkmark.square",
							description: Text("There are no Todos"))
					} else {
						ForEach(todos, id: \.?.id) { maybeTodo in
							if let todo = maybeTodo {
								TodoView(todo)
							}
						}
					}
				case .failure(let error):
					FailedView(error)
				}
			}
		}.onAppear {
			loadTodos()
		}.refreshable {
			await reloadTodos()
		}.navigationTitle("Todos")
	}
}

#Preview {
	NavigationStack {
		CurrentUserTodosLoader()
	}
}
