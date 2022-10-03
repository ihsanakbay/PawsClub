//
//  ProfileViewModel.swift
//  PawsClub
//
//  Created by İhsan Akbay on 27.09.2022.
//

import Firebase
import Foundation

@MainActor
class ProfileViewModel: ObservableObject {
	@Published var posts: [Post] = []
	@Published var userDetails: UserDetails = .new
	@Published var isLoading: Bool = false
	@Published var errorMessage: String = ""
	
	private let service: PostService
	private let authService: AuthenticationService
	
	init(service: PostService, authService: AuthenticationService) {
		self.service = service
		self.authService = authService
	}
	
	func getUserPosts() async {
		self.isLoading = true
		defer { self.isLoading = false }
		
		do {
			let posts = try await service.getUserPosts()
			self.posts = posts
		} catch {
			self.errorMessage = error.localizedDescription
		}
	}
	
	func getUserDetails() async {
		self.isLoading = true
		defer { self.isLoading = false }
		
		guard let uid = Auth.auth().currentUser?.uid else { return }
		do {
			let result = try await authService.getUserDetails(uid: uid)
			if let result = result {
				self.userDetails = result
			}
		} catch {
			self.errorMessage = error.localizedDescription
		}
	}
}
