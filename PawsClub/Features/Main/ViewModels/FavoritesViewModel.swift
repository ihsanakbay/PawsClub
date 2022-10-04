//
//  FavoritesViewModel.swift
//  PawsClub
//
//  Created by İhsan Akbay on 25.09.2022.
//

import Firebase
import SwiftUI

@MainActor
final class FavoritesViewModel: ObservableObject {
	@Published var posts = [Post]()
	@Published var hasError: Bool = false
	@Published var isLoading: Bool = false
	var errorMessage: String?

	init() {
		self.fetchLikedPosts()
	}

	func fetchLikedPosts() {
		self.isLoading = true
		defer { self.isLoading = false }

		guard let uid = Auth.auth().currentUser?.uid else { return }
		COLLECTION_USERS.document(uid).collection("user-likes").getDocuments { snapshot, err in
			if let err = err {
				self.hasError = true
				self.errorMessage = err.localizedDescription
				return
			}
			guard let documents = snapshot?.documents else { return }
			for document in documents {
				COLLECTION_POSTS.document(document.documentID).getDocument { postSnapshot, err in
					if let err = err {
						self.hasError = true
						self.errorMessage = err.localizedDescription
						return
					}
					guard let post = postSnapshot else { return }
					let newValue = try? post.data(as: Post.self)
					if let newValue = newValue {
						self.posts.append(newValue)
					}
				}
			}
		}
	}
}
