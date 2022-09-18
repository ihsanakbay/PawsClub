//
//  HomeView.swift
//  PawsClub
//
//  Created by İhsan Akbay on 21.08.2022.
//

import SwiftUI

struct HomeView: View {
	@ObservedObject var viewModel = HomeViewModel(service: PostManager())
	@StateObject var locationViewModel = LocationViewModel()
	
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
			viewModel.subscribe()
			print("Home: \(viewModel.posts)")
		}
	}
}


struct HomeView_Previews: PreviewProvider {
	static var previews: some View {
		HomeView()
	}
}
