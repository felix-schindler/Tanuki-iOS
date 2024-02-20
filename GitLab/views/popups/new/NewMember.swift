//
//  NewMember.swift
//  GitLab
//
//  Created by Felix Schindler on 05.05.23.
//

import SwiftUI

struct NewMember: View {
	@Environment(\.presentationMode)
	var presentationMode: Binding<PresentationMode>
	
	/// Project ID
	@State var id: Int
	/// Group ID
	@State var groupId: Int
	
	@State var username = ""
	@State var accessLevel: ProjectRole = .guest
	@State var setExpDate = false
	@State var expDate = Calendar.current.date(byAdding: .month, value: 1, to: Date())!
	
	@State var showError = false
	
	var body: some View {
		VStack {
			Form {
				Section {
					TextField("Username", text: $username)
						.autocorrectionDisabled(true)
					Picker("Role", selection: $accessLevel) {
						Text("Guest").tag(ProjectRole.guest)
						Text("Reporter").tag(ProjectRole.reporter)
						Text("Developer").tag(ProjectRole.developer)
						Text("Maintainer").tag(ProjectRole.maintainer)
						Text("Owner").tag(ProjectRole.owner)
					}
					
					Toggle("Set expiration (optional)", isOn: $setExpDate)
					if (setExpDate) {
						DatePicker("Due Date", selection: $expDate)
					}
				}.presentationDetents([.large, .medium, .fraction(0.45)])
			}
			
			HStack {
				Button("Cancel", role: .cancel) {
					self.dismiss()
				}.buttonStyle(.bordered)
					.tint(.red)
				AsyncButton("Add Member") {
					await addMember()
				}.buttonStyle(.borderedProminent)
					.controlSize(.large)
					.tint(.green)
			}
		}.alert("Failed to add member", isPresented: $showError, actions: {
			Button("OK") {
				showError = false
			}
		})
	}
	
	/// - returns Whether the user was added or not
	func addMember() async -> Void {
		if let user = (await API.get(type: [UserSmall].self, endpoint: "users", query: ["username": username]))?[0] {
			var memberDict = [
				"user_id": String(user.id),
				"access_level": String(accessLevel.rawValue)
			]
			
			if (setExpDate) {
				let inputFormatter = DateFormatter()
				inputFormatter.dateFormat = "yyyy-MM-dd"
				memberDict["expires_at"] = inputFormatter.string(from: expDate)
			}
			
			let endpoint: String = (id != 0 ? "projects/\(id)/members" : "groups/\(groupId)/members")
			if let _ = await API.req(type: UserSmall.self, method: .post, endpoint: endpoint, body: memberDict) {
				self.dismiss()
				return
			}
		}
		
		showError = true
	}
	
	func dismiss() -> Void {
		self.presentationMode.wrappedValue.dismiss()
	}
}

struct NewMember_Previews: PreviewProvider {
	static var previews: some View {
		@State var presented = true
		
		NavigationStack {
		}.sheet(isPresented: $presented) {
			NewMember(id: 33025310, groupId: 0)
		}
	}
}
