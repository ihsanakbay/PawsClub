//
//  View+Extension.swift
//  PawsClub
//
//  Created by İhsan Akbay on 21.08.2022.
//

import SwiftUI

// MARK: Hide keyboard
extension View {
	func hideKeyboard() {
		let resign = #selector(UIResponder.resignFirstResponder)
		UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
	}
}

// MARK: iOS15 NavBar-TabBar Problem
func fixiOS15AppearanceIssues() {
	fixiOS15NavBarIssues()
	fixiOS15TabBarIssues()
}

private func fixiOS15NavBarIssues() {
	//	if #available(iOS 15, *) {
	let appearance = UINavigationBarAppearance()
	appearance.configureWithOpaqueBackground()
	appearance.backgroundColor = UIColor(Color.theme.backgroundColor) // customised nav bar background color
	appearance.shadowColor = .clear // removes the nav bar shadow
	appearance.titleTextAttributes = [.foregroundColor: UIColor(Color.theme.text)]
	UINavigationBar.appearance().standardAppearance = appearance
	UINavigationBar.appearance().scrollEdgeAppearance = appearance
	//	}
}

private func fixiOS15TabBarIssues() {
	//	if #available(iOS 15, *) {
	let appearance = UITabBarAppearance()
	appearance.configureWithOpaqueBackground()
	appearance.backgroundColor = UIColor(Color.theme.backgroundColor)
	appearance.shadowColor = .clear
	UITabBar.appearance().standardAppearance = appearance
	UITabBar.appearance().scrollEdgeAppearance = appearance
	//	}
}

extension Image {
	func profileImageModifier() -> some View {
		self
			.resizable()
			.frame(width: 36, height: 27.5)
			.foregroundColor(.white)
			.padding(36)
			.background(Color.theme.lightPinkColor)
			.clipShape(Circle())
			.frame(width: 80, height: 80)
			.shadow(radius: 3)
	}
}
