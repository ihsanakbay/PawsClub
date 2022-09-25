//
//  PostDetailViewModel.swift
//  PawsClub
//
//  Created by İhsan Akbay on 25.09.2022.
//

import Foundation
import Combine

class PostDetailViewModel: ObservableObject {
	@Published var postsRepository = PostsRepository()
	@Published var post: Post
	@Published var likeStateIconName = ""
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
	
	func deletePost() {
		postsRepository.deletePost(post) { result in
			switch result {
			case .success():
				self.hasError = false
			case .failure(let err):
				self.hasError = true
				self.errorMessage = err.localizedDescription
			}
		}
	}
}
