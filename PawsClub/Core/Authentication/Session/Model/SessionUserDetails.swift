//
//  SessionUserDetails.swift
//  PawsClub
//
//  Created by İhsan Akbay on 26.08.2022.
//

import Foundation

struct SessionUserDetails: Codable {
	let email: String
	let username: String
	let fullname: String
	let imageUrl: String
}
