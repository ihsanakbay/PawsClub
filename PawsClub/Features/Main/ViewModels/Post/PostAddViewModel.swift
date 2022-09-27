//
//  PostAddViewModel.swift
//  PawsClub
//
//  Created by İhsan Akbay on 25.09.2022.
//

import SwiftUI
import Firebase

enum NetworkServiceError: Error {
	case failed
	case failedToDecode
	case invalidStatusCode
	case invalidUrl
	case invalidServerResponse
}

class PostAddViewModel: ObservableObject {
	@Published var post: Post = .new
	@Published var breed: Breed = .init(dog: [], cat: [], fish: [], bird: [])
	@Published var image: UIImage = .init()
	@Published var hasError: Bool = false
	@Published var errorMessage: String = ""
	

	@MainActor
	func addPost() {
		guard let uid = Auth.auth().currentUser?.uid else {
			print("Invalid user id.")
			return
		}
		guard let username = Auth.auth().currentUser?.displayName else { return }
		guard let imageData = image.jpegData(compressionQuality: 0.6) else { return }
		let ref = UploadType.Post.filePath
		ref.putData(imageData) { _, error in
			if let error = error {
				self.hasError = true
				self.errorMessage = error.localizedDescription
			}
			ref.downloadURL { url, _ in
				guard let url = url?.absoluteString else { return }
				let data = [PostKeys.name.rawValue: self.post.name,
							PostKeys.about.rawValue: self.post.about,
							PostKeys.kind.rawValue: self.post.kind,
							PostKeys.breed.rawValue: self.post.breed,
							PostKeys.age.rawValue: self.post.age,
							PostKeys.gender.rawValue: self.post.gender,
							PostKeys.healthChecks.rawValue: self.post.healthChecks,
							PostKeys.isVaccinated.rawValue: self.post.isVaccinated,
							PostKeys.isNeutered.rawValue: self.post.isNeutered,
							PostKeys.imageUrl.rawValue: url,
							PostKeys.latitude.rawValue: self.post.latitude,
							PostKeys.longitude.rawValue: self.post.longitude,
							PostKeys.ownerUid.rawValue: uid,
							PostKeys.ownerUsername.rawValue: username,
							PostKeys.timestamp.rawValue: Timestamp(date: Date())] as [String: Any]
				
				COLLECTION_POSTS.addDocument(data: data) { error in
					if let error = error {
						self.hasError = true
						self.errorMessage = error.localizedDescription
					}
					self.hasError = false
				}
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
	
	private func downloadBreeds(_ resource: String) async throws ->  Result<Breed, Error>  {
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
