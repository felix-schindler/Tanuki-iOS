//
//  TreeLoader.swift
//  GitLab
//
//  Created by Felix Schindler on 23.01.22.
//

import SwiftUI

struct TreeLoader: View {
	@State var tree: [TreeFile]? = nil
	@State var branches: [Branch]? = nil
	
	@State var loadFailed: Bool = false
	
	@State var id: Int
	@State var refName: String
	@State var filePath: String? = nil
	
	var body: some View {
		VStack {
			if (tree != nil) {
				List {
					if (branches != nil && filePath == nil) {
						Section {
							HStack {
								Text("Branch: ")
								Picker("", selection: $refName) {
									ForEach(branches!, id: \.name) { branch in
										Text(branch.name).tag(branch.name)
									}
								}.pickerStyle(.menu)
									.onChange(of: refName) { _ in
										Task.init {
											await getTree()
										}
									}
							}
						}
					}
					if (tree!.isEmpty) {
						Text("There are no files yet. You'll see them after you pushed them to branch \(refName)")
					} else {
						Section("Files") {
							ForEach(tree!, id: \.id) { file in
								if (file.type == "tree") {
									// TODO: NavigationView
									NavigationLink(destination: TreeLoader(id: id, refName: refName, filePath: file.path)) {
										HStack {
											Image(systemName: "folder")
											Text(file.path)
										}
									}
								} else {
									NavigationLink(destination: FileLoader(id: id, filePath: file.path, refName: refName)) {
										HStack {
											Image(systemName: "doc.text")
											Text(file.path)
										}
									}
								}
							}
						}
					}
				}.refreshable {
					await getTree()
					if (filePath == nil) {
						await getBranches()
					}
				}
			}
		}.onAppear(perform: {
			Task.init {
				await getTree()
				await getBranches()
				loadFailed = (tree == nil) || (branches == nil)
			}
		}).navigationTitle(filePath ?? "Files")
	}
	
	private func getTree() async -> Void {
		tree = await API.get(type: [TreeFile].self, endpoint: "projects/\(id)/repository/tree", query: ["ref": refName.url(), "path": filePath != nil ? filePath! : ""])
	}
	
	private func getBranches() async -> Void {
		branches = await API.get(type: [Branch].self, endpoint: "projects/\(id)/repository/branches")
	}
}

struct TreeLoader_Previews: PreviewProvider {
	static var previews: some View {
		TreeLoader(id: 0, refName: "")
	}
}
