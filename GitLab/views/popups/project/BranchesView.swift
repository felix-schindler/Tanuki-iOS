//
//  BranchesView.swift
//  GitLab
//
//  Created by Felix Schindler on 02.11.21.
//

import SwiftUI

struct BranchesView: View {
	@Environment(\.presentationMode)
	var presentationMode: Binding<PresentationMode>
	
	@State var id: Int
	
	@State var branches: [Branch]? = nil
	@State var loadFailed: Bool = false
	
	var body: some View {
		List {
			if (branches != nil) {
				if (branches!.isEmpty) {
					Text("You'll see your branches after you pushed them")
				} else {
					ForEach(branches!, id: \.name) { branch in
						HStack {
							VStack(alignment: .leading) {
								HStack {
									if (branch.protected) {
										Image(systemName: "lock")
									}
									Text(branch.name.emojized())
										.font(.headline)
								}

								VStack(alignment: .leading) {
									HStack {
										Text(branch.commit.shortId)
											.font(.system(.footnote, design: .monospaced))
										Text(branch.commit.authoredDate.toString())
									}
									Text(branch.commit.title.emojized())
								}.font(.footnote)
							}
							Spacer()
							PipelineLoader(id: id, branch: branch.name)
						}
					}
				}
			} else {
				if (loadFailed) {
					Text(Messages.failedToLoad)
						.foregroundStyle(.red)
				} else {
					ProgressView()
				}
			}
		}.onAppear {
			Task {
				await getBranches()
			}
		}.refreshable {
			await getBranches()
		}.navigationBarTitle("Branches")
	}
	
	private func getBranches() async -> Void {
		branches = await API.get(type: [Branch].self, endpoint: "projects/\(id)/repository/branches")
		loadFailed = branches == nil
	}
}

struct BranchesView_Previews: PreviewProvider {
	static var previews: some View {
		BranchesView(id: 33025310)
	}
}
