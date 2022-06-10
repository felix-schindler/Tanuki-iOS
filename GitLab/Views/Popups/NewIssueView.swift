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
                Section("Description - Not needed") {
                    TextEditor(text: $description)
                        .shadow(radius: 1)
                }
            }.alert(isPresented: $isError, content: {
                Alert(title: Text("Error"), message: Text("Failed to create issue"), dismissButton: .default(Text("OK")))
            }).navigationBarTitle("New issue")
            .navigationBarItems(leading: Button("Cancel", action: {
                self.presentationMode.wrappedValue.dismiss()
            }).foregroundColor(.red), trailing: Button("Save", action: {
                Task.init {
                    isError = await !saveNewIssue()
                    if (!isError) {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }))
        }
    }

    private func saveNewIssue() async -> Bool {
        let newIssue = await API.req(type: Issue.self, method: .post, endpoint: "projects/\(id)/issues?title=\(title.url())&description=\(description.url())")
        return newIssue != nil
    }
}

struct NewIssueView_Previews: PreviewProvider {
    static var previews: some View {
        NewIssueView(id: Int())
    }
}
