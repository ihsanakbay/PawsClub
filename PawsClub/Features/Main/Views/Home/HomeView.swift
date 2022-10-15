//
//  HomeView.swift
//  PawsClub
//
//  Created by İhsan Akbay on 21.08.2022.
//

import SwiftUI

struct HomeView: View {
	@StateObject var viewModel = PostsListViewModel(service: PostService())
	@StateObject var locationViewModel = LocationViewModel()
	@State private var isPostAddViewPresented: Bool = false

	var body: some View {
		ScrollView(showsIndicators: false) {
			LazyVStack {
				ForEach(viewModel.posts, id: \.id) { post in
					NavigationLink {
						LazyView(PostDetailView(viewModel: PostDetailViewModel(post: post, service: PostService())))
					} label: {
						HomeViewListCell(post: post)
							.redacted(reason: viewModel.isLoading ? .placeholder : [])
					}
				}
			}
		}
		.navigationBarTitleDisplayMode(.inline)
		.navigationTitle("Home")
		.toolbar {
			ToolbarItem(placement: .navigationBarTrailing) {
				Button {
					self.isPostAddViewPresented = true
				} label: {
					Image(systemName: "plus.app.fill")
				}
				.font(.system(size: 20))
			}
		}
		.alert(isPresented: $viewModel.hasError) {
			Alert(
				title: Text("Error"),
				message: Text(viewModel.errorMessage ?? "Something went wrong"),
				primaryButton: .cancel(),
				secondaryButton: .default(Text("Retry"), action: {
					viewModel.subscribe()
				}))
		}
		.sheet(isPresented: $isPostAddViewPresented, content: {
			NavigationView {
				PostAddView(delegate: viewModel)
					.toolbar {
						ToolbarItem(placement: .navigationBarLeading) {
							Button {
								self.isPostAddViewPresented = false
								viewModel.clear()
							} label: {
								Text("Cancel")
							}
							.foregroundColor(.red)
						}
					}
			}
		})
	}
}

struct HomeView_Previews: PreviewProvider {
	static var previews: some View {
		HomeView()
	}
}
