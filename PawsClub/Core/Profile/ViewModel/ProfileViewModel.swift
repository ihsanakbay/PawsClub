//
//  ProfileViewModel.swift
//  PawsClub
//
//  Created by İhsan Akbay on 18.09.2022.
//

import SwiftUI

final class ProfileViewModel: ObservableObject {
	@Published var state: ServiceState = .na
	@Published var posts: [Post] = []
	@Published var hasError: Bool = false
	@Published var isLoading: Bool = false
	@Published var user: SessionUserDetails = SessionUserDetails(id: "", email: "", username: "", fullname: "", imageUrl: "")
	let uid: String
	
	var service: ProfileService
	
	init(service: ProfileService, uid: String) {
		self.service = service
		self.uid = uid
		if uid != "" {
			self.fetchUserPosts(forUid: uid)
			self.fetchUserInfo(forUid: uid)
		}
	}
	
	func fetchUserPosts(forUid uid: String) {
		isLoading = true
		
		service.fetchUserPosts(forUid: uid) { result in
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
	
	func fetchUserInfo(forUid uid: String) {
		isLoading = true
		
		service.fetchUserInfo(forUid: uid) { result in
			switch result {
			case .success(let user):
				self.user = user
				self.state = .successful
			case .failure(let err):
				self.state = .failed(error: err)
				self.hasError = true
			}
		}
		isLoading = false
	}
	
}
