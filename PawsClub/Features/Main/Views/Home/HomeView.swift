//
//  HomeView.swift
//  PawsClub
//
//  Created by İhsan Akbay on 21.08.2022.
//

import SwiftUI

struct HomeView: View {
//	@ObservedObject var viewModel = HomeViewModel(service: PostManager())
	@ObservedObject var viewModel = PostsListViewModel()
	@StateObject var locationViewModel = LocationViewModel()
	
	var body: some View {
		ScrollView(showsIndicators: false) {
			LazyVStack {
				ForEach(viewModel.postsListCellViewModel, id: \.id) { viewModel in
					NavigationLink {
//						LazyView(PostDetailView(viewModel: PostDetailViewModel(post: post, ownerUid: viewModel.post.ownerUid)))
					} label: {
						HomeViewListCell(viewModel: viewModel)
					}
				}
			}
		}
		.onAppear() {
			
		}
	}
}


struct HomeView_Previews: PreviewProvider {
	static var previews: some View {
		HomeView()
	}
}
