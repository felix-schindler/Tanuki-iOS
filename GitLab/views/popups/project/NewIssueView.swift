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
					).frame(minHeight: 150, alignment: .top)
				}.presentationDetents([.large, .fraction(0.45)])
			}
			
			HStack {
				Button("Cancel", role: .cancel) {
					self.presentationMode.wrappedValue.dismiss()
				}.tint(.red)
					.buttonStyle(.bordered)
				AsyncButton("Create issue") {
					isError = await !saveNewIssue()
					if (!isError) {
						self.presentationMode.wrappedValue.dismiss()
					}
				}.tint(.green)
					.controlSize(.large)
					.buttonStyle(.borderedProminent)
			}
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
