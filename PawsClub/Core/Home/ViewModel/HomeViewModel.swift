//
//  HomeViewModel.swift
//  PawsClub
//
//  Created by İhsan Akbay on 11.09.2022.
//

import SwiftUI
import MapKit

final class HomeViewModel: ObservableObject {
	@Published var state: ServiceState = .na
	@Published var posts: [Post] = []
	@Published var image: UIImage = UIImage()
	@Published var hasError: Bool = false
	@Published var isLoading: Bool = false
	
	var service: PostService
	
	init(service: PostService) {
		self.service = service
		self.subscribe()
	}
	
	func subscribe() {
		isLoading = true
		service.fetchPosts { result in
			switch result {
			case .success(let posts):
				self.posts = posts
				self.state = .successful
			case .failure(let err):
				self.state = .failed(error: err)
				self.hasError = true
			}
		}
		isLoading = false
	}
	
}
