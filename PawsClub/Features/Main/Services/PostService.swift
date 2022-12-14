//
//  PostService.swift
//  PawsClub
//
//  Created by İhsan Akbay on 27.09.2022.
//

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

struct PostService {
	func getUserPosts(uid: String) async throws -> [Post] {
		let snapshot = try await COLLECTION_POSTS.whereField("ownerUid", isEqualTo: uid).getDocuments()
		return snapshot.documents.compactMap { document in
			try? document.data(as: Post.self)
		}
	}

	func addPost(image: UIImage, post: Post) async throws {
		guard let user = Auth.auth().currentUser else { return }
		guard let imageData = image.jpegData(compressionQuality: 0.6) else { return }
		let uid = user.uid
		let username = user.displayName
		let ref = UploadType.Post.filePath
		_ = try await ref.putDataAsync(imageData)
		let urlRef = try await ref.downloadURL()
		let url = urlRef.absoluteString

		let data = [PostKeys.name.rawValue: post.name,
		            PostKeys.about.rawValue: post.about,
		            PostKeys.kind.rawValue: post.kind,
		            PostKeys.breed.rawValue: post.breed,
		            PostKeys.age.rawValue: post.age,
		            PostKeys.gender.rawValue: post.gender,
		            PostKeys.healthChecks.rawValue: post.healthChecks,
		            PostKeys.isVaccinated.rawValue: post.isVaccinated,
		            PostKeys.isNeutered.rawValue: post.isNeutered,
		            PostKeys.imageUrl.rawValue: url,
		            PostKeys.latitude.rawValue: post.latitude,
		            PostKeys.longitude.rawValue: post.longitude,
		            PostKeys.ownerUid.rawValue: uid,
		            PostKeys.ownerUsername.rawValue: username ?? UUID().uuidString,
		            PostKeys.timestamp.rawValue: Timestamp(date: Date())] as [String: Any]

		_ = try await COLLECTION_POSTS.addDocument(data: data)
	}

	func updatePost(postId: String, data: [String: Any]) async throws {
		try await COLLECTION_POSTS.document(postId).setData(data)
	}

	func deletePost(postId: String) async throws {
		try await COLLECTION_POSTS.document(postId).delete()
	}

	func likePost(uid: String, postId: String) async throws {
		try await COLLECTION_POSTS.document(postId).collection("post-likes").document(uid).setData([:])
		try await COLLECTION_USERS.document(uid).collection("user-likes").document(postId).setData([:])
	}

	func unlikePost(uid: String, postId: String) async throws {
		try await COLLECTION_POSTS.document(postId).collection("post-likes").document(uid).delete()
		try await COLLECTION_USERS.document(uid).collection("user-likes").document(postId).delete()
	}

	func checkIfUserLikedPost(uid: String, postId: String) async throws -> Bool {
		let result = try await COLLECTION_POSTS.document(postId).collection("post-likes").document(uid).getDocument()
		return result.exists
	}
}
