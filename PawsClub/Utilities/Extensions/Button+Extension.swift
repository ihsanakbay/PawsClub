//
//  Button+Extension.swift
//  PawsClub
//
//  Created by İhsan Akbay on 22.08.2022.
//

import SwiftUI

struct CustomButton: ViewModifier {
	func body(content: Content) -> some View {
		content
			.frame(height: 44)
			.frame(maxWidth: .infinity)
			.background(Color.theme.pinkColor)
			.foregroundColor(.white)
			.clipShape(Capsule())
			.padding()
	}
}

struct AppleButton: ViewModifier {
	func body(content: Content) -> some View {
		content
			.frame(height: 44)
			.frame(maxWidth: .infinity)
			.background(Color.black)
			.foregroundColor(.white)
			.clipShape(Capsule())
			.padding(.horizontal)
	}
}

struct GoogleButton: ViewModifier {
	func body(content: Content) -> some View {
		content
			.frame(height: 44)
			.frame(maxWidth: .infinity)
			.background(Color.theme.googleColor)
			.foregroundColor(.white)
			.clipShape(Capsule())
			.padding(.horizontal)
	}
}

extension View {
	func customButton() -> some View {
		self.modifier(CustomButton())
	}
	
	func appleButton() -> some View {
		self.modifier(AppleButton())
	}
	
	func googleButton() -> some View {
		self.modifier(GoogleButton())
	}
}
