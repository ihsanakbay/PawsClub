//
//  PostDetailViewModel.swift
//  PawsClub
//
//  Created by İhsan Akbay on 11.09.2022.
//

import SwiftUI
import Combine
import MapKit

protocol PostDetailViewModelProtocol: ObservableObject {
	var post: Post { get }
	var state: ServiceState { get }
	var hasError: Bool { get }
	var isLoading: Bool { get }
	var ownerUid: String {get}
	init(post: Post, ownerUid: String)
}

final class PostDetailViewModel: PostDetailViewModelProtocol {
	@Published var post: Post
	@Published var ownerUid: String
	@Published var state: ServiceState = .na
	@Published var hasError: Bool = false
	@Published var isLoading: Bool = false
	
	init(post: Post, ownerUid: String) {
		self.post = post
		self.ownerUid = ownerUid
		checkIfUserLikedPost()
	}
	
	var timestampString: String {
		let formatter = DateFormatter()
		formatter.dateStyle = .long
		formatter.timeStyle = .none
		return formatter.string(from: post.timestamp.dateValue())
	}

	func like() {
		let uid = self.ownerUid
		guard let postId = post.id else {return}
		COLLECTION_POSTS.document(postId).collection("post-likes").document(uid).setData([:]) { _ in
			COLLECTION_USERS.document(uid).collection("user-likes").document(postId).setData([:]) { _ in
				self.post.didLike = true
			}
		}
	}

	func unlike() {
		let uid = self.ownerUid
		guard let postId = post.id else {return}
		
		COLLECTION_POSTS.document(postId).collection("post-likes").document(uid).delete { _ in
			COLLECTION_USERS.document(uid).collection("user-likes").document(postId).delete { _ in
				self.post.didLike = false
			}
		}
	}

	func checkIfUserLikedPost() {
		let uid = self.ownerUid
		guard let postId = post.id else {return}
		COLLECTION_USERS.document(uid).collection("user-likes").document(postId).getDocument { snapshot, _ in
			guard let didLike = snapshot?.exists else {return}
			self.post.didLike = didLike
		}
	}

	func deletePost() {
		guard let postId = post.id else {return}
		COLLECTION_POSTS.document(postId).delete { error in
			if let error = error {
				self.hasError = true
				self.state = .failed(error: error)
			} else {
				self.state = .successful
			}
		}
	}
	
	
}
