//
//  NewIssueView.swift
//  GitLab
//
//  Created by Felix Schindler on 31.10.21.
//

import SwiftUI

struct NewIssueView: View {
	@Environment(\.presentationMode)
	var presentationMode: Binding<PresentationMode>
	
	@State var id: Int
	@State var title: String = ""
	@State var description: String = ""
	
	@State var isError: Bool = false
	
	var body: some View {
		VStack {
			Form {
				Section {
					TextField("Title", text: $title)
					TextField(
						"Description (Markdown supported)",
						text: $description,
						axis: .vertical
					).frame(minHeight: 65, alignment: .top)
				}.presentationDetents([.large, .medium])
			}
			
			VStack {
				AsyncButton(action: {
					isError = await !saveNewIssue()
					if (!isError) {
						self.presentationMode.wrappedValue.dismiss()
					}
				}, label: {
					Text("Create Issue")
						.frame(maxWidth: .infinity)
				}).tint(.green)
					.buttonStyle(.bordered)
					.controlSize(.large)

				Button(role: .cancel,
					   action: {
					self.presentationMode.wrappedValue.dismiss()
				}, label: {
					Text("Cancel")
						.frame(maxWidth: .infinity)
				}).foregroundStyle(.secondary)
					.buttonStyle(.bordered)
					.controlSize(.large)
			}.padding()
		}.alert(isPresented: $isError, content: {
			Alert(title: Text("Error"), message: Text("Failed to create issue"), dismissButton: .default(Text("OK")))
		})
	}
	
	private func saveNewIssue() async -> Bool {
		let newIssue = await API.req(type: Issue.self, method: .post, endpoint: "projects/\(id)/issues", query: ["title": title, "description": description])
		return newIssue != nil
	}
}

struct NewIssueView_Previews: PreviewProvider {
	static var previews: some View {
		@State var presented = true
		
		NavigationStack {
		}.sheet(isPresented: $presented) {
			NewIssueView(id: Int())
		}
	}
}
