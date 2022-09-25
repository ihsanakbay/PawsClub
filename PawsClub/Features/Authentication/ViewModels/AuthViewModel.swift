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
		handler = Auth.auth().addStateDidChangeListener { [weak self] _, user in
			guard let self = self else {
				return
			}
			self.user = user
		}
	}
	
	func unbind () {
		if let handler = handler {
			Auth.auth().removeStateDidChangeListener(handler)
		}
	}

	func signIn(with email: String,
	            password: String)
	{
		Auth.auth()
			.signIn(withEmail: email, password: password) { _, error in
				if let error = error {
					self.hasError = true
					self.errorMessage = error.localizedDescription
				} else {
					self.hasError = false
				}
			}
	}

	func signUp(with email: String,
	            password: String,
	            username: String)
	{
		Auth.auth().createUser(withEmail: email, password: password) { result, error in
			if let error = error {
				self.hasError = true
				self.errorMessage = error.localizedDescription
			} else {
				let changeRequest = result?.user.createProfileChangeRequest()
				changeRequest?.displayName = username
				changeRequest?.commitChanges(completion: { error in
					if let error = error {
						self.hasError = true
						self.errorMessage = "Something went wrong: \(error.localizedDescription)"
					}
				})
			}
		}
	}
	
	func resetPassword(with email: String) {
		Auth.auth().sendPasswordReset(withEmail: email) { error in
			if let error = error {
				self.hasError = true
				self.errorMessage = error.localizedDescription
			} else {
				self.hasError = false
			}
		}
	}

	func signOut() {
		do {
			try Auth.auth().signOut()
		} catch let signOutError as NSError {
			self.hasError = true
			self.errorMessage = "Error while signing out: \(signOutError)"
		}
	}
}
