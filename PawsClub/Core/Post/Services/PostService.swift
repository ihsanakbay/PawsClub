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
	case name, about, kind, breed, age, gender, healthChecks, isVaccinated, isNeutered, coordinate, imageUrl, ownerUid, ownerUsername, timestamp, didLike
}

protocol PostService {
	func fetchPosts() ->  AnyPublisher<[Post], Error>
	func uploadPost(with post: Post, image: UIImage, user: SessionUserDetails) -> AnyPublisher<Void, Error>
}

final class PostManager: PostService {
	func fetchPosts() -> AnyPublisher<[Post], Error> {
		Deferred {
			Future { promise in
				COLLECTION_POSTS.order(by: "timestamp", descending: true).addSnapshotListener { snapshot, error in
					guard let documents = snapshot?.documents else {return}
					let result = documents.compactMap { document in
						try? document.data(as: Post.self)
					}
					promise(.success(result))
				}
			}
		}
		.receive(on: RunLoop.main)
		.eraseToAnyPublisher()
	}
	
	func uploadPost(with post: Post, image: UIImage, user: SessionUserDetails) -> AnyPublisher<Void, Error> {
		Deferred {
			Future { promise in
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
									PostKeys.coordinate.rawValue: post.coordinate,
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
