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
			LazyVStack {
				ForEach(viewModel.posts, id: \.id) { post in
					NavigationLink {
//						LazyView(PostDetailView(viewModel: PostDetailViewModel(post: post, ownerUid: viewModel.post.ownerUid)))
					} label: {
						HomeViewListCell(post: post)
					}
				}
			}
		}
		.onAppear() {
			viewModel.subscribe()
		}
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
