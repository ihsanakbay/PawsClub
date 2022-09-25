//
//  PostAddViewModel.swift
//  PawsClub
//
//  Created by İhsan Akbay on 25.09.2022.
//

import SwiftUI

class PostAddViewModel: ObservableObject {
	@Published var postsRepository = PostsRepository()
	@Published var post: Post = .new
	@Published var breed: Breed = .init(dog: [], cat: [], fish: [], bird: [])
	@Published var image: UIImage = .init()
	@Published var hasError: Bool = false
	@Published var errorMessage: String = ""
	
	var breedService: BreedService
	
	init(breedService: BreedService) {
		self.breedService = breedService
	}
	
	@MainActor
	func addPost() {
		postsRepository.addPost(post, image: image) { result in
			switch result {
			case .success():
				self.hasError = false
			case .failure(let err):
				self.hasError = true
				self.errorMessage = err.localizedDescription
			}
		}
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
				breed = data
				hasError = false
			case .failure(let error):
				hasError = true
				errorMessage = error.localizedDescription
				return
			}
		} catch {
			hasError = true
			errorMessage = error.localizedDescription
			return
		}
	}
}
