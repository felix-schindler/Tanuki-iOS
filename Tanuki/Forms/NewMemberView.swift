//
//  NewMemberView.swift
//  Tanuki
//
//  Created by Felix Schindler on 20.09.25.
//

import SwiftUI

enum ProjectRole: Int {
	case minimal = 5
	case
		guest = 10
	case
		reporter = 20
	case
		developer = 30
	case
		maintainer = 40
	case
		owner = 50
}

struct NewMemberView: View {
	@Environment(\.presentationMode)
	var presentationMode: Binding<PresentationMode>

	/// Project ID
	@State public var id: Int
	/// Group ID
	@State public var groupId: Int

	@State private var username = ""
	@State private var accessLevel: ProjectRole = .guest
	@State private var setExpDate = false
	@State private var expDate = Calendar.current.date(byAdding: .month, value: 1, to: Date())!

	func addMember() async {
		do {
			if let currentUser =
				(try await API.get(
					type: [UserSmall?].self, endpoint: "users", query: ["username": username]))[0]
			{
				var memberDict = [
					"user_id": String(currentUser.id),
					"access_level": String(accessLevel.rawValue),
				]

				if setExpDate {
					let inputFormatter = DateFormatter()
					inputFormatter.dateFormat = "yyyy-MM-dd"
					memberDict["expires_at"] = inputFormatter.string(from: expDate)
				}

				let endpoint: String =
					(id != 0 ? "projects/\(id)/members" : "groups/\(groupId)/members")
				_ = try await API.req(
					type: UserSmall.self, method: .post, endpoint: endpoint, body: memberDict)
				self.dismiss()
			}
		} catch let error {
			Notify.status(.error, error.localizedDescription)
		}
	}

	private func dismiss() {
		self.presentationMode.wrappedValue.dismiss()
	}

	public var body: some View {
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
				if setExpDate {
					DatePicker("Due Date", selection: $expDate)
				}
			}.presentationDetents([.large, .medium])
		}.toolbar {
			AsyncButton("Add member", systemImage: "checkmark") {
				await addMember()
			}.tint(.accentColor)
		}.navigationTitle("New Member")
	}
}

#Preview {
	NavigationStack {
		NewMemberView(id: 1, groupId: 1)
	}
}
