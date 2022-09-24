//
//  RegisterCredentials.swift
//  PawsClub
//
//  Created by İhsan Akbay on 25.08.2022.
//

import Foundation

struct RegisterCredentials {
	var email: String
	var password: String
	var username: String
	var fullname: String
	var imageUrl: String
}

extension RegisterCredentials {
	static var new: RegisterCredentials {
		RegisterCredentials(email: "", password: "", username: "", fullname: "", imageUrl: "")
	}
}
