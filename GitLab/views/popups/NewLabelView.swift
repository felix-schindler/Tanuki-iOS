//
//  NewLabelView.swift
//  GitLab
//
//  Created by Felix Schindler on 23.03.23.
//

import SwiftUI
import NVMColor

struct NewLabelView: View {
	@Environment(\.presentationMode)
	var presentationMode: Binding<PresentationMode>
	
	/// Project ID
	@State var id: Int
	/// Group ID
	@State var groupId: Int
	
	@State var title: String = ""
	@State var description: String = ""
	@State var color: Color = Color(.red)
	
	@State var prio: Int = -1
	
	@State var isError: Bool = false
	
	var body: some View {
		NavigationView {
			List {
				Section("Title") {
					TextField("enhancement", text: $title)
				}
				
				Section("Details") {
					TextField("Description - NOT NEEDED", text: $description)
					ColorPicker("Background color", selection: $color)
					
					Stepper("Priority: \(prio < 0 ? "none" : String(prio))", value: $prio)
				}
			}.toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					Button("Cancel", role: .cancel) {
						self.presentationMode.wrappedValue.dismiss()
					}.foregroundColor(.red)
				}
				ToolbarItem(placement: .navigationBarTrailing) {
					AsyncButton("Save") {
						isError = await !saveNewLabel()
						if (!isError) {
							self.presentationMode.wrappedValue.dismiss()
						}
					}
				}
			}.alert(isPresented: $isError, content: {
				Alert(title: Text("Error"), message: Text("Failed to create new label"), dismissButton: .default(Text("OK")))
			}).navigationBarTitle("New label")
		}
	}
	
	private func saveNewLabel() async -> Bool {
		var query: Dictionary<String, String> = [
			"name": title,
			"color": "#\(color.hex!.dropLast(2))",
		]
		
		if (description != "") {
			query["description"] = description
		}
		
		if (prio >= 0) {
			query["priority"] = String(prio)
		}
		
		let newLabel = await API.req(
			type: APILabel.self,
			method: .post,
			endpoint: (id != 0 ? "projects/\(id)/labels" : "groups/\(id)/labels"),
			query: query
		)
		return newLabel != nil
	}
}

struct NewLabelView_Previews: PreviewProvider {
	static var previews: some View {
		NewLabelView(id: 33025310, groupId: 0)
	}
}
