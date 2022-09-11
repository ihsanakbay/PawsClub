//
//  HomeView.swift
//  PawsClub
//
//  Created by İhsan Akbay on 21.08.2022.
//

import SwiftUI

struct HomeView: View {
	@StateObject var viewModel = HomeViewModel(service: PostManager())
	
	var body: some View {
		ScrollView(showsIndicators: false) {
			LazyVStack {
				ForEach(viewModel.posts, id: \.id) { post in
					NavigationLink {
//						LazyView(PostDetailView(viewModel: PostDetailViewModel(post: post, ownerUid: post.ownerUid)))
					} label: {
						HomeViewListCell(post: post)
					}
				}
			}
		}
		.task {
			await viewModel.fetchPosts()
		}
	}
}

struct HomeView_Previews: PreviewProvider {
	static var previews: some View {
		HomeView()
	}
}
