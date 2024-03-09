//
//  UserTodosLoader.swift
//  Tanuki
//
//  Created by Felix Schindler on 08.03.24.
//

import GitLabAPI
import SwiftUI

struct UserTodosLoader: View {
	private let username: String

	@State
	private var todos: [Todo?]? = nil

	@State
	private var loadFailed = false

	init(username: String) {
		self.username = username
	}

	private func loadTodos() {
		Network.shared.apollo.fetch(query: UserTodosQuery(username: self.username)) { result in
			switch result {
			case .success(let graphQLResult):
				print("Success! Setting todos...")
				todos = graphQLResult.data?.user?.todos?.nodes
			case .failure(let error):
				print("Failure! Error: \(error)")
				loadFailed = true
			}
		}
	}

	var body: some View {
		List {
			if let todos = self.todos {
				if todos.isEmpty {
					Text("There are no Todos")
				} else {
					ForEach(todos, id: \.?.id) { maybeTodo in
						if let todo = maybeTodo {
							TodoView(todo)
						}
					}
				}
			} else {
				VStack {
					if loadFailed {
						Text(failedToLoad)
					} else {
						ProgressView("Loading todos of \(self.username)")
					}
				}.frame(maxWidth: .infinity, minHeight: 100)
			}
		}.onAppear {
			loadTodos()
		}.refreshable {
			loadTodos()
		}.navigationTitle("Todos")
	}
}

#Preview {
	NavigationStack {
		UserTodosLoader(username: "felix-schindler")
	}
}
