//
//  LazyView.swift
//  PawsClub
//
//  Created by İhsan Akbay on 21.08.2022.
//

import SwiftUI

struct LazyView<Content:View>: View {
	let build: () -> Content

	init(_ build: @autoclosure @escaping() -> Content) {
		self.build = build
	}

	var body: Content {
		build()
	}
}
