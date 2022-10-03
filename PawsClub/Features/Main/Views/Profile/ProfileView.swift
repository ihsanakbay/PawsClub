//
//  ProfileView.swift
//  PawsClub
//
//  Created by İhsan Akbay on 25.09.2022.
//

import Kingfisher
import SwiftUI

struct ProfileView: View {
	@StateObject private var vm = ProfileViewModel(service: PostService(), authService: AuthenticationService())
	@StateObject var authViewModel = AuthViewModel(service: AuthenticationService())
	@State private var isSettingPresented: Bool = false
	private var isUser: Bool { return authViewModel.user?.uid == vm.userDetails.id ? true : false }

	var body: some View {
		ScrollView {
			HStack(spacing: 8) {
				KFImage(URL(string: vm.userDetails.userImageUrl))
					.placeholder { _ in
						ProgressView()
					}
					.resizable()
					.background(Color.theme.lightPinkColor)
					.clipShape(Circle())
					.frame(width: 100, height: 100)
					.shadow(radius: 3)

				VStack(alignment: .leading, spacing: 8) {
					Text(vm.userDetails.username)
						.font(.headline)
					Text(vm.userDetails.fullname)
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
				.redacted(reason: vm.isLoading ? .placeholder : [])
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
				ForEach(vm.posts, id: \.id) { post in
					NavigationLink {
						LazyView(PostDetailView(viewModel: PostDetailViewModel(post: post, service: PostService())))
					} label: {
						HomeViewListCell(post: post)
					}
				}
			}
		}
		.navigationBarTitleDisplayMode(.inline)
		.navigationTitle("Profile")
		.task {
			await vm.getUserDetails()
			await vm.getUserPosts()
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
