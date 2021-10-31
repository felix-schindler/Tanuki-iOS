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
    
    @State var title: String = ""
    @State var description: String = ""
    
    @State var isError: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                TextField("New GitLab URL", text: $title)
                    .padding()
                    .background(Color(.systemGray5))
                    .cornerRadius(10)
                TextField("Description", text: $description)
                    .frame(maxHeight: 250, alignment: .topLeading)
                    .padding()
                    .background(Color(.systemGray5))
                    .cornerRadius(10)
                Spacer()
                Button("Save new issue") {
                    isError = !saveNewIssue()
                }.alert(isPresented: $isError, content: {
                    Alert(title: Text("Error"), message: Text("Failed to create issue"), dismissButton: .default(Text("OK")))
                })
            }.padding()
            .navigationBarTitle("New issue")
            .navigationBarItems(trailing: Button("Close", action: {self.presentationMode.wrappedValue.dismiss()}))
        }
    }
    
    private func saveNewIssue() -> Bool {
        return false
    }
}
