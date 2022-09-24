//
//  AuthenticationService.swift
//  PawsClub
//
//  Created by İhsan Akbay on 24.09.2022.
//

import Foundation
import Firebase
import os
import AuthenticationServices
import CryptoKit
import Resolver

public class AuthenticationService: ObservableObject {
	private let logger = Logger(subsystem: "dev.peterfriese.MakeItSo", category: "authentication")
	
	@Published public var user: User?
	
	private var handle: AuthStateDidChangeListenerHandle?
	
	public init() {
		//	  setupKeychainSharing()
		registerStateListener()
	}
	
	public func signIn(with email: String, password: String, completion: @escaping(Result<Void, Error>)->()) {
		if Auth.auth().currentUser == nil {
			Auth.auth().signIn(withEmail: email, password: password) { result, error in
				if let error = error {
					completion(.failure(error))
				} else {
					completion(.success(()))
				}
			}
		}
	}
	
	public func signOut() {
		do {
			try Auth.auth().signOut()
		}
		catch {
			print("error when trying to sign out: \(error.localizedDescription)")
		}
	}
	
	func updateDisplayName(displayName: String, completionHandler: @escaping (Result<User, Error>) -> Void) {
		if let user = Auth.auth().currentUser {
			let changeRequest = user.createProfileChangeRequest()
			changeRequest.displayName = displayName
			changeRequest.commitChanges { error in
				if let error = error {
					completionHandler(.failure(error))
				}
				else {
					if let updatedUser = Auth.auth().currentUser {
						print("Successfully updated display name for user [\(user.uid)] to [\(updatedUser.displayName ?? "(empty)")]")
						// force update the local user to trigger the publisher
						self.user = updatedUser
						completionHandler(.success(updatedUser))
					}
				}
			}
		}
	}
	
	//	private var accessGroup: String {
	//	  get {
	//		let info = KeyChainAccessGroupHelper.getAccessGroupInfo()
	//		let prefix = info?.prefix ?? "unknown"
	//		return prefix + "." + (Bundle.main.bundleIdentifier ?? "unknown")
	//	  }
	//	}
	
	//	private func setupKeychainSharing() {
	//	  do {
	//		let auth = Auth.auth()
	//		auth.shareAuthStateAcrossDevices = true
	//		try auth.useUserAccessGroup(accessGroup)
	//	  }
	//	  catch let error as NSError {
	//		print("Error changing user access group: %@", error)
	//	  }
	//	}
	//
	private func registerStateListener() {
		if handle == nil {
			handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
				self.user = user
				
				if let user = user {
					self.logger.debug("User signed in with user ID \(user.uid). Email: \(user.email ?? "(empty)"), display name: [\(user.displayName ?? "(empty)")]")
				}
				else {
					self.logger.debug("User signed out.")
				}
			})
		}
	}
}

