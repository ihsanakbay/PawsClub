//
//  ForgotPasswordView.swift
//  PawsClub
//
//  Created by İhsan Akbay on 22.08.2022.
//

import SwiftUI

struct ForgotPasswordView: View {
	@StateObject private var viewModel = ForgotPasswordViewModel(service: ForgotPasswordManager())
	@Environment(\.dismiss) var dismiss
	
	@FocusState var isInputActive: Bool
	
    var body: some View {
		NavigationView {
			VStack {
				CustomTextField(text: $viewModel.email, placeholder: "Email", systemImageName: "envelope")
					.autocorrectionDisabled(true)
					.textInputAutocapitalization(.never)
					.padding(.horizontal)
				Button {
					viewModel.sendPasswordReset()
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
        ForgotPasswordView()
    }
}
