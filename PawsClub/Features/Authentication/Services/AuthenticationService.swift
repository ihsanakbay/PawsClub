//
//  AuthenticationService.swift
//  PawsClub
//
//  Created by İhsan Akbay on 2.10.2022.
//

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

struct AuthenticationService {
	func signUp(email: String, password: String, username: String, fullname: String, image: UIImage) async throws {
		guard let imageData = image.jpegData(compressionQuality: 0.6) else { return }
		let ref = UploadType.Profile.filePath
		_ = try await ref.putDataAsync(imageData)
		let urlRef = try await ref.downloadURL()
		let url = urlRef.absoluteString
		
		let result = try await Auth.auth().createUser(withEmail: email, password: password)
		
		let changeRequest = result.user.createProfileChangeRequest()
		changeRequest.displayName = username
		try await changeRequest.commitChanges()
		let uid = result.user.uid
		let data = [UserKeys.id.rawValue: uid,
		            UserKeys.email.rawValue: email,
		            UserKeys.username.rawValue: username,
		            UserKeys.fullname.rawValue: fullname,
		            UserKeys.userImageUrl.rawValue: url] as [String: Any]

		try await COLLECTION_USERS.document(uid).setData(data)
	}
	
	func signIn(email: String, password: String) async throws {
		try await Auth.auth().signIn(withEmail: email, password: password)
	}
	
	func signOut() async throws {
		try Auth.auth().signOut()
	}
	
	func resetPassword(email: String) async throws {
		try await Auth.auth().sendPasswordReset(withEmail: email)
	}
	
	func getUserDetails(uid: String) async throws -> UserDetails? {
		let snapshot = try await COLLECTION_USERS.document(uid).getDocument()
		guard let data = snapshot.data() else { return nil }
		
		let id = data["id"] as? String ?? ""
		let username = data["username"] as? String ?? ""
		let email = data["email"] as? String ?? ""
		let fullname = data["fullname"] as? String ?? ""
		let userImageUrl = data["userImageUrl"] as? String ?? ""
		
		return UserDetails(id: id, email: email, username: username, fullname: fullname, userImageUrl: userImageUrl)
	}
	
}
