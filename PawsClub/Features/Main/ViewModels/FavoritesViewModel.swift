//
//  FavoritesViewModel.swift
//  PawsClub
//
//  Created by İhsan Akbay on 25.09.2022.
//

import SwiftUI
import Firebase

final class FavoritesViewModel: ObservableObject {
	@Published var posts = [Post]()
	@Published var hasError: Bool = false
	@Published var isLoading: Bool = true
	var errorMessage: String?

	private var listenerRegistration: ListenerRegistration?
	private let service: PostService

	init(service: PostService) {
		self.service = service
		subscribe()
	}

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
//		if listenerRegistration == nil {
//			listenerRegistration = COLLECTION_POSTS
//				.order(by: "timestamp", descending: true)
//				.addSnapshotListener { querySnapshot, error in
//					if let error = error {
//						self.changeError()
//					}
//					guard let documents = querySnapshot?.documents else { return }
//					self.posts = documents.compactMap { queryDocumentSnapshot -> Post? in
//						try? queryDocumentSnapshot.data(as: Post.self)
//					}
//				}
//		}
	}
	
	func changeLoading() {
		DispatchQueue.main.async {
			self.isLoading.toggle()
		}
	}

	func changeError() {
		DispatchQueue.main.async {
			self.hasError.toggle()
		}
	}

}
