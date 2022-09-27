//
//  PostDetailView.swift
//  PawsClub
//
//  Created by İhsan Akbay on 11.09.2022.
//

import CoreLocation
import Firebase
import Kingfisher
import SwiftUI

struct PostDetailView: View {
	@Environment(\.dismiss) var dismiss
	@ObservedObject var viewModel: PostDetailViewModel
	@StateObject var locationViewModel = LocationViewModel()
	@State private var postLocation: String?
	@State private var isShowingConfirmation: Bool = false
	
	private var didLike: Bool { return viewModel.post.didLike ?? false }
	
	var timestampString: String {
		let formatter = DateFormatter()
		formatter.dateStyle = .long
		formatter.timeStyle = .none
		return formatter.string(from: viewModel.post.timestamp.dateValue())
	}
	
	init(viewModel: PostDetailViewModel) {
		self.viewModel = viewModel
	}
	
	var body: some View {
		ZStack {
			Color.theme.backgroundColor
				.ignoresSafeArea()
			
			ScrollView(showsIndicators: false) {
				VStack {
					ZStack(alignment: .topLeading) {
						imageSection
							
						HStack(alignment: .firstTextBaseline) {
							toolbarBackButton
							Spacer()
							if viewModel.post.ownerUid == Auth.auth().currentUser?.uid {
								toolbarEditButton
							}
						}
						.padding()
						.padding(.trailing, 8)
						.padding(.top, 32)
					}
					
					VStack(alignment: .leading, spacing: 16) {
						titleSection
						Divider()
						descriptionSection
						Divider()
						ownerSection
					}
					.frame(maxWidth: .infinity, alignment: .leading)
					.padding(.horizontal)
				}
			}
			.padding(.bottom, 32)
			.ignoresSafeArea()
			.navigationBarHidden(true)
		}
		.onAppear {
			locationViewModel.getLocationName(location: CLLocation(latitude: viewModel.post.latitude, longitude: viewModel.post.longitude)) { name in
				postLocation = name
			}
		}
		.alert(isPresented: $viewModel.hasError) {
			Alert(title: Text("Error"), message: Text(viewModel.errorMessage))
		}
	}
}

extension PostDetailView {
	private var imageSection: some View {
		TabView {
			KFImage(URL(string: viewModel.post.imageUrl))
				.resizable()
				.scaledToFill()
				.frame(width: screenSize.width)
				.clipped()
		}
		.tabViewStyle(.page)
		.frame(width: screenSize.width, height: screenSize.height / 2)
		.shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 10)
	}
	
	private var titleSection: some View {
		VStack(alignment: .leading, spacing: 8) {
			HStack {
				Text(viewModel.post.name)
					.font(.title)
					.fontWeight(.semibold)
					.foregroundColor(Color.theme.text)
				
				Image(viewModel.post.gender.lowercased())
					.padding(.horizontal)
					.foregroundColor(viewModel.post.gender.lowercased() == "female" ? Color.theme.femaleIconColor : Color.theme.maleIconColor)
				
				Spacer()
				
				Button {} label: {
					Image(systemName: viewModel.likeStateIconName)
				}
				.font(.title2)
				.foregroundColor(Color.theme.pinkColor)
			}
			
			HStack(spacing: 4) {
				Image(systemName: "location.fill")
					.font(.body)
					.foregroundColor(Color.theme.pinkColor)
				
				Text(postLocation ?? "N/A")
					.font(.body)
					.foregroundColor(Color.theme.text)
			}
			
			HStack(spacing: 4) {
				Text(viewModel.post.kind)
					.font(.body)
					.padding(.trailing)
				
				Text("·")
					.font(.title)
				
				Text(viewModel.post.breed)
					.font(.body)
					.padding(.trailing)
				
				Text("·")
					.font(.title)
				
				Text(viewModel.post.age)
					.font(.body)
			}
			.foregroundColor(Color.theme.text)
		}
	}
	
	private var descriptionSection: some View {
		VStack(alignment: .leading, spacing: 8) {
			Text("About")
				.font(.headline)
			
			Text(viewModel.post.about)
				.font(.subheadline)
				.foregroundColor(.secondary)
				.padding(.leading, 8)
		}
	}
	
	private var ownerSection: some View {
		VStack(alignment: .leading, spacing: 8) {
			Text("Shared")
				.font(.headline)
			
			NavigationLink {
//				LazyView(ProfileView(uid: viewModel.post.ownerUid))
			} label: {
				VStack(alignment: .leading, spacing: 4) {
					Text(viewModel.post.ownerUsername)
						.foregroundColor(Color.theme.pinkColor)
					Text(timestampString)
						.foregroundColor(.secondary)
						.font(.subheadline)
				}
			}
			.padding(.leading, 8)
		}
		.padding(.bottom)
	}
	
	private var toolbarBackButton: some View {
		Button {
			dismiss()
		} label: {
			Image(systemName: "arrow.left")
				.frame(width: 32, height: 32)
		}
		.toolbarButton()
	}
	
	private var toolbarEditButton: some View {
		Button {
			isShowingConfirmation = true
		} label: {
			Image(systemName: "trash.fill")
				.frame(width: 32, height: 32)
		}
		.toolbarButton()
		.confirmationDialog("Are you sure?", isPresented: $isShowingConfirmation, titleVisibility: .visible, actions: {
			Button("Delete", role: .destructive) {
				viewModel.deletePost()
				dismiss()
			}
		})
	}
}

struct ToolbarButtonModifiers: ViewModifier {
	func body(content: Content) -> some View {
		content
			.frame(width: 32, height: 32)
			.font(.headline)
			.foregroundColor(Color.white)
			.background(Color.theme.greenColor.opacity(0.5))
			.cornerRadius(16)
			.shadow(color: .black.opacity(0.2), radius: 10, x: 10, y: 10)
			.shadow(color: .white.opacity(0.2), radius: 10, x: -5, y: -5)
	}
}

extension View {
	func toolbarButton() -> some View {
		modifier(ToolbarButtonModifiers())
	}
}

struct PostDetailView_Previews: PreviewProvider {
	static var previews: some View {
		PostDetailView(viewModel: PostDetailViewModel(post: Post.new))
	}
}
