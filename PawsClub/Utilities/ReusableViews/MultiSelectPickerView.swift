//
//  MultiSelectPickerView.swift
//  PawsClub
//
//  Created by İhsan Akbay on 8.10.2022.
//

import SwiftUI

struct MultiSelectPickerView: View {
	@State var sourceItems: [String]
	@State var selectedItems: [String]

	var body: some View {
		Form {
			List {
				ForEach(sourceItems, id: \.self) { item in
					Button {
						withAnimation {
							if self.selectedItems.contains(item) {
								self.selectedItems.removeAll(where: { $0 == item })
							} else {
								self.selectedItems.append(item)
							}
						}
					} label: {
						HStack {
							Text(item)
							Spacer()
							Image(systemName: "checkmark.circle.fill")
								.foregroundColor(Color.theme.pinkColor)
								.opacity(self.selectedItems.contains(item) ? 1.0 : 0.0)
						}
					}
					.foregroundColor(.primary)
				}
			}
		}
	}
}
