//
//  TabRouter.swift
//  PawsClub
//
//  Created by İhsan Akbay on 21.08.2022.
//

import SwiftUI

final class TabRouter: ObservableObject {
	@Published var page: Page = .home
	
	func change(to page: Page) {
		self.page = page
	}
}
