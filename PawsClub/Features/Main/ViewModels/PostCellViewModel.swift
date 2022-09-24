//
//  PostsListCellViewModel.swift
//  PawsClub
//
//  Created by İhsan Akbay on 25.09.2022.
//

import Combine
import Foundation

class PostCellViewModel: ObservableObject, Identifiable {
	@Published var post: Post
	@Published var likeStateIconName = ""
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
}
