//
//  AuthViewModel.swift
//  PawsClub
//
//  Created by İhsan Akbay on 25.09.2022.
//

import FirebaseAuth
import SwiftUI

enum RegistrationKeys: String {
	case email
	case username
}

final class AuthViewModel: ObservableObject {
	@Published var hasError: Bool = false
	@Published var errorMessage: String = ""
	var user: User? {
		didSet {
			objectWillChange.send()
		}
	}

	private var handler: AuthStateDidChangeListenerHandle?

	func listenToAuthState() {
		self.handler = Auth.auth().addStateDidChangeListener { [weak self] _, user in
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

	func signIn(with email: String, password: String) async {
		do {
			try await Auth.auth().signIn(withEmail: email, password: password)
		} catch {
			self.hasError = true
			self.errorMessage = error.localizedDescription
		}
	}

	func signUp(with email: String, password: String, username: String) async {
		do {
			let result = try await Auth.auth().createUser(withEmail: email, password: password)
			let changeRequest = result.user.createProfileChangeRequest()
			changeRequest.displayName = username
			try await changeRequest.commitChanges()
		} catch {
			self.hasError = true
			self.errorMessage = "Something went wrong: \(error.localizedDescription)"
		}
	}

	func resetPassword(with email: String) async {
		do {
			try await Auth.auth().sendPasswordReset(withEmail: email)
		} catch {
			self.hasError = true
			self.errorMessage = error.localizedDescription
		}
	}

	func signOut() async {
		do {
			try Auth.auth().signOut()
		} catch let signOutError as NSError {
			self.hasError = true
			self.errorMessage = "Error while signing out: \(signOutError)"
		}
	}
}
