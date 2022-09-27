//
//  PostDetailViewModel.swift
//  PawsClub
//
//  Created by İhsan Akbay on 25.09.2022.
//

import Combine
import Foundation

class PostDetailViewModel: ObservableObject {
	@Published var post: Post
	@Published var likeStateIconName = ""
	@Published var isLoading: Bool = false
	@Published var hasError: Bool = false
	@Published var errorMessage: String = ""
	var id = ""
	private var cancellables = Set<AnyCancellable>()

	init(post: Post) {
		self.post = post

		$post
			.map { post in
				post.didLike ?? false ? "heart.fill" : "heart"
			}
			.assign(to: \.likeStateIconName, on: self)
			.store(in: &cancellables)

		$post
			.compactMap { post in
				post.id
			}
			.assign(to: \.id, on: self)
			.store(in: &cancellables)
	}

	func updatePost() {
		let data = [PostKeys.name.rawValue: post.name,
		            PostKeys.about.rawValue: post.about,
		            PostKeys.kind.rawValue: post.kind,
		            PostKeys.breed.rawValue: post.breed,
		            PostKeys.age.rawValue: post.age,
		            PostKeys.gender.rawValue: post.gender,
		            PostKeys.healthChecks.rawValue: post.healthChecks,
		            PostKeys.isVaccinated.rawValue: post.isVaccinated,
		            PostKeys.isNeutered.rawValue: post.isNeutered,
		            PostKeys.imageUrl.rawValue: post.imageUrl,
		            PostKeys.latitude.rawValue: post.latitude,
		            PostKeys.longitude.rawValue: post.longitude,
		            PostKeys.ownerUid.rawValue: post.ownerUid,
		            PostKeys.ownerUsername.rawValue: post.ownerUsername] as [String: Any]

		COLLECTION_POSTS.document(post.id!).setData(data) { error in
			if let error = error {
				self.hasError = true
				self.errorMessage = error.localizedDescription
			} else {
				self.hasError = false
			}
		}
	}

	func deletePost() {
		if let postId = post.id {
			COLLECTION_POSTS.document(postId).delete { error in
				if let error = error {
					self.hasError = true
					self.errorMessage = error.localizedDescription
				} else {
					self.hasError = false
				}
			}
		}
	}
}
