//
//  PostService.swift
//  PawsClub
//
//  Created by İhsan Akbay on 31.08.2022.
//

import SwiftUI
import FirebaseFirestoreSwift
import FirebaseFirestore

enum PostKeys: String {
	case id, name, about, kind, breed, age, gender, healthChecks, isVaccinated, isNeutered, latitude, longitude, imageUrl, ownerUid, ownerUsername, timestamp, didLike
}

protocol PostService {
	func fetchPosts(completion: @escaping(Result<[Post], Error>)->())
	func uploadPost(with post: Post, user: SessionUserDetails, image: UIImage, completion: @escaping(Result<Void, Error>)->())
}

final class PostManager: PostService {
	
	func fetchPosts(completion: @escaping (Result<[Post], Error>) -> ()) {
		COLLECTION_POSTS.order(by: "timestamp", descending: true).addSnapshotListener { querySnapshot, error in
			if let error = error {
				completion(.failure(error))
				return
			}
			guard let documents = querySnapshot?.documents else {
				print("No data found.")
				return
			}
			let data = documents.compactMap { queryDocumentSnapshot -> Post? in
				return try? queryDocumentSnapshot.data(as: Post.self)
			}
			completion(.success(data))
		}
	}

	
	func uploadPost(with post: Post, user: SessionUserDetails, image: UIImage, completion: @escaping (Result<Void, Error>) -> ()) {
		guard let imageData = image.jpegData(compressionQuality: 0.6) else {return}
		let ref = UploadType.Post.filePath
		ref.putData(imageData) { _, error in
			if let error = error {
				completion(.failure(error))
			}
			ref.downloadURL { url, _ in
				guard let url = url?.absoluteString else {return}
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
							PostKeys.ownerUid.rawValue: user.id,
							PostKeys.ownerUsername.rawValue: user.username,
							PostKeys.timestamp.rawValue: Timestamp(date: Date())
				] as [String : Any]
				
				COLLECTION_POSTS.addDocument(data: data) { error in
					if let error = error {
						completion(.failure(error))
					}
					completion(.success(()))
				}
			}
		}
	}
	
}
