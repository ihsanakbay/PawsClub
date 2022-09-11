//
//  PostService.swift
//  PawsClub
//
//  Created by İhsan Akbay on 31.08.2022.
//

import SwiftUI
import Combine
import FirebaseFirestoreSwift
import FirebaseFirestore

enum PostKeys: String {
	case id, name, about, kind, breed, age, gender, healthChecks, isVaccinated, isNeutered, latitude, longitude, imageUrl, ownerUid, ownerUsername, timestamp, didLike
}

protocol PostService {
	func fetchPosts() ->  AnyPublisher<[Post], Error>
	func uploadPost(with post: Post, user: SessionUserDetails, image: UIImage) -> AnyPublisher<Void, Error>
}

final class PostManager: PostService {
	
	func fetchPosts() -> AnyPublisher<[Post], Error> {
		Deferred {
			Future<[Post], Error> { promise in
				COLLECTION_POSTS.order(by: "timestamp", descending: true).addSnapshotListener { documentSnapshot, error in
					if let error = error {
						promise(.failure(error))
						return
					}
					guard let documents = documentSnapshot?.documents else {
						promise(.failure(FirebaseError.badSnapshot))
						return
					}
					
					let posts = documents.map { queryDocumentSnapshot -> Post in
						let uid = queryDocumentSnapshot.documentID
						let data = queryDocumentSnapshot.data()
						let id = uid
						let name = data[PostKeys.name.rawValue] as? String ?? "N/A"
						let about = data[PostKeys.about.rawValue] as? String ?? "N/A"
						let kind = data[PostKeys.kind.rawValue] as? String ?? "N/A"
						let breed = data[PostKeys.breed.rawValue] as? String ?? "N/A"
						let age = data[PostKeys.age.rawValue] as? String ?? "N/A"
						let gender = data[PostKeys.gender.rawValue] as? String ?? "N/A"
						let healthChecks = data[PostKeys.healthChecks.rawValue] as? Bool ?? false
						let isVaccinated = data[PostKeys.isVaccinated.rawValue] as? Bool ?? false
						let isNeutered = data[PostKeys.isNeutered.rawValue] as? Bool ?? false
						let imageUrl = data[PostKeys.imageUrl.rawValue] as? String ?? "N/A"
						let latitude = data[PostKeys.latitude.rawValue] as? Double ?? 0.0
						let longitude = data[PostKeys.longitude.rawValue] as? Double ?? 0.0
						let ownerUid = data[PostKeys.ownerUid.rawValue] as? String ?? "N/A"
						let ownerUsername = data[PostKeys.ownerUsername.rawValue] as? String ?? "N/A"
						let timestamp = data[PostKeys.timestamp.rawValue] as? Timestamp ?? Timestamp.init()
						
						return Post(id: id, name: name, about: about, kind: kind, breed: breed, age: age, gender: gender, healthChecks: healthChecks, isVaccinated: isVaccinated, isNeutered: isNeutered, latitude: latitude, longitude: longitude, imageUrl: imageUrl, ownerUid: ownerUid, ownerUsername: ownerUsername, timestamp: timestamp)
					}
					promise(.success(posts))
				}
			}
		}
		.receive(on: RunLoop.main)
		.eraseToAnyPublisher()
	}
	
	func uploadPost(with post: Post, user: SessionUserDetails, image: UIImage) -> AnyPublisher<Void, Error> {
		Deferred {
			Future<Void, Error> { promise in
				guard let imageData = image.jpegData(compressionQuality: 0.6) else {return}
				let ref = UploadType.Post.filePath
				ref.putData(imageData) { _, error in
					if let error = error {
						promise(.failure(error))
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
								promise(.failure(error))
							}
							promise(.success(()))
						}
					}
				}
			}
		}
		.receive(on: RunLoop.main)
		.eraseToAnyPublisher()
	}
}
