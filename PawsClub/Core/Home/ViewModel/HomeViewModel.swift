//
//  HomeViewModel.swift
//  PawsClub
//
//  Created by İhsan Akbay on 11.09.2022.
//

import SwiftUI
import Combine
import MapKit

protocol HomeViewModelProtocol: ObservableObject {
	var service: PostService { get }
	var state: ServiceState { get }
	var posts: [Post] { get }
	var image: UIImage { get }
	var hasError: Bool { get }
	var isLoading: Bool { get }
	init(service: PostService)
	
	func fetchPosts() async
}

final class HomeViewModel: HomeViewModelProtocol {
	@Published var state: ServiceState = .na
	@Published var posts: [Post] = []
	@Published var image: UIImage = UIImage()
	@Published var hasError: Bool = false
	@Published var isLoading: Bool = false
	
	var service: PostService
	
	private var subscriptions = Set<AnyCancellable>()
	
	init(service: PostService) {
		self.service = service
		setupErrorSubscription()
		Task {
			await fetchPosts()
		}
	}
	
	@MainActor
	func fetchPosts() async {
		isLoading = true
		service.fetchPosts()
			.sink { [weak self] result in
				switch result {
				case .failure(let error):
					self?.state = .failed(error: error)
				default:
					break
				}
			} receiveValue: { posts in
				self.posts = posts
				self.state = .successful
			}
			.store(in: &subscriptions)
		isLoading = false
	}
	
}

private extension HomeViewModel {
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
