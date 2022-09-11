//
//  LocationView.swift
//  PawsClub
//
//  Created by İhsan Akbay on 4.09.2022.
//

import SwiftUI

struct LocationView: View {
	@StateObject var viewModel = LocationViewModel()
	@Environment(\.dismiss) var dismiss
	@Binding var latitude: Double
	@Binding var longitude: Double
	@Binding var selectedLocationName: String
	
	
	var body: some View {
		NavigationView {
			List {
				if let places = viewModel.fetchedPlaces {
					ForEach(places, id: \.self) { place in
						ZStack {
							VStack(alignment: .leading, spacing: 4) {
								HStack {
									Text(place.name ?? "")
										.font(.body.bold())
										.foregroundColor(Color.theme.text)
										.frame(maxWidth: .infinity, alignment: .leading)
								}
								HStack(spacing: 0) {
									Text(place.locality ?? "")
									Text(place.locality != nil ? ", " : "")
									Text(place.country ?? "")
								}
								.frame(maxWidth: .infinity, alignment: .leading)
								.font(.caption)
								.foregroundColor(Color.theme.textSecondary)
							}
							Spacer()
						}
						.frame(maxWidth: .infinity)
						.onTapGesture {
							if let coordinate = place.location?.coordinate {
								selectedLocationName = place.name!
								latitude = coordinate.latitude
								longitude = coordinate.longitude
								dismiss()
							}
						}
					}
				}
			}
			.searchable(text: $viewModel.searchText)
			.navigationTitle("Location")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					Button {
						dismiss()
					} label: {
						Text("Cancel")
					}
					.foregroundColor(.red)
				}
			}
		}
	}
}

struct LocationView_Previews: PreviewProvider {
	static var previews: some View {
		LocationView(latitude: .constant(41.1141262), longitude: .constant(27.7517152), selectedLocationName: .constant("Çorlu"))
	}
}
