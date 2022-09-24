//
//  RegisterView.swift
//  PawsClub
//
//  Created by İhsan Akbay on 22.08.2022.
//

import SwiftUI

struct RegisterView: View {
	
	@Environment(\.dismiss) var dismiss
	@StateObject private var viewModel = RegisterViewModel(service: RegistrationManager())
	@FocusState var isInputActive: Bool
	
	var body: some View {
		ZStack {
			Color.theme.backgroundColor
				.ignoresSafeArea()
			
			if viewModel.isLoading {
				ProgressView()
					.progressViewStyle(CircularProgressViewStyle())
					.scaleEffect(1)
			}
			
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
					CustomTextField(text: $viewModel.userCredentials.email, placeholder: "Email", systemImageName: "envelope")
						.autocorrectionDisabled(true)
						.textInputAutocapitalization(.never)
					CustomTextField(text: $viewModel.userCredentials.password, placeholder: "Password", systemImageName: "lock", isSecure: true)
						.autocorrectionDisabled(true)
						.textInputAutocapitalization(.never)
					CustomTextField(text: $viewModel.userCredentials.fullname, placeholder: "Full Name", systemImageName: "person")
						.autocorrectionDisabled(true)
						.textInputAutocapitalization(.never)
					CustomTextField(text: $viewModel.userCredentials.username, placeholder: "Username", systemImageName: "at")
						.autocorrectionDisabled(true)
						.textInputAutocapitalization(.never)
					
				}
				.padding([.top, .horizontal])
				
				
				Button {
					viewModel.register()
				} label: {
					Text("Register")
						.font(.system(size: 18, weight: .bold))
				}
				.customButton()
				
				Spacer()
				
				Button {
					dismiss()
				} label: {
					Text("Already have an account? ")
						.foregroundColor(Color.theme.lightPinkColor)
						.font(.subheadline) +
					Text("Sign in")
						.foregroundColor(Color.theme.lightPinkColor)
						.font(.subheadline)
						.bold()
				}
				.frame(maxWidth: .infinity)
				.padding(.horizontal)
				.padding(.top, 4)
				
			}
			.navigationBarHidden(true)
			.alert(isPresented: $viewModel.hasError) {
				if case .failed(let error) = viewModel.state {
					return Alert(title: Text("Error"), message: Text(error.localizedDescription))
				} else {
					return Alert(title: Text("Error"), message: Text("Something went wrong!"))
				}
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
		RegisterView()
	}
}
