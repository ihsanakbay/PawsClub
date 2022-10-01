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
	var post: Post
	@State private var postLocation: String?

	let screenSize = UIScreen.main.bounds

	var timestampString: String {
		let formatter = DateFormatter()
		formatter.dateStyle = .long
		formatter.timeStyle = .none
		return formatter.string(from: post.timestamp.dateValue())
	}

	var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 25)
				.fill(Color.theme.cellBackgroundColor)
				.opacity(0.9)
				.frame(height: 120)

			HStack {
				KFImage(URL(string: post.imageUrl))
					.placeholder({ progress in
						ProgressView()
					})
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
		HomeViewListCell(post: .new)
	}
}
