//
//  SettingsView.swift
//  PawsClub
//
//  Created by İhsan Akbay on 29.08.2022.
//

import SwiftUI

struct SettingsView: View {
	@Environment(\.dismiss) var dismiss
	@EnvironmentObject var sessionService: SessionManager
	
	var body: some View {
		NavigationView(content: {
			List {
				Button {
					sessionService.logout()
					dismiss()
				} label: {
					Label("Logout", systemImage: "power.circle.fill")
						.foregroundColor(Color.theme.pinkColor)
				}
			}
			.navigationTitle("Settings")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					Button {
						dismiss()
					} label: {
						Text("Cancel")
					}
				}
			}
		})
		.tint(.red)
	}
}

struct SettingsView_Previews: PreviewProvider {
	static var previews: some View {
		SettingsView()
	}
}
