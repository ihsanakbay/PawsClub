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
	var service: PostService { get }
	var state: ServiceState { get }
	var post: Post { get }
	var hasError: Bool { get }
	var isLoading: Bool { get }
	init(post: Post, service: PostService)
}

final class PostDetailViewModel: PostDetailViewModelProtocol {
	@Published var state: ServiceState = .na
	@Published var post: Post = Post.new
	@Published var hasError: Bool = false
	@Published var isLoading: Bool = false
	
	var service: PostService
	
	private var subscriptions = Set<AnyCancellable>()
	
	init(post: Post, service: PostService) {
		self.post = post
		self.service = service
	}
	
	
	
	
}

private extension PostDetailViewModel {
	func setupErrorSubscription() {
		$state
			.map { state -> Bool in
				switch state {
				case .successful, .na:
					return false
				case .failed:
					return true
				}
			}
			.assign(to: &$hasError)
	}
}
