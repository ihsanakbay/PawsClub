//
//  LoginView.swift
//  PawsClub
//
//  Created by İhsan Akbay on 21.08.2022.
//

import SwiftUI

struct LoginView: View {
	
	@StateObject private var viewModel = LoginViewModel(service: LoginManager())
	
	@FocusState var isInputActive: Bool
	
	var body: some View {
		NavigationView {
			ZStack{
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
						CustomTextField(text: $viewModel.credentials.email, placeholder: "Email", systemImageName: "envelope.fill")
							.autocorrectionDisabled(true)
							.textInputAutocapitalization(.never)
						CustomTextField(text: $viewModel.credentials.password, placeholder: "Password", systemImageName: "lock.fill", isSecure: true)
							.autocorrectionDisabled(true)
							.textInputAutocapitalization(.never)
					}
					.padding([.top, .horizontal])
					
					NavigationLink {
						ForgotPasswordView()
					} label: {
						Text("Forgot Password?")
							.foregroundColor(Color.theme.pinkColor)
							.font(.subheadline)
					}
					.frame(maxWidth: .infinity, alignment: .trailing)
					.padding(.horizontal)
					.padding(.top, 4)
					
					Button {
						viewModel.login()
					} label: {
						Text("Login")
							.font(.system(size: 18, weight: .bold))
					}
					.customButton()
					
					Spacer()
					
					NavigationLink {
						RegisterView()
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
}

struct LoginView_Previews: PreviewProvider {
	static var previews: some View {
		LoginView()
	}
}
