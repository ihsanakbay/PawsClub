//
//  PostAddView.swift
//  PawsClub
//
//  Created by İhsan Akbay on 2.09.2022.
//

import CoreLocationUI
import Kingfisher
import SwiftUI

struct PostAddView: View {
	@Environment(\.dismiss) var dismiss
	@StateObject var viewModel = PostAddViewModel()
	@StateObject var locationViewModel = LocationViewModel()
	@FocusState var isInputActive: Bool
	
	let delegate: PostListViewOutput?
	
	@State private var isImagePickerPresented: Bool = false
	@State private var isLocationViewPresented: Bool = false
	@State private var selectedImage: UIImage = .init()
	@State private var selectedKind: PET_KIND = .Other
	@State private var selectedBreed: String = "Other"
	@State private var selectedAge: PET_AGE = .baby
	@State private var selectedGender: PET_GENDER = .female
	@State private var selectedLocationName: String = ""
	
	var body: some View {
		List {
			Section {
				HStack {
					Spacer()
					
					if selectedImage == UIImage() {
						Image("camera")
							.resizable()
							.frame(width: 72, height: 55.2)
							.foregroundColor(.white)
							.padding(48)
							.background(Color.theme.lightPinkColor)
							.clipShape(Circle())
							.frame(width: 150, height: 150)
							.shadow(radius: 3)
							.onTapGesture { isImagePickerPresented.toggle() }
					} else {
						Image(uiImage: selectedImage)
							.resizable()
							.scaledToFill()
							.background(Color.theme.lightPinkColor)
							.clipShape(Circle())
							.frame(width: 150, height: 150)
							.shadow(radius: 3)
							.onTapGesture { isImagePickerPresented.toggle() }
					}
					
					Spacer()
				}
			}
			.listRowBackground(Color.clear)
			
			Section("Pet Information") {
				TextField("Name", text: $viewModel.post.name)
				ZStack(alignment: .topLeading) {
					TextEditor(text: $viewModel.post.about)
						.padding(.horizontal, -5)
						.padding(.vertical, -5)
						.frame(minHeight: 120)
						.focused($isInputActive)
					Text("About")
						.foregroundColor(Color.theme.placeholder)
						.padding(.top, 3)
						.opacity(viewModel.post.about.isEmpty ? 1 : 0)
						.focused($isInputActive)
				}
				
				Picker("Kind", selection: $selectedKind) {
					ForEach(PET_KIND.allCases) { kind in
						Text(kind.rawValue.capitalized)
					}
				}
				.onChange(of: selectedKind.rawValue) { newValue in
					viewModel.post.kind = newValue
				}
				
				Picker("Breed", selection: $selectedBreed) {
					switch selectedKind {
					case .Dog:
						let breedData = viewModel.breed.dog
						ForEach(breedData, id: \.self) { breed in
							Text(breed)
						}
					case .Cat:
						let breedData = viewModel.breed.cat
						ForEach(breedData, id: \.self) { breed in
							Text(breed)
						}
					case .Bird:
						let breedData = viewModel.breed.bird
						ForEach(breedData, id: \.self) { breed in
							Text(breed)
						}
					case .Fish:
						let breedData = viewModel.breed.fish
						ForEach(breedData, id: \.self) { breed in
							Text(breed)
						}
					case .Other:
						let breedData = ["Other"]
						ForEach(breedData, id: \.self) { breed in
							Text(breed)
						}
					}
				}
				.onChange(of: selectedBreed) { newValue in
					viewModel.post.breed = newValue
				}
				
				Picker("Gender", selection: $selectedGender) {
					ForEach(PET_GENDER.allCases) { gender in
						Text(gender.rawValue.capitalized)
					}
				}
				.onChange(of: selectedGender.rawValue) { newValue in
					viewModel.post.gender = newValue
				}
				
				Picker("Age", selection: $selectedAge) {
					ForEach(PET_AGE.allCases) { age in
						Text(age.rawValue.capitalized)
					}
				}
				.onChange(of: selectedAge.rawValue) { newValue in
					viewModel.post.age = newValue
				}
				
				HStack {
					Text("Location")
					Spacer()
						
					Text(selectedLocationName)
						.foregroundColor(Color.gray)
					Image(systemName: "chevron.right")
						.font(.subheadline)
				}
				.contentShape(Rectangle())
				.onTapGesture {
					isLocationViewPresented.toggle()
				}
				
				Toggle("Health Checks", isOn: $viewModel.post.healthChecks)
				
				Toggle("Vaccinated", isOn: $viewModel.post.isVaccinated)
				
				Toggle("Neutered", isOn: $viewModel.post.isNeutered)
			}
		}
		.task {
			await viewModel.fetchBreeds()
		}
		.navigationTitle("Create New Post")
		.navigationBarTitleDisplayMode(.inline)
		.toolbar {
			ToolbarItemGroup(placement: .keyboard) {
				Spacer()
				Button("Done") {
					isInputActive = false
					hideKeyboard()
				}
			}
			
			ToolbarItem(placement: .navigationBarTrailing) {
				Button {
					viewModel.addAndClose()
					isInputActive = false
					dismiss()
				} label: {
					Text("Share")
				}
				.disabled(viewModel.isValid)
			}
		}
		.onAppear(perform: {
			viewModel.setDelegate(postListViewOutput: delegate)
			viewModel.post.kind = selectedKind.rawValue.capitalized
			viewModel.post.age = selectedAge.rawValue.capitalized
			viewModel.post.gender = selectedGender.rawValue.capitalized
			if let locationName = locationViewModel.userLocationName {
				selectedLocationName = locationName
			}
		})
		.onChange(of: locationViewModel.userLocationName, perform: { _ in
			if let locationName = locationViewModel.userLocationName {
				selectedLocationName = locationName
			}
		})
		.onDisappear(perform: {
			locationViewModel.userLocationName = ""
			selectedLocationName = ""
		})
		.sheet(isPresented: $isImagePickerPresented, onDismiss: loadImage) {
			PhotoPicker(selectedImage: $selectedImage)
		}
		.sheet(isPresented: $isLocationViewPresented) {
			LocationView(latitude: $viewModel.post.latitude, longitude: $viewModel.post.longitude, selectedLocationName: $selectedLocationName)
		}
	}
	
	private func loadImage() {
		viewModel.image = selectedImage
	}
}

struct PostAddView_Previews: PreviewProvider {
	static var previews: some View {
		PostAddView(delegate: nil)
	}
}
