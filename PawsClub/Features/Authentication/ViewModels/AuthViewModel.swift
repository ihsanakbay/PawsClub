//
//  AuthViewModel.swift
//  PawsClub
//
//  Created by İhsan Akbay on 25.09.2022.
//

import Firebase
import SwiftUI

enum RegistrationKeys: String {
	case email
	case username
}

@MainActor
final class AuthViewModel: ObservableObject {
	@Published var hasError: Bool = false
	@Published var errorMessage: String = ""
	@Published var userDetails: UserDetails = .new
	@Published var email: String = ""
	@Published var password: String = ""
	@Published var username: String = ""
	@Published var fullname: String = ""
	@Published var image: UIImage = UIImage(named: "default_user")!

	var user: User? {
		didSet {
			objectWillChange.send()
		}
	}

	var isValidForSignIn: Bool {
		return email.isEmpty || password.isEmpty
	}

	var isValidForSignUp: Bool {
		return username.isEmpty ||
			email.isEmpty ||
			password.isEmpty ||
			fullname.isEmpty
	}

	private var handler: AuthStateDidChangeListenerHandle?
	let service: AuthenticationService

	init(service: AuthenticationService) {
		self.service = service
	}

	func listenToAuthState() {
		handler = Auth.auth().addStateDidChangeListener { [weak self] _, user in
			guard let self = self else {
				return
			}
			self.user = user
		}
	}

	func unbind() {
		if let handler = handler {
			Auth.auth().removeStateDidChangeListener(handler)
		}
	}

	func signIn() async {
		do {
			try await service.signIn(email: email,
			                         password: password)
		} catch {
			hasError = true
			errorMessage = error.localizedDescription
		}
	}

	func signUp() async {
		do {
			try await service.signUp(email: email,
			                         password: password,
			                         username: username,
			                         fullname: fullname,
			                         image: image)
		} catch {
			hasError = true
			errorMessage = error.localizedDescription
		}
	}

	func resetPassword() async {
		do {
			try await service.resetPassword(email: email)
		} catch {
			hasError = true
			errorMessage = error.localizedDescription
		}
	}

	func signOut() async {
		do {
			try await service.signOut()
		} catch let signOutError as NSError {
			self.hasError = true
			self.errorMessage = "Error while signing out: \(signOutError)"
		}
	}
}
