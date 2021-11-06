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
                TextField("Description", text: $description)
                    .frame(maxHeight: 250, alignment: .topLeading)
                    .padding()
                    .background(Color(.systemGray5))
                    .cornerRadius(10)
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
            .navigationBarItems(trailing: Button("Close", action: {self.presentationMode.wrappedValue.dismiss()}))
        }
    }

    private func saveNewIssue() -> Bool {
        do {
            let encTitle: String? = title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            let encDesc: String? = description.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            if (encTitle != nil || encDesc != nil) {
                let reqUrl: String = "projects/" + String(id) + "/issues?title=" + encTitle! + "&description=" + encDesc!
                let apiData: Data? = API.POST(endpoint: reqUrl)
                if (apiData != nil) {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    _ = try decoder.decode(Issue.self, from: apiData!)
                    return true
                }
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
