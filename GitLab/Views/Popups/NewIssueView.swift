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
            VStack {
                TextField("Title", text: $title)
                    .padding()
                    .background(Color(.systemGray5))
                    .cornerRadius(10)
                Text("Description")
                    .font(.headline)
                    .padding(.top)
                TextEditor(text: $description)
                    .padding()
                    .background(Color(.systemGray5))
                    .cornerRadius(10)
                    .frame(maxHeight: 250, alignment: .topLeading)
                Spacer()
                Button(action: {
                    isError = !saveNewIssue()
                    if (!isError) {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }, label: {
                    Text("Create new issue").frame(maxWidth: .infinity)
                }).alert(isPresented: $isError, content: {
                    Alert(title: Text("Error"), message: Text("Failed to create issue"), dismissButton: .default(Text("OK")))
                }).tint(.accentColor)
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle)
                .controlSize(.large)
            }.padding()
            .navigationBarTitle("New issue")
            .navigationBarItems(trailing: Button("Cancel", action: {self.presentationMode.wrappedValue.dismiss()}).foregroundColor(.red))
        }
    }

    private func saveNewIssue() -> Bool {
        do {
            let reqUrl: String = "projects/\(id)/issues?title=\(title.url())&description=\(description.url())"
            let apiData: Data? = API.POST(endpoint: reqUrl)
            if (apiData != nil) {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .custom(iso8601Decoder())
                _ = try decoder.decode(Issue.self, from: apiData!)
                return true
            }
        } catch let jsonError as NSError {
            print("JSON error \(jsonError.localizedDescription)")
        }
        return false
    }
}

struct NewIssueView_Previews: PreviewProvider {
    static var previews: some View {
        NewIssueView(id: Int())
    }
}
