//
//  General.swift
//  PawsClub
//
//  Created by İhsan Akbay on 11.09.2022.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage

let screenSize = UIScreen.main.bounds

// MARK: Firebase
let COLLECTION_USERS = Firestore.firestore().collection("users")
let COLLECTION_POSTS = Firestore.firestore().collection("posts")

enum UploadType {
	case Profile, Post

	var filePath: StorageReference {
		let filename = NSUUID().uuidString
		switch self {
		case .Profile:
			return Storage.storage().reference(withPath: "/profile_images/\(filename)")
		case .Post:
			return Storage.storage().reference(withPath: "/post_images/\(filename)")
		}
	}
}



