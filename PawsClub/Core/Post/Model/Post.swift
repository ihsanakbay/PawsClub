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
//	var coordinate: Coordinate
	var latitude: Double
	var longitude: Double
	var imageUrl: String
	var ownerUid: String
	var ownerUsername: String
	var timestamp: Timestamp
	var didLike: Bool = false
}

struct Coordinate: Codable {
	let latitude: Double
	let longitude: Double

	
	//	func locationCoordinate() -> CLLocationCoordinate2D {
	//		return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
	//	}
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
//			 coordinate: Coordinate(latitude: 0.0, longitude: 0.0),
			 latitude: 0.0,
			 longitude: 0.0,
			 imageUrl: "",
			 ownerUid: "",
			 ownerUsername: "",
			 timestamp: Timestamp(date: Date()),
			 didLike: false
		)
	}
}
