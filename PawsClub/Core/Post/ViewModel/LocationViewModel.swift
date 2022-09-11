//
//  LocationViewModel.swift
//  PawsClub
//
//  Created by İhsan Akbay on 4.09.2022.
//

import SwiftUI
import Combine
import MapKit
import CoreLocation

final class LocationViewModel: NSObject, ObservableObject, MKMapViewDelegate, CLLocationManagerDelegate {
	
	@Published var mapView: MKMapView = .init()
	@Published var manager: CLLocationManager = .init()

	@Published var fetchedPlaces: [CLPlacemark]?
	@Published var searchText: String = ""
	@Published var userLocation: CLLocation?
	@Published var userLocationName: String?

	@Published var pickedLocation: CLLocation?
	@Published var pickedPlacemark: CLPlacemark?
	

	var cancellable: AnyCancellable?
	
	override init() {
		super.init()
		manager.delegate = self
		mapView.delegate = self

		// MARK: Request location access
		manager.requestWhenInUseAuthorization()

		// MARK: Search Textfield watching
		cancellable = $searchText
			.debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
			.removeDuplicates()
			.sink(receiveValue: { value in
				if value != "" {
					self.fetchPlaces(value: value)
				} else {
					self.fetchedPlaces = nil
				}
			})
	}
	
	func fetchPlaces(value: String) {
		Task {
			do {
				let request = MKLocalSearch.Request()
				request.naturalLanguageQuery = value.lowercased()

				let response = try await MKLocalSearch(request: request).start()
				await MainActor.run(body: {
					self.fetchedPlaces = response.mapItems.compactMap({ item -> CLPlacemark? in
						return item.placemark
					})
				})
			} catch {

			}
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let currentLocation = locations.last else { return }
		self.userLocation = currentLocation
		getLocationName(location: currentLocation) { name in
			self.userLocationName = name
		}
	}

	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

	}

	func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
		switch manager.authorizationStatus {
		case .notDetermined: manager.requestWhenInUseAuthorization()
		case .denied: handleLocationError()
		case .authorizedAlways: manager.requestLocation()
		case .authorizedWhenInUse: manager.requestLocation()
		default: ()
		}
	}

	func handleLocationError() {
		// TODO: Show error message when user not allowed to access user location
		#warning("Show error message when user not allowed to access user location")
	}

	func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
		guard let newLocation = view.annotation?.coordinate else {return}
		self.pickedLocation = .init(latitude: newLocation.latitude, longitude: newLocation.longitude)
		updatePlacemark(location: .init(latitude: newLocation.latitude, longitude: newLocation.longitude))
	}

	func updatePlacemark(location: CLLocation) {
		Task {
			do {
				guard let place = try await reverseLocationCoordinates(location: location) else { return }
				await MainActor.run(body: {
					self.pickedPlacemark = place
				})
			} catch {

			}
		}
	}

	func reverseLocationCoordinates(location: CLLocation) async throws -> CLPlacemark? {
		let place = try await CLGeocoder().reverseGeocodeLocation(location).first
		return place
	}
	
	func getLocationName(location: CLLocation, completion: @escaping((String)-> ())) {
		CLGeocoder().reverseGeocodeLocation(location) { placemark, _ in
			if let place = placemark?.first{
				let locationName = "\(place.locality ?? "")\(place.locality != nil ? ", " : "")\(place.country ?? "")"
				completion(locationName)
			}
		}
	}
	
}
