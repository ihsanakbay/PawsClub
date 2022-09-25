//
//  SettingsView.swift
//  PawsClub
//
//  Created by İhsan Akbay on 25.09.2022.
//

import SwiftUI

struct SettingsView: View {
	@EnvironmentObject var viewModel: AuthViewModel
	@Environment(\.dismiss) private var dismiss
	
	var body: some View {
		NavigationView(content: {
			List {
				Button {
					viewModel.signOut()
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
