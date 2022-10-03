//
//  RegisterView.swift
//  PawsClub
//
//  Created by İhsan Akbay on 22.08.2022.
//

import SwiftUI

struct RegisterView: View {
	@Environment(\.dismiss) var dismiss
	@StateObject var viewModel: AuthViewModel
	@FocusState var isInputActive: Bool
	
	var body: some View {
		ZStack {
			Color.theme.backgroundColor
				.ignoresSafeArea()
			
			VStack {
				HStack(spacing: 8) {
					Text("PAWS")
						.font(.system(size: 36, weight: .bold))
						.foregroundColor(Color.theme.pinkColor)
					Text("CLUB")
						.font(.system(size: 36, weight: .bold))
						.foregroundColor(Color.theme.blueColor)
				}
				.padding(.top, 32)
				.padding(.horizontal)
				
				VStack(alignment: .center, spacing: 8) {
					Text("Get Started")
						.font(.title)
						.bold()
						.opacity(0.6)
					Text("Create an account")
						.font(.subheadline)
						.bold()
						.opacity(0.6)
				}
				.padding()
				.frame(maxWidth: .infinity, alignment: .center)
				
				VStack(spacing: 8) {
					CustomTextField(text: $viewModel.email, placeholder: "Email", systemImageName: "envelope.fill")
						.autocorrectionDisabled(true)
						.textInputAutocapitalization(.never)
					CustomTextField(text: $viewModel.password, placeholder: "Password", systemImageName: "lock.fill", isSecure: true)
						.autocorrectionDisabled(true)
						.textInputAutocapitalization(.never)
					CustomTextField(text: $viewModel.username, placeholder: "Username", systemImageName: "at")
						.autocorrectionDisabled(true)
						.textInputAutocapitalization(.never)
					CustomTextField(text: $viewModel.fullname, placeholder: "Full Name", systemImageName: "person.fill")
						.autocorrectionDisabled(true)
						.textInputAutocapitalization(.never)
				}
				.padding([.top, .horizontal])
				
				Button {
					Task {
						await viewModel.signUp()
					}
				} label: {
					Text("Register")
						.font(.system(size: 18, weight: .bold))
						.frame(height: 44)
						.frame(maxWidth: .infinity)
				}
				.disabled(viewModel.isValidForSignUp)
				.customButton()
				
				Spacer()
			}
			.alert(isPresented: $viewModel.hasError) {
				Alert(title: Text("Error"), message: Text(viewModel.errorMessage))
			}
		}
		.toolbar {
			ToolbarItemGroup(placement: .keyboard) {
				Spacer()
				Button("Done") {
					isInputActive = false
					hideKeyboard()
				}
			}
		}
	}
}

struct RegisterView_Previews: PreviewProvider {
	static var previews: some View {
		RegisterView(viewModel: AuthViewModel(service: AuthenticationService()))
	}
}
