//
//  FavoritesView.swift
//  PawsClub
//
//  Created by İhsan Akbay on 25.09.2022.
//

import SwiftUI

struct FavoritesView: View {
	@ObservedObject var viewModel = FavoritesViewModel()
	@StateObject var locationViewModel = LocationViewModel()

	var body: some View {
		ScrollView(showsIndicators: false) {
			if viewModel.isLoading {
				ProgressView()
			} else {
				LazyVStack {
					ForEach(viewModel.posts, id: \.id) { post in
						NavigationLink {
							LazyView(PostDetailView(viewModel: PostDetailViewModel(post: post, service: PostService())))
						} label: {
							HomeViewListCell(post: post)
						}
					}
				}
			}
		}
		.navigationBarTitleDisplayMode(.inline)
		.navigationTitle("Favorites")
		.onAppear {
			viewModel.fetchLikedPosts()
		}
	}
}

struct FavoritesView_Previews: PreviewProvider {
	static var previews: some View {
		FavoritesView()
	}
}
