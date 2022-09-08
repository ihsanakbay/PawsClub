//
//  HomeView.swift
//  PawsClub
//
//  Created by İhsan Akbay on 21.08.2022.
//

import SwiftUI

struct HomeView: View {
	
    var body: some View {
		ScrollView(showsIndicators: false) {
			LazyVStack {
//				ForEach(viewModel.posts, id: \.id) { post in
//					NavigationLink {
//						LazyView(PostDetailView(viewModel: PostDetailViewModel(post: post, ownerUid: post.ownerUid)))
//					} label: {
//						HomeCell(post: post, place: "")
//					}
//				}
			}
		}
//		.onAppear {
//			Task {
//				await viewModel.fetchPosts()
//			}
//		}
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
