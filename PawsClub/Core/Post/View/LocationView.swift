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
//	@Binding var selectedLocation: Coordinate
	@Binding var latitude: Double
	@Binding var longitude: Double
	@Binding var selectedLocationName: String
	
	
	var body: some View {
		NavigationView {
			List {
				if let places = viewModel.fetchedPlaces {
					ForEach(places, id: \.self) { place in
						VStack(alignment: .leading, spacing: 4) {
							Text(place.name ?? "")
								.font(.body.bold())
								.foregroundColor(Color.theme.text)
							Text(place.locality ?? "")
								.font(.caption)
								.foregroundColor(Color.theme.textSecondary) +
							Text(place.locality != nil ? ", " : "")
								.font(.caption)
								.foregroundColor(Color.theme.textSecondary) +
							Text(place.country ?? "")
								.font(.caption)
								.foregroundColor(Color.theme.textSecondary)
						}
						.onTapGesture {
							if let coordinate = place.location?.coordinate {
								selectedLocationName = place.name!
//								selectedLocation = Coordinate(latitude: coordinate.latitude, longitude: coordinate.longitude)
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
			.listStyle(.plain)
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

//struct LocationView_Previews: PreviewProvider {
//	static var previews: some View {
//		LocationView(selectedLocation: <#Binding<Coordinate>#>, selectedLocationName: <#Binding<String>#>)
//	}
//}
