//
//  AccountView.swift
//  GitLab
//
//  Created by Felix Schindler on 30.10.21.
//

import SwiftUI

struct AccountView: View {
	@State var user: User? = nil
	@State var status: UserStatus? = nil
	
	@State var showInfo: Bool = false
	@State var showSettings: Bool = false
	
	var body: some View {
		NavigationStack {
			UserLoader(loadSelf: true)
				.toolbar {
					Button (action: {showInfo = true}) {
						Image(systemName: "info.circle")
					}
					Button (action: {showSettings = true}) {
						Image(systemName: "gearshape")
					}
				}.sheet(isPresented: $showSettings) {
					SettingsView()
				}.sheet(isPresented: $showInfo) {
					InfoView()
				}
		}.navigationViewStyle(StackNavigationViewStyle())
	}
}

struct AccountView_Previews: PreviewProvider {
	static var previews: some View {
		AccountView()
	}
}
