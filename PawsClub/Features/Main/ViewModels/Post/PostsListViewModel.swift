//
//  PostsListViewModel.swift
//  PawsClub
//
//  Created by İhsan Akbay on 25.09.2022.
//

import Firebase
import SwiftUI

protocol PostListViewModelProtocol: ObservableObject {
	var isLoading: Bool { get set }
	var hasError: Bool { get set }
	var posts: [Post] { get set }
	var breed: Breed { get set }

	func subscribe()
	func unsubscribe()
	func addPost(post: Post, image: UIImage) async
	func clear()
}

protocol PostListViewOutput {
	func addModelAndClose(post: Post, image: UIImage)
}

class PostsListViewModel: PostListViewModelProtocol {
	@Published var posts = [Post]()
	@Published var hasError: Bool = false
	@Published var isLoading: Bool = false
	@Published var post: Post = .new
	@Published var breed: Breed = .init(dog: [], cat: [], fish: [], bird: [])
	
	var errorMessage: String?

	private var listenerRegistration: ListenerRegistration?
	private let service: PostService

	init(service: PostService) {
		self.service = service
		Task {
			await subscribe()
		}
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

	@MainActor
	func subscribe() {
		if listenerRegistration == nil {
			listenerRegistration = COLLECTION_POSTS
				.order(by: "timestamp", descending: true)
				.addSnapshotListener { querySnapshot, error in
					if let error = error {
						self.hasError = true
						self.errorMessage = error.localizedDescription
					}
					guard let documents = querySnapshot?.documents else { return }
					self.posts = documents.compactMap { queryDocumentSnapshot -> Post? in
						try? queryDocumentSnapshot.data(as: Post.self)
					}
				}
		}
	}

	@MainActor
	func addPost(post: Post, image: UIImage) async {
		self.isLoading = true
		defer { self.isLoading = false }
		do {
			try await service.addPost(image: image, post: post)
		} catch {
			hasError = true
			errorMessage = error.localizedDescription
		}
	}

	@MainActor
	func clear() {
		post = Post.new
		breed = Breed(dog: [], cat: [], fish: [], bird: [])
	}
}

extension PostsListViewModel: PostListViewOutput {
	@MainActor
	func addModelAndClose(post: Post, image: UIImage) {
		Task {
			await addPost(post: post, image: image)
		}
	}
}
