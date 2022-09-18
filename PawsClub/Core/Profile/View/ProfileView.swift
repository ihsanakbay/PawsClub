//
//  ProfileView.swift
//  PawsClub
//
//  Created by İhsan Akbay on 21.08.2022.
//

import SwiftUI

struct ProfileView: View {
	@State private var isSettingViewPresented: Bool = false
	@ObservedObject private var viewModel: ProfileViewModel
	private var uid: String
	
	init(uid: String) {
		self.viewModel = ProfileViewModel(service: ProfileManager(), uid: uid)
		self.uid = uid
	}
	
    var body: some View {
		ScrollView(showsIndicators: false) {
			LazyVStack {
				ForEach(viewModel.posts, id: \.id) { post in
					NavigationLink {
						LazyView(PostDetailView(viewModel: PostDetailViewModel(post: post, ownerUid: post.ownerUid)))
					} label: {
						HomeViewListCell(post: post)
					}
				}
			}
		}
		.onAppear() {
//			viewModel.subscribe()
		}
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
		ProfileView(uid: "")
    }
}
