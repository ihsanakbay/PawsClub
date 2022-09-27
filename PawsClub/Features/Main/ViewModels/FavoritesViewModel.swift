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
//		if listenerRegistration == nil {
//			listenerRegistration = COLLECTION_POSTS
//				.order(by: "timestamp", descending: true)
////				.whereField("owne", isEqualTo: <#T##Any#>)
//				.addSnapshotListener { querySnapshot, _ in
//				guard let documents = querySnapshot?.documents else {
//					print("No docs")
//					return
//				}
//				documents.compactMap { queryDocumentSnapshot in
//					try? queryDocumentSnapshot.data(as: Post.self)
//				}
//			}
//		}
	}
}
