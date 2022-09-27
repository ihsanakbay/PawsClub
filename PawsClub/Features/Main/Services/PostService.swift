//
//  PostService.swift
//  PawsClub
//
//  Created by İhsan Akbay on 27.09.2022.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct PostService {
	
	func getUserPosts() async throws -> [Post] {
		guard let uid = Auth.auth().currentUser?.uid else {throw FirebaseError.noUid}
		let snapshot = try await COLLECTION_POSTS.whereField("ownerUid", isEqualTo: uid).getDocuments()
		return snapshot.documents.compactMap { document in
			try? document.data(as: Post.self)
		}
	}
}
