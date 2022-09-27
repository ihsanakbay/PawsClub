//
//  ProfileView.swift
//  PawsClub
//
//  Created by İhsan Akbay on 25.09.2022.
//

import SwiftUI

struct ProfileView: View {
	@StateObject private var vm = ProfileViewModel(service: PostService())
	@EnvironmentObject var authViewModel: AuthViewModel

	var body: some View {
		ScrollView {
			switch vm.state {
			case .success(data: let posts):
				VStack(spacing: 8) {
					AsyncImage(url: authViewModel.user?.photoURL) { phase in
						if let image = phase.image {
							image
								.resizable()
								.frame(width: 36, height: 27.5)
								.foregroundColor(.white)
								.padding(48)
								.background(Color.theme.lightPinkColor)
								.clipShape(Circle())
								.frame(width: 100, height: 100)
								.shadow(radius: 3)
						} else if phase.error != nil {
							Image(systemName: "questionmark.app.fill") // Indicates an error.
								.resizable()
								.frame(width: 36, height: 27.5)
								.foregroundColor(.white)
								.padding(48)
								.background(Color.theme.lightPinkColor)
								.clipShape(Circle())
								.frame(width: 100, height: 100)
								.shadow(radius: 3)
						} else {
							Image(systemName: "person.fill") // Acts as a placeholder.
								.resizable()
								.frame(width: 36, height: 27.5)
								.foregroundColor(.white)
								.padding(48)
								.background(Color.theme.lightPinkColor)
								.clipShape(Circle())
								.frame(width: 100, height: 100)
								.shadow(radius: 3)
						}
					}

					Text(authViewModel.user?.displayName ?? "N/A")
						.padding()
						.font(.title)
						.foregroundColor(Color.theme.text)
					

					Button {
						// Send message to user
					} label: {
						Label("Send Message", systemImage: "envelope")
							.font(.body.bold())
					}
					.padding()
					.buttonStyle(.borderedProminent)
					.frame(height: 40)
				}
				.padding(32)

				Text("Posts")
					.font(.headline)

				LazyVStack {
					ForEach(posts, id: \.id) { post in
						NavigationLink {
							LazyView(PostDetailView(viewModel: PostDetailViewModel(post: post)))
						} label: {
							HomeViewListCell(post: post)
						}
					}
				}
			case .loading:
				ProgressView()
			default:
				EmptyView()
			}
		}
		.task {
			await vm.getUserPosts()
		}
	}
}

struct ProfileView_Previews: PreviewProvider {
	static var previews: some View {
		ProfileView()
	}
}
