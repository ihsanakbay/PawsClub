//
//  PostsListViewModel.swift
//  PawsClub
//
//  Created by İhsan Akbay on 25.09.2022.
//

import Combine
import Foundation

class PostsListViewModel: ObservableObject {
	@Published var postsRepository = PostsRepository()
	@Published var postsListCellViewModel = [PostCellViewModel]()
	private var cancellables = Set<AnyCancellable>()

	init() {
		postsRepository.$posts
			.map { posts in
				posts.map { post in
					PostCellViewModel(post: post)
				}
			}
			.assign(to: \.postsListCellViewModel, on: self)
			.store(in: &cancellables)
	}
}
