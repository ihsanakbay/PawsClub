//
//  LoginView.swift
//  PawsClub
//
//  Created by İhsan Akbay on 21.08.2022.
//

import SwiftUI

struct LoginView: View {
	@EnvironmentObject private var viewModel: AuthViewModel
	@State private var emailAddress: String = ""
	@State private var password: String = ""
	@FocusState var isInputActive: Bool
	
	var body: some View {
		NavigationView {
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
						Text("Welcome Back")
							.font(.title)
							.bold()
							.opacity(0.6)
						Text("Sign in to continue")
							.font(.subheadline)
							.bold()
							.opacity(0.6)
					}
					.padding()
					.frame(maxWidth: .infinity, alignment: .center)
					
					VStack(spacing: 8) {
						CustomTextField(text: $emailAddress, placeholder: "Email", systemImageName: "envelope.fill")
							.autocorrectionDisabled(true)
							.textInputAutocapitalization(.never)
						CustomTextField(text: $password, placeholder: "Password", systemImageName: "lock.fill", isSecure: true)
							.autocorrectionDisabled(true)
							.textInputAutocapitalization(.never)
					}
					.padding([.top, .horizontal])
					
					NavigationLink {
						ForgotPasswordView(viewModel: AuthViewModel())
					} label: {
						Text("Forgot Password?")
							.foregroundColor(Color.theme.pinkColor)
							.font(.subheadline)
					}
					.frame(maxWidth: .infinity, alignment: .trailing)
					.padding(.horizontal)
					.padding(.top, 4)
					
					Button {
						viewModel.signIn(with: emailAddress, password: password)
					} label: {
						Text("Login")
							.font(.system(size: 18, weight: .bold))
					}
					.customButton()
					
					Spacer()
					
					NavigationLink {
						RegisterView(viewModel: AuthViewModel())
					} label: {
						Text("Don't have an account? ")
							.foregroundColor(Color.theme.pinkColor)
							.font(.subheadline) +
							Text("Sign up")
							.foregroundColor(Color.theme.pinkColor)
							.font(.subheadline)
							.bold()
					}
					.frame(maxWidth: .infinity)
					.padding(.horizontal)
					.padding(.top, 4)
				}
				.navigationBarHidden(true)
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
}

struct LoginView_Previews: PreviewProvider {
	static var previews: some View {
		LoginView()
	}
}
