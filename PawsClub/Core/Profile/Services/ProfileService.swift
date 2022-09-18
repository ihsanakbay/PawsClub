//
//  ProfileService.swift
//  PawsClub
//
//  Created by İhsan Akbay on 18.09.2022.
//

import Foundation

protocol ProfileService {
	func fetchUserPosts(forUid uid: String, completion: @escaping(Result<[Post], Error>)->())
	func fetchUserInfo(forUid uid: String, completion: @escaping(Result<SessionUserDetails, Error>)->())
}

final class ProfileManager: ProfileService {
	
	func fetchUserPosts(forUid uid: String, completion: @escaping(Result<[Post], Error>)->()) {
		COLLECTION_POSTS.whereField("ownerUid", isEqualTo: uid).getDocuments { snapshot, error in
			if let error = error {
				completion(.failure(error))
				return
			}
			guard let documents = snapshot?.documents else {
				print("No data found.")
				return
			}
			let data = documents.compactMap { queryDocumentSnapshot -> Post? in
				return try? queryDocumentSnapshot.data(as: Post.self)
			}
			completion(.success(data.sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })))
		}
	}

	func fetchUserInfo(forUid uid: String, completion: @escaping(Result<SessionUserDetails, Error>)->()) {
		COLLECTION_USERS.document(uid).getDocument { snapshot, error in
			if let error = error {
				completion(.failure(error))
				return
			}
			guard let user = try? snapshot?.data(as: SessionUserDetails.self)  else { return }
			completion(.success(user))
		}
	}
}
