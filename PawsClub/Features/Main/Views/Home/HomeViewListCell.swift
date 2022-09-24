//
//  HomeViewListCell.swift
//  PawsClub
//
//  Created by İhsan Akbay on 21.08.2022.
//

import CoreLocation
import Kingfisher
import SwiftUI

struct HomeViewListCell: View {
	@ObservedObject var viewModel: PostCellViewModel
	@State private var postLocation: String?

	let screenSize = UIScreen.main.bounds

	var timestampString: String {
		let formatter = DateFormatter()
		formatter.dateStyle = .long
		formatter.timeStyle = .none
		return formatter.string(from: viewModel.post.timestamp!.dateValue())
	}

	var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 25)
				.fill(Color.theme.cellBackgroundColor)
				.opacity(0.9)
				.frame(height: 120)

			HStack {
				KFImage(URL(string: viewModel.post.imageUrl))
					.resizable()
					.scaledToFill()
					.aspectRatio(contentMode: .fill)
					.frame(width: screenSize.width / 3, height: 120)
					.clipped()
					.cornerRadius(25)

				Spacer()

				VStack(alignment: .leading, spacing: 8) {
					HStack(alignment: .center, spacing: 4) {
						Text(viewModel.post.name)
							.font(.system(size: 16, weight: .semibold))

						Spacer()

						Image(viewModel.post.gender.lowercased())
							.resizable()
							.scaledToFit()
							.foregroundColor(viewModel.post.gender.lowercased() == "female" ? Color.theme.femaleIconColor : Color.theme.maleIconColor)
							.frame(height: 18)
					}

					HStack(spacing: 8) {
						Text(viewModel.post.kind)
						HStack {
							Image(systemName: "circle.fill")
								.resizable()
								.frame(width: 8, height: 8)
								.padding(.leading)
								.foregroundColor(Color.theme.pinkColor)
							Text(viewModel.post.age)
						}
					}

					Text(viewModel.post.breed)
					Text(timestampString)
						.foregroundColor(Color.theme.textSecondary)
				}
				.font(.system(size: 14))
				.padding()
				.foregroundColor(Color.theme.text)
			}
			.frame(height: 120)
		}
		.padding(.horizontal)
		.padding(.vertical, 8)
	}
}

struct HomeViewListCell_Previews: PreviewProvider {
	static var previews: some View {
		HomeViewListCell(viewModel: PostCellViewModel(post: Post(name: "Maya", about: "Maya was found abandoned as a baby", kind: "Cat", breed: "Norweign Forest Cat", age: "Baby", gender: "Female", healthChecks: true, isVaccinated: true, isNeutered: true, latitude: 41.162033, longitude: 27.799824, imageUrl: "https://firebasestorage.googleapis.com:443/v0/b/pawsclub-8920b.appspot.com/o/post_images%2F0B29E245-1893-4C02-97AD-92F189EA1576?alt=media&token=5bd7cbad-d058-4a62-9cf9-9a2870efcb13", ownerUid: "X56NG8yGGzQRjPwbjd2C9ZNIQa73", ownerUsername: "test1", timestamp: .init(date: Date.now))))
	}
}