//
//  NewNoteView.swift
//  GitLab
//
//  Created by Felix Schindler on 08.03.23.
//

import SwiftUI

struct NewNoteView: View {
	@Environment(\.presentationMode)
	var presentationMode: Binding<PresentationMode>
	
	@State var content: String = ""
	
	@State var isError: Bool = false
	
	@State var id: Int      // Project ID
	@State var iid: Int     // IID of Merge, Issue or Commit
	@State var type: discussionType // Whether it's an issue, commit or merge request
	
	var body: some View {
		NavigationStack {
			List {
				Section("Content") {
					TextEditor(text: $content)
				}
			}.alert(isPresented: $isError, content: {
				Alert(title: Text("Error"), message: Text("Failed to create note"), dismissButton: .default(Text("OK")))
			}).toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					Button("Cancel", role: .cancel) {
						self.presentationMode.wrappedValue.dismiss()
					}.foregroundStyle(.red)
				}
				ToolbarItem(placement: .navigationBarTrailing) {
					AsyncButton("Save") {
						isError = await !saveNewNote()
						if (!isError) {
							self.presentationMode.wrappedValue.dismiss()
						}
					}
				}
			}.navigationBarTitle("New note")
		}
	}
	
	private func saveNewNote() async -> Bool {
		let newIssue = await API.req(type: Note.self, method: .post, endpoint: "projects/\(id)/\(type.rawValue)/\(iid)/notes", query: ["body": content])
		return newIssue != nil
	}
}

struct NewNoteView_Previews: PreviewProvider {
	static var previews: some View {
		NewNoteView(id: 33025310, iid: 26, type: discussionType.Issue)
	}
}
