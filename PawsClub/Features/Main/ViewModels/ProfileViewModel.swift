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
	enum State {
		case na
		case loading
		case success(data: [Post])
		case failed(error: Error)
	}
	
	@Published private(set) var state: State = .na
	
	private let service: PostService
	
	init(service: PostService) {
		self.service = service
	}
	
	func getUserPosts() async {
		self.state = .loading
		
		do {
			let posts = try await service.getUserPosts()
			self.state = .success(data: posts)
		} catch {
			self.state = .failed(error: error)
		}
	}
}
