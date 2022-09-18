//
//  FavoritesView.swift
//  PawsClub
//
//  Created by İhsan Akbay on 21.08.2022.
//

import SwiftUI

struct FavoritesView: View {
	@EnvironmentObject var session: SessionManager
	@ObservedObject var viewModel = FavoritesViewModel(service: PostManager())
	@State private var hasError: Bool = false
	
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
		.onAppear {
			if let user = session.userDetails {
//				DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
					viewModel.fetchFavorites(user: user)
//				}
			} else {
				hasError = true
			}
		}
		.alert(isPresented: $hasError) {
			Alert(title: Text("We are sorry :("), message: Text("Something went wrong"), dismissButton: .cancel(Text("Ok")))
		}
	}
}

struct FavoritesView_Previews: PreviewProvider {
	static var previews: some View {
		FavoritesView()
	}
}
