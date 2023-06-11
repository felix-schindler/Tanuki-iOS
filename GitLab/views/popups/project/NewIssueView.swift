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
		NavigationView {
			List {
				Section("Title") {
					TextField("🚀 To the moon", text: $title)
				}
				Section("Description - NOT NEEDED") {
					TextEditor(text: $description)
				}
			}.alert(isPresented: $isError, content: {
				Alert(title: Text("Error"), message: Text("Failed to create issue"), dismissButton: .default(Text("OK")))
			}).navigationBarTitle("New issue")
				.toolbar {
					ToolbarItem(placement: .navigationBarLeading) {
						Button("Cancel", role: .cancel, action: {
							self.presentationMode.wrappedValue.dismiss()
						}).foregroundColor(.red)
					}
					ToolbarItem(placement: .navigationBarTrailing) {
						AsyncButton("Save") {
							isError = await !saveNewIssue()
							if (!isError) {
								self.presentationMode.wrappedValue.dismiss()
							}
						}
					}
				}
		}
	}
	
	private func saveNewIssue() async -> Bool {
		let newIssue = await API.req(type: Issue.self, method: .post, endpoint: "projects/\(id)/issues", query: ["title": title, "description": description])
		return newIssue != nil
	}
}

struct NewIssueView_Previews: PreviewProvider {
	static var previews: some View {
		NewIssueView(id: Int())
	}
}
