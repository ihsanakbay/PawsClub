//
//  UserDetails.swift
//  PawsClub
//
//  Created by İhsan Akbay on 2.10.2022.
//

import Firebase
import FirebaseFirestoreSwift

struct UserDetails: Identifiable, Codable {
	@DocumentID var id: String?
	var email: String
	var username: String
	var fullname: String
	var userImageUrl: String
}

enum UserKeys: String {
	case id, email, username, fullname, userImageUrl
}

extension UserDetails {
	static var new: UserDetails {
		UserDetails(email: "", username: "", fullname: "", userImageUrl: "")
	}
}
