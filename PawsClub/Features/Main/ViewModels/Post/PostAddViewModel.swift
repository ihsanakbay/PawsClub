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
	
	init(postListViewOutput: PostListViewOutput? = nil) {
		self.postListViewOutput = postListViewOutput
	}
	
	func setDelegate(postListViewOutput: PostListViewOutput?) {
		self.postListViewOutput = postListViewOutput
	}
	
	func addAndClose() {
		postListViewOutput?.addModelAndClose(post: post, image: image)
	}
	
	@MainActor
	func clear() {
		post = Post.new
		breed = Breed(dog: [], cat: [], fish: [], bird: [])
	}
	
	@MainActor
	func fetchBreeds() async {
		do {
			let result = try await downloadBreeds(BREED_URL)
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
	
	private func downloadBreeds(_ resource: String) async throws -> Result<Breed, Error> {
		guard let url = URL(string: resource) else { throw NetworkServiceError.invalidUrl }

		let (data, response) = try await URLSession.shared.data(from: url)

		guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
			throw NetworkServiceError.invalidServerResponse
		}
		
		do {
			let result = try JSONDecoder().decode(Breed.self, from: data)
			return .success(result)
		} catch {
			return .failure(error)
		}
	}
}
