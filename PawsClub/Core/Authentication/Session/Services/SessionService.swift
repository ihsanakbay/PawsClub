//
//  SessionService.swift
//  PawsClub
//
//  Created by İhsan Akbay on 26.08.2022.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

enum SessionState {
	case loggedIn
	case loggedOut
}

enum SessionKeys: String {
	case email
	case username
	case fullname
	case imageUrl
}

protocol SessionService: ObservableObject {
	var state: SessionState {get}
	var userDetails: SessionUserDetails? {get}
	func logout()
}

final class SessionManager: SessionService {
	@Published var state: SessionState = .loggedOut
	@Published var userDetails: SessionUserDetails?
	
	private var handler: AuthStateDidChangeListenerHandle?
	
	init() {
		setupFirebaseAuthHandler()
	}
	
	func logout() {
		try? Auth.auth().signOut()
	}
	
	private func setupFirebaseAuthHandler() {
		handler = Auth.auth().addStateDidChangeListener({ [weak self] result, user in
			guard let self = self else {return}
			self.state = user == nil ? .loggedOut : .loggedIn
			if let uid = user?.uid {
				self.handleRefresh(with: uid)
			}
		})
	}
	
	private func handleRefresh(with uid: String) {
		COLLECTION_USERS.document(uid).addSnapshotListener { [weak self] snapshot, _ in
			guard let self = self,
				  let data = snapshot?.data(),
				  let email = data[SessionKeys.email.rawValue] as? String,
				  let username = data[SessionKeys.username.rawValue] as? String,
				  let fullname = data[SessionKeys.fullname.rawValue] as? String,
				  let imageUrl = data[SessionKeys.imageUrl.rawValue] as? String
			else {return}
			DispatchQueue.main.async {
				self.userDetails = SessionUserDetails(id: uid, email: email, username: username, fullname: fullname, imageUrl: imageUrl)
			}
		}
	}
}
