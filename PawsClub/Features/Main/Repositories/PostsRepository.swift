//
//  PostsRepository.swift
//  PawsClub
//
//  Created by İhsan Akbay on 25.09.2022.
//

import Firebase
import SwiftUI

enum PostKeys: String {
	case id, name, about, kind, breed, age, gender, healthChecks, isVaccinated, isNeutered, latitude, longitude, imageUrl, ownerUid, ownerUsername, timestamp, didLike
}

class PostsRepository: ObservableObject {
	@Published var posts = [Post]()
	
	func getPosts() {
		COLLECTION_POSTS
			.order(by: "timestamp", descending: true)
			.addSnapshotListener { querySnapshot, _ in
				if let querySnapshot = querySnapshot {
					self.posts = querySnapshot.documents.compactMap { document in
						try? document.data(as: Post.self)
					}
				}
			}
			
	}
	
	func getUsersPosts() {
		guard let userId = Auth.auth().currentUser?.uid else { return }
		COLLECTION_POSTS
			.order(by: "timestamp", descending: true)
			.whereField("ownerUid", isEqualTo: userId)
			.addSnapshotListener { querySnapshot, _ in
				if let querySnapshot = querySnapshot {
					self.posts = querySnapshot.documents.compactMap { document in
						try? document.data(as: Post.self)
					}
				}
			}
			
	}
	
	func addPost(_ post: Post, image: UIImage, completion: @escaping (Result<Void, Error>) -> Void) {
		guard let uid = Auth.auth().currentUser?.uid else {
			print("Invalid user id.")
			return
		}
		guard let username = Auth.auth().currentUser?.displayName else { return }
		guard let imageData = image.jpegData(compressionQuality: 0.6) else { return }
		let ref = UploadType.Post.filePath
		ref.putData(imageData) { _, error in
			if let error = error {
				completion(.failure(error))
			}
			ref.downloadURL { url, _ in
				guard let url = url?.absoluteString else { return }
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
				            PostKeys.ownerUsername.rawValue: username,
				            PostKeys.timestamp.rawValue: Timestamp(date: Date())] as [String: Any]
				
				COLLECTION_POSTS.addDocument(data: data) { error in
					if let error = error {
						completion(.failure(error))
					}
					completion(.success(()))
				}
			}
		}
	}
	
	func updatePost(_ post: Post, image: UIImage, completion: @escaping (Result<Void, Error>) -> Void) {
		let data = [PostKeys.name.rawValue: post.name,
		            PostKeys.about.rawValue: post.about,
		            PostKeys.kind.rawValue: post.kind,
		            PostKeys.breed.rawValue: post.breed,
		            PostKeys.age.rawValue: post.age,
		            PostKeys.gender.rawValue: post.gender,
		            PostKeys.healthChecks.rawValue: post.healthChecks,
		            PostKeys.isVaccinated.rawValue: post.isVaccinated,
		            PostKeys.isNeutered.rawValue: post.isNeutered,
		            PostKeys.imageUrl.rawValue: post.imageUrl,
		            PostKeys.latitude.rawValue: post.latitude,
		            PostKeys.longitude.rawValue: post.longitude,
		            PostKeys.ownerUid.rawValue: post.ownerUid,
		            PostKeys.ownerUsername.rawValue: post.ownerUsername] as [String: Any]
				
		COLLECTION_POSTS.document(post.id!).setData(data) { error in
			if let error = error {
				completion(.failure(error))
			}
		}
	}
	
	func deletePost(_ post: Post, completion: @escaping (Result<Void, Error>) -> Void) {
		COLLECTION_POSTS.document(post.id!).delete { error in
			if let error = error {
				completion(.failure(error))
			}
		}
	}
	
}
