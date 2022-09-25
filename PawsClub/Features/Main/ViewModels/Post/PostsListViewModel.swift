//
//  PostsListViewModel.swift
//  PawsClub
//
//  Created by İhsan Akbay on 25.09.2022.
//

import Firebase
import Foundation

class PostsListViewModel: ObservableObject {
	@Published var posts = [Post]()
	@Published var hasError: Bool = false
	@Published var errorMessage: String = ""
	private var listenerRegistration: ListenerRegistration?
	
	deinit {
		unsubscribe()
	}

	func unsubscribe() {
		if listenerRegistration != nil {
			listenerRegistration?.remove()
			listenerRegistration = nil
		}
	}

	func subscribe() {
		if listenerRegistration == nil {
			listenerRegistration = COLLECTION_POSTS
				.order(by: "timestamp", descending: true)
				.addSnapshotListener { (querySnapshot, error) in
				guard let documents = querySnapshot?.documents else {
					print("No docs")
					return
				}
				self.posts = documents.compactMap { queryDocumentSnapshot -> Post? in
					try? queryDocumentSnapshot.data(as: Post.self)
				}
			}
		}
	}
}
