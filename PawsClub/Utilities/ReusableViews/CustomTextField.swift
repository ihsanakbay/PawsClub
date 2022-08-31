//
//  CustomTextField.swift
//  PawsClub
//
//  Created by İhsan Akbay on 21.08.2022.
//

import SwiftUI

struct CustomTextField: View {
	@Binding var text: String
	@State var placeholder: String
	@State var systemImageName: String
	@State var isSecure: Bool = false

	var body: some View {
		ZStack(alignment: .leading) {
			RoundedRectangle(cornerRadius: 10)
				.frame(height: 40)
				.foregroundColor(Color.theme.textFieldColor)

			HStack(spacing: 8) {
				if systemImageName != "" {
					Image(systemName: systemImageName)
						.resizable()
						.scaledToFit()
						.frame(width: 20, height: 20)
						.foregroundColor(Color.theme.lightPinkColor)
				}

				if isSecure {
					SecureField(placeholder, text: $text)
				} else {
					TextField(placeholder, text: $text)
				}
			}
			.padding(8)
		}
	}
}

struct CustomTextField_Previews: PreviewProvider {
	static var previews: some View {
		CustomTextField(text: .constant(""), placeholder: "Your input", systemImageName: "envelope", isSecure: true)
	}
}
