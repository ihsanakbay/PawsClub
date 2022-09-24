//
//  Post.swift
//  PawsClub
//
//  Created by İhsan Akbay on 31.08.2022.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import CoreLocation

struct Post: Identifiable, Codable {
	@DocumentID var id: String?
	var name: String
	var about: String
	var kind: String
	var breed: String
	var age: String
	var gender: String
	var healthChecks: Bool
	var isVaccinated: Bool
	var isNeutered: Bool
	var latitude: Double
	var longitude: Double
	var imageUrl: String
	var ownerUid: String
	var ownerUsername: String
	@ServerTimestamp var timestamp: Timestamp?
	var didLike: Bool?
	var order: Int = 0
}


extension Post {
	static var new: Post {
		Post(name: "",
			 about: "",
			 kind: "",
			 breed: "",
			 age: "",
			 gender: "",
			 healthChecks: false,
			 isVaccinated: false,
			 isNeutered: false,
			 latitude: 0.0,
			 longitude: 0.0,
			 imageUrl: "",
			 ownerUid: "",
			 ownerUsername: "",
			 didLike: false,
			 order: 0
		)
	}
}
