//
//  NewIssue.swift
//  Tanuki
//
//  Created by Felix Schindler on 27.02.24.
//

import SwiftUI

struct NewIssue: View {
	@Binding
	public var showNewIssue: Bool
	
	@State
	private var showError = false
	
	@State
	private var title = ""
	
	@State
	private var description = ""
	
	public var body: some View {
		VStack(alignment: .leading) {
			HStack {
				Text("New issue")
					.font(.title)
					.fontWeight(.bold)
				Spacer()
				CloseButton {
					showNewIssue = false
				}
			}
			
			VStack {
				TextField("Title", text: $title)
				TextField(
					"Description (Markdown supported)",
					text: $description,
					axis: .vertical
				).lineLimit(5...10)
			}.textFieldStyle(.roundedBorder)
			
			Spacer()
			
			VStack {
				Button(action: {
					if (title.isEmpty) {
						showError = true
					}
					showNewIssue = false
				}, label: {
					Label("Create issue", systemImage: "plus")
						.frame(maxWidth: .infinity)
				})
				.tint(.green)
				.controlSize(.large)
				.buttonStyle(.bordered)
			}
		}.alert("Failed to create new issue", isPresented: $showError, actions: {
			Button("OK") {
				showError = false
			}
		})
		.padding()
		.presentationDetents([.large, .medium])
	}
}

#Preview {
	NavigationStack {
	}.sheet(isPresented: .constant(true)) {
		NewIssue(showNewIssue: .constant(true))
	}
}
