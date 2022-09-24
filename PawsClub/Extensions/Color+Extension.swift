//
//  Color+Extension.swift
//  PawsClub
//
//  Created by İhsan Akbay on 21.08.2022.
//

import SwiftUI

extension Color {
	static let theme = ColorTheme()
}

struct ColorTheme {
	let backgroundColor = Color(uiColor: .systemBackground)
	let blueColor = Color("blueColor")
	let cellBackgroundColor = Color("greenColor").opacity(0.2)
	let greenColor = Color("greenColor")
	let lightPinkColor = Color("lightPinkColor")
	let pinkColor = Color("pinkColor")
	let textFieldColor = Color("textFieldColor").opacity(0.3)
	let femaleIconColor = Color("femaleIcon")
	let maleIconColor = Color("maleIcon")
	let googleColor = Color("googleColor")
	let text = Color(uiColor: .label)
	let textSecondary = Color(uiColor: .secondaryLabel)
	let placeholder = Color(uiColor: .placeholderText)
}
