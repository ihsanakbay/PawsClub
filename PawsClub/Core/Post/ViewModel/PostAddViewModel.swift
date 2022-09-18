//
//  PostAddViewModel.swift
//  PawsClub
//
//  Created by İhsan Akbay on 2.09.2022.
//

import SwiftUI
import MapKit

protocol PostAddViewModelProtocol: ObservableObject {
	var service: PostService { get }
	var state: ServiceState { get }
	var post: Post { get }
	var image: UIImage { get }
	var hasError: Bool { get }
	var isLoading: Bool { get }
	var breedService: BreedService { get }
	init(service: PostService, breedService: BreedService)
	func add(user: SessionUserDetails)
	func clear()
	func fetchBreeds() async
}

final class PostAddViewModel: PostAddViewModelProtocol {
	@Published var state: ServiceState = .na
	@Published var post: Post = .new
	@Published var breed: Breed = .init(dog: [], cat: [], fish: [], bird: [])
	@Published var image: UIImage = UIImage()
	@Published var hasError: Bool = false
	@Published var isLoading: Bool = false
	
	var service: PostService
	var breedService: BreedService
	
	init(service: PostService, breedService: BreedService) {
		self.service = service
		self.breedService = breedService
	}
	
	@MainActor
	func add(user: SessionUserDetails) {
		isLoading = true
		
		service.uploadPost(with: post, user: user, image: image) { result in
			switch result {
			case .success():
				self.state = .successful
			case .failure(let err):
				self.state = .failed(error: err)
				self.hasError = true
			}
		}
		
		isLoading = false
	}
	
	@MainActor
	func clear() {
		post = Post.new
		breed = Breed.init(dog: [], cat: [], fish: [], bird: [])
	}
	
	@MainActor
	func fetchBreeds() async {
		do {
			let result = try await breedService.download(BREED_URL)
			switch result {
			case .success(let data):
				self.breed = data
				state = .successful
				hasError = false
			case .failure(let error):
				state = .failed(error: error)
				hasError = true
				return
			}
		} catch {
			state = .failed(error: error)
			hasError = true
			return
		}
	}
	
}
