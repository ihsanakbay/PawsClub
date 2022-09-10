//
//  PostAddViewModel.swift
//  PawsClub
//
//  Created by İhsan Akbay on 2.09.2022.
//

import SwiftUI
import Combine
import MapKit

enum PostState {
	case successful
	case failed(error: Error)
	case na
}

protocol PostAddViewModelProtocol: ObservableObject {
	var service: PostService { get }
	var state: PostState { get }
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
	@Published var state: PostState = .na
	@Published var post: Post = .new
	@Published var breed: Breed = .init(dog: [], cat: [], fish: [], bird: [])
	@Published var image: UIImage = UIImage()
	@Published var hasError: Bool = false
	@Published var isLoading: Bool = false
	
	var service: PostService
	var breedService: BreedService
	
	private var subscriptions = Set<AnyCancellable>()
	
	init(service: PostService, breedService: BreedService) {
		self.service = service
		self.breedService = breedService
		setupErrorSubscription()
	}
	
	@MainActor
	func add(user: SessionUserDetails) {
		isLoading = true
		service.uploadPost(with: post, user: user, image: image)
			.sink { [weak self] result in
				switch result {
				case .failure(let error):
					self?.state = .failed(error: error)
				default:
					break
				}
			} receiveValue: { [weak self] in
				self?.state = .successful
			}
			.store(in: &subscriptions)
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

private extension PostAddViewModel {
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
