//
//  SessionService.swift
//  PawsClub
//
//  Created by İhsan Akbay on 26.08.2022.
//

import Foundation
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

final class SessionManager: ObservableObject {
	@Published var state: SessionState = .loggedOut
	@Published var userDetails: SessionUserDetails?
	
	private var handler: AuthStateDidChangeListenerHandle?

	init() {
		listen()
	}
	
	
	func listen () {
		handler = Auth.auth().addStateDidChangeListener { (_, user) in
			if let user = user {
				self.state = .loggedIn
				self.handleRefresh(withUid: user.uid)
			} else {
				self.state = .loggedOut
			}
		}
	}
	
	func unbind () {
		if let handler = handler {
			Auth.auth().removeStateDidChangeListener(handler)
		}
	}
	
	func logout() {
		try? Auth.auth().signOut()
	}
	
	func handleRefresh(withUid uid: String) {
		COLLECTION_USERS.document(uid).getDocument { snapshot, _ in
			guard let snapshot = snapshot else { return }
			guard let data = snapshot.data(),
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
