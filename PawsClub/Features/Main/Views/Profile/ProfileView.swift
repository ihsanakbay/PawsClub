//
//  ProfileView.swift
//  PawsClub
//
//  Created by İhsan Akbay on 25.09.2022.
//

import Kingfisher
import SwiftUI

struct ProfileView: View {
	@StateObject private var viewModel = ProfileViewModel(service: PostService(), authService: AuthenticationService())
	@EnvironmentObject var authViewModel: AuthViewModel
	@State private var isSettingPresented: Bool = false
	var uid: String?
	
	private var isUser: Bool { return authViewModel.user?.uid == viewModel.userDetails.id ? true : false }

	var body: some View {
		ScrollView {
			HStack(spacing: 8) {
				KFImage(URL(string: viewModel.userDetails.userImageUrl))
					.placeholder { _ in
						ProgressView()
					}
					.resizable()
					.background(Color.theme.lightPinkColor)
					.clipShape(Circle())
					.frame(width: 100, height: 100)
					.shadow(radius: 3)

				VStack(alignment: .leading, spacing: 8) {
					Text(viewModel.userDetails.username)
						.font(.headline)
					Text(viewModel.userDetails.fullname)
						.font(.subheadline)
					Spacer()

					if isUser {
						Button {} label: {
							Label("Edit Profile", systemImage: "pencil")
								.padding()
								.font(.system(size: 16, weight: .bold))
								.frame(height: 30)
						}
						.background(Color.theme.pinkColor)
						.foregroundColor(.white)
						.clipShape(RoundedRectangle(cornerRadius: 10))

					} else {
						Button {} label: {
							Label("Send Message", systemImage: "envelope.fill")
								.padding()
								.font(.system(size: 16, weight: .bold))
								.frame(height: 30)
						}
						.background(Color.theme.pinkColor)
						.foregroundColor(.white)
						.clipShape(RoundedRectangle(cornerRadius: 10))
					}
				}
				.redacted(reason: viewModel.isLoading ? .placeholder : [])
				.padding(.leading, 24)
				.foregroundColor(Color.theme.text)

				Spacer()
			}
			.padding(.vertical, 16)
			.padding(.horizontal, 24)

			Text("Posts")
				.font(.headline)
				.padding(.top, 16)

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
		.navigationTitle("Profile")
		.task {
			if let uid = uid {
				await viewModel.getUserDetails(uid: uid)
				await viewModel.getUserPosts(uid: uid)
			} else if let authUid = authViewModel.user?.uid {
				await viewModel.getUserDetails(uid: authUid)
				await viewModel.getUserPosts(uid: authUid)
			}
		}
		.toolbar {
			ToolbarItem(placement: .navigationBarTrailing) {
				Button {
					isSettingPresented.toggle()
				} label: {
					Image(systemName: "gear")
				}
			}
		}
		.sheet(isPresented: $isSettingPresented) {
			SettingsView()
		}
	}
}

struct ProfileView_Previews: PreviewProvider {
	static var previews: some View {
		ProfileView()
	}
}
