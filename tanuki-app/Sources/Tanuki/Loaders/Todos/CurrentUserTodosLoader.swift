//
//  CurrentUserTodosLoader.swift
//  Tanuki
//
//  Created by Felix Schindler on 08.03.24.
//

import GitLabAPI
import SwiftUI

struct CurrentUserTodosLoader: View {
	@State var todos: Result<[Todo], Error>? = nil

	private func loadTodos() {
		Task {
			do {
				let todos = try await Network.shared.service.fetchCurrentUserTodos()
				self.todos = .success(todos)
			} catch let error {
				todos = .failure(error)
				Notify.status(.error)
			}
		}
	}

	public func reloadTodos() async {
		do {
			let todos = try await Network.shared.service.fetchCurrentUserTodos()
			self.todos = .success(todos)
			Notify.status(.success)
		} catch let error {
			todos = .failure(error)
			Notify.status(.error)
		}
	}

	public var body: some View {
		List {
			if let todos {
				switch todos {
				case .success(let todos):
					if todos.isEmpty {
						NoContentView(
							"All caught up!",
							systemImage: "checkmark.square",
							description: "There are no Todos"
						)
					} else {
						ForEach(todos, id: \.id) { todo in
							TodoView(todo)
						}
					}
				case .failure(let error):
					FailedView(error)
				}
			} else {
				LoadingView("Loading your Todos", systemImage: "checkmark.square")
			}
		}.onAppear {
			loadTodos()
		}.refreshable {
			await reloadTodos()
		}.navigationTitle("Todos")
	}
}

#Preview {
	NavigationView {
		CurrentUserTodosLoader()
	}
}
