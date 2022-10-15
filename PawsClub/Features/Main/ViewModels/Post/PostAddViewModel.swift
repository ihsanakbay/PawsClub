//
//  PostAddViewModel.swift
//  PawsClub
//
//  Created by İhsan Akbay on 25.09.2022.
//

import Firebase
import SwiftUI

enum NetworkServiceError: Error {
	case failed
	case failedToDecode
	case invalidStatusCode
	case invalidUrl
	case invalidServerResponse
}

@MainActor
class PostAddViewModel: ObservableObject {
	private var postListViewOutput: PostListViewOutput?
	
	@Published var post: Post = .new
	@Published var breed: Breed = .init(dog: [], cat: [], fish: [], bird: [])
	@Published var image: UIImage = .init()
	@Published var hasError: Bool = false
	@Published var errorMessage: String = ""
	
	var isValid: Bool {
		return post.name.isEmpty ||
			post.about.isEmpty ||
			post.age.isEmpty ||
			post.gender.isEmpty ||
			post.kind.isEmpty ||
			post.breed.isEmpty ||
			image == UIImage()
	}
	
	let service: BreedService
	
	init(postListViewOutput: PostListViewOutput? = nil, service: BreedService) {
		self.postListViewOutput = postListViewOutput
		self.service = service
	}
	
	func setDelegate(postListViewOutput: PostListViewOutput?) {
		self.postListViewOutput = postListViewOutput
	}
	
	func addAndClose() {
		postListViewOutput?.addModelAndClose(post: post, image: image)
	}
	
	func fetchBreeds() async {
		do {
			let result = try await service.getBreeds(BREED_URL)
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
