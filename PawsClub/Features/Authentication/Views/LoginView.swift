//
//  LoginView.swift
//  PawsClub
//
//  Created by İhsan Akbay on 21.08.2022.
//

import SwiftUI

struct LoginView: View {
	@StateObject var viewModel: AuthViewModel
	@State private var isResetPasswordShowing: Bool = false
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
						CustomTextField(text: $viewModel.email, placeholder: "Email", systemImageName: "envelope.fill")
							.autocorrectionDisabled(true)
							.textInputAutocapitalization(.never)
						CustomTextField(text: $viewModel.password, placeholder: "Password", systemImageName: "lock.fill", isSecure: true)
							.autocorrectionDisabled(true)
							.textInputAutocapitalization(.never)
					}
					.padding([.top, .horizontal])
					
					Button {
						isResetPasswordShowing.toggle()
					} label: {
						Text("Forgot Password?")
							.foregroundColor(Color.theme.pinkColor)
							.font(.subheadline)
					}
					.frame(maxWidth: .infinity, alignment: .trailing)
					.padding(.horizontal)
					.padding(.top, 4)
					
					Button {
						Task {
							await viewModel.signIn()
						}
					} label: {
						Text("Login")
							.font(.system(size: 18, weight: .bold))
							.frame(height: 44)
							.frame(maxWidth: .infinity)
					}
					.disabled(viewModel.isValidForSignIn)
					.customButton()
					
					NavigationLink {
						RegisterView(viewModel: AuthViewModel(service: AuthenticationService()))
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
					
					Spacer()
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
			.sheet(isPresented: $isResetPasswordShowing) {
				ForgotPasswordView(viewModel: AuthViewModel(service: AuthenticationService()))
			}
		}
		.accentColor(Color.theme.pinkColor)
	}
}

struct LoginView_Previews: PreviewProvider {
	static var previews: some View {
		LoginView(viewModel: AuthViewModel(service: AuthenticationService()))
	}
}
