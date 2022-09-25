//
//  ForgotPasswordView.swift
//  PawsClub
//
//  Created by İhsan Akbay on 22.08.2022.
//

import SwiftUI

struct ForgotPasswordView: View {
	@ObservedObject var viewModel: AuthViewModel
	@State private var emailAddress: String = ""
	@Environment(\.dismiss) var dismiss
	
	@FocusState var isInputActive: Bool
	
    var body: some View {
		NavigationView {
			VStack {
				CustomTextField(text: $emailAddress, placeholder: "Email", systemImageName: "envelope")
					.autocorrectionDisabled(true)
					.textInputAutocapitalization(.never)
					.padding(.horizontal)
				Button {
					viewModel.resetPassword(with: emailAddress)
					dismiss()
				} label: {
					Text("Reset Password")
						.font(.system(size: 18, weight: .bold))
				}
				.frame(height: 44)
				.frame(maxWidth: .infinity)
				.background(Color.theme.pinkColor)
				.foregroundColor(.white)
				.clipShape(Capsule())
				.padding()
			}
			.padding()
			.navigationTitle("Reset Password")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItemGroup(placement: .keyboard) {
					Spacer()

					Button("Done") {
						isInputActive = false
						hideKeyboard()
					}
				}
				ToolbarItem(placement: .navigationBarLeading) {
					Button(role: .destructive) {
						dismiss()
					} label: {
						Text("Cancel")
					}
					.foregroundColor(Color.theme.lightPinkColor)

				}
			}
		}
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
		ForgotPasswordView(viewModel: AuthViewModel())
    }
}
