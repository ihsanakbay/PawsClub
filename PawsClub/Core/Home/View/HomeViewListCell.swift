//
//  HomeViewListCell.swift
//  PawsClub
//
//  Created by İhsan Akbay on 21.08.2022.
//

import SwiftUI
import Kingfisher

struct HomeViewListCell: View {
	let screenSize = UIScreen.main.bounds
//	var post: Post
	
	var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 25)
				.fill(Color.theme.cellBackgroundColor)
				.opacity(0.9)
				.frame(height: 120)

//			HStack {
//				KFImage(URL(string: post.postImageUrl))
//					.resizable()
//					.scaledToFill()
//					.aspectRatio(contentMode: .fill)
//					.frame(width: screenSize.width / 3, height: 120)
//					.clipped()
//					.cornerRadius(25)
//
//				Spacer()
//
//				VStack(alignment: .leading, spacing: 8) {
//					HStack(alignment: .center, spacing: 4) {
//						Text(post.name)
//							.font(.system(size: 16, weight: .semibold))
//
//						Spacer()
//
//						Image(post.gender.lowercased())
//							.resizable()
//							.scaledToFit()
//							.foregroundColor(post.gender.lowercased() == "female" ? Color.theme.femaleIconColor : Color.theme.maleIconColor)
//							.frame(height: 18)
//					}
//
//					HStack(spacing: 8) {
//						Text(post.kind)
//						Text(post.breed)
//					}
//
//					Text(post.age)
//
//					HStack(alignment: .center, spacing: 2) {
//						Image(systemName: "location.fill")
//							.foregroundColor(Color.theme.pinkColor)
//						Text(place)
//					}
//				}
//				.font(.system(size: 14))
//				.padding()
//				.foregroundColor(Color.theme.text)
//
//			}
//			.frame(height: 120)
//		}
//		.padding(.horizontal)
//		.padding(.vertical, 8)
//		.task {
//			let place = try? await reverseLocationCoordinates(location: CLLocation(latitude: post.latitude, longitude: post.longitude))
//			let locality = place?.locality ?? "N/A"
//			let country = place?.country ?? "N/A"
//			self.place = "\(locality), \(country)"
		}
	}

//	func reverseLocationCoordinates(location: CLLocation) async throws -> CLPlacemark? {
//		let place = try await CLGeocoder().reverseGeocodeLocation(location).first
//		return place
//	}
}

struct HomeViewListCell_Previews: PreviewProvider {
    static var previews: some View {
        HomeViewListCell()
    }
}
