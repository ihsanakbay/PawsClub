//
//  HomeViewListCell.swift
//  PawsClub
//
//  Created by İhsan Akbay on 21.08.2022.
//

import SwiftUI
import Kingfisher
import CoreLocation

struct HomeViewListCell: View {
	@StateObject var locationViewModel = LocationViewModel()
	@State private var postLocation: String?
	
	let screenSize = UIScreen.main.bounds
	var post: Post
	
	var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 25)
				.fill(Color.theme.cellBackgroundColor)
				.opacity(0.9)
				.frame(height: 120)

			HStack {
				KFImage(URL(string: post.imageUrl))
					.resizable()
					.scaledToFill()
					.aspectRatio(contentMode: .fill)
					.frame(width: screenSize.width / 3, height: 120)
					.clipped()
					.cornerRadius(25)

				Spacer()

				VStack(alignment: .leading, spacing: 8) {
					HStack(alignment: .center, spacing: 4) {
						Text(post.name)
							.font(.system(size: 16, weight: .semibold))

						Spacer()

						Image(post.gender.lowercased())
							.resizable()
							.scaledToFit()
							.foregroundColor(post.gender.lowercased() == "female" ? Color.theme.femaleIconColor : Color.theme.maleIconColor)
							.frame(height: 18)
					}

					HStack(spacing: 8) {
						Text(post.kind)
						HStack {
							Image(systemName: "circle.fill")
								.resizable()
								.frame(width: 8, height: 8)
								.padding(.leading)
								.foregroundColor(Color.theme.pinkColor)
							Text(post.age)
						}
					}

					Text(post.breed)

					HStack(alignment: .center, spacing: 2) {
						Image(systemName: "location.fill")
							.foregroundColor(Color.theme.pinkColor)
						Text(postLocation ?? "N/A")
							.minimumScaleFactor(0.7)
						Spacer()
					}
					.frame(maxWidth: .infinity)
				}
				.font(.system(size: 14))
				.padding()
				.foregroundColor(Color.theme.text)

			}
			.frame(height: 120)
		}
		.onAppear(perform: {
			locationViewModel.getLocationName(location: CLLocation(latitude: post.latitude, longitude: post.longitude)) { location in
				postLocation = location
			}
		})
		.padding(.horizontal)
		.padding(.vertical, 8)
	}
}

struct HomeViewListCell_Previews: PreviewProvider {
    static var previews: some View {
		HomeViewListCell(post: Post(name: "Maya", about: "Maya was found abandoned as a baby", kind: "Cat", breed: "Norweign Forest Cat", age: "Baby", gender: "Female", healthChecks: true, isVaccinated: true, isNeutered: true, latitude: 41.162033, longitude: 27.799824, imageUrl: "https://firebasestorage.googleapis.com:443/v0/b/pawsclub-8920b.appspot.com/o/post_images%2F0B29E245-1893-4C02-97AD-92F189EA1576?alt=media&token=5bd7cbad-d058-4a62-9cf9-9a2870efcb13", ownerUid: "X56NG8yGGzQRjPwbjd2C9ZNIQa73", ownerUsername: "test1", timestamp: .init(date: Date.now)))
    }
}
