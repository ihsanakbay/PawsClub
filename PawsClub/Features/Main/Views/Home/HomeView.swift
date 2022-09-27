//
//  HomeView.swift
//  PawsClub
//
//  Created by İhsan Akbay on 21.08.2022.
//

import SwiftUI

struct HomeView: View {
	@StateObject var viewModel = PostsListViewModel()
	@StateObject var locationViewModel = LocationViewModel()

	var body: some View {
		ScrollView(showsIndicators: false) {
			LazyVStack {
				ForEach(viewModel.posts, id: \.id) { post in
					NavigationLink {
						LazyView(PostDetailView(viewModel: PostDetailViewModel(post: post)))
					} label: {
						HomeViewListCell(post: post)
							.redacted(reason: viewModel.isLoading ? .placeholder : [])
					}
				}
			}
		}
		.onAppear {
			viewModel.subscribe()
		}
	}
}

struct HomeView_Previews: PreviewProvider {
	static var previews: some View {
		HomeView()
	}
}
