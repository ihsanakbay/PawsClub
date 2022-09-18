//
//  FavoritesViewModel.swift
//  PawsClub
//
//  Created by İhsan Akbay on 11.09.2022.
//

import SwiftUI
import Combine
import Firebase

@MainActor
final class FavoritesViewModel: ObservableObject {
	@Published var posts: [Post] = []
	
	var service: PostService
	
	init(service: PostService) {
		self.service = service
	}

	func fetchFavorites(user: SessionUserDetails) {
		self.posts = []
		COLLECTION_USERS.document(user.id).collection("user-likes").getDocuments { querySnapshot, error in
			guard let documents = querySnapshot?.documents else {
				print("No data found.")
				return
			}

			documents.forEach { queryDocumentSnapshot in
				let postId = queryDocumentSnapshot.documentID
				COLLECTION_POSTS.document(postId).getDocument { snapshot, error in
					guard let snapshot = snapshot, snapshot.exists else {
						print("No data found.")
						return
					}
					
					let data = try? snapshot.data(as: Post.self)
					if let data = data {
						self.posts.append(data)
					}
				}
			}
			
		}
		
//		service.fetchFavorites(user: user) { result in
//			switch result {
//			case .success(let data):
//				self.posts = data
//			case .failure(let error):
//				print("No fav: \(error)")
//			}
//		}
	}
}
