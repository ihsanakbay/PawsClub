//
//  PostDetailViewModel.swift
//  PawsClub
//
//  Created by İhsan Akbay on 25.09.2022.
//

import Combine
import Firebase

@MainActor
final class PostDetailViewModel: ObservableObject {
	@Published var post: Post
	@Published var likeStateIconName = ""
	@Published var isLoading: Bool = false
	@Published var hasError: Bool = false
	@Published var errorMessage: String = ""
	var id = ""
	private var cancellables = Set<AnyCancellable>()

	let service: PostService

	init(post: Post, service: PostService) {
		self.post = post
		self.service = service
		Task { await self.checkIfUserLikedPost() }

		$post
			.map { post in
				post.didLike ?? false ? "heart.fill" : "heart"
			}
			.assign(to: \.likeStateIconName, on: self)
			.store(in: &cancellables)

		$post
			.compactMap { post in
				post.id
			}
			.assign(to: \.id, on: self)
			.store(in: &cancellables)
	}

	func updatePost() async {
		let data = [PostKeys.name.rawValue: post.name,
		            PostKeys.about.rawValue: post.about,
		            PostKeys.kind.rawValue: post.kind,
		            PostKeys.breed.rawValue: post.breed,
		            PostKeys.age.rawValue: post.age,
		            PostKeys.gender.rawValue: post.gender,
		            PostKeys.healthChecks.rawValue: post.healthChecks,
		            PostKeys.isVaccinated.rawValue: post.isVaccinated,
		            PostKeys.isNeutered.rawValue: post.isNeutered,
		            PostKeys.imageUrl.rawValue: post.imageUrl,
		            PostKeys.latitude.rawValue: post.latitude,
		            PostKeys.longitude.rawValue: post.longitude,
		            PostKeys.ownerUid.rawValue: post.ownerUid,
		            PostKeys.ownerUsername.rawValue: post.ownerUsername] as [String: Any]
		
		self.isLoading = true
		defer { self.isLoading = false }
		
		do {
			try await service.updatePost(postId: post.id!, data: data)
		} catch {
			self.hasError = true
			self.errorMessage = error.localizedDescription
		}
	}

	func deletePost() async {
		self.isLoading = true
		defer { self.isLoading = false }
		
		if let postId = post.id {
			do {
				try await service.deletePost(postId: postId)
			} catch {
				hasError = true
				errorMessage = error.localizedDescription
			}
		}
	}

	func likePost() async {
		self.isLoading = true
		defer { self.isLoading = false }
		
		if let postId = post.id,
		   let uid = Auth.auth().currentUser?.uid
		{
			do {
				try await service.likePost(uid: uid, postId: postId)
				post.didLike = true
			} catch {
				hasError = true
				errorMessage = error.localizedDescription
			}
		}
	}

	func unlikePost() async {
		self.isLoading = true
		defer { self.isLoading = false }
		
		if let postId = post.id,
		   let uid = Auth.auth().currentUser?.uid
		{
			do {
				try await service.unlikePost(uid: uid, postId: postId)
				post.didLike = false
			} catch {
				hasError = true
				errorMessage = error.localizedDescription
			}
		}
	}

	func checkIfUserLikedPost() async {
		if let postId = post.id,
		   let uid = Auth.auth().currentUser?.uid
		{
			do {
				let didLike = try await service.checkIfUserLikedPost(uid: uid, postId: postId)
				post.didLike = didLike
			} catch {
				hasError = true
				errorMessage = error.localizedDescription
			}
		}
	}
}
