//
//  General.swift
//  PawsClub
//
//  Created by İhsan Akbay on 11.10.2022.
//

import Foundation

extension Sequence where Element: Hashable {
	func uniqued() -> [Element] {
		var set = Set<Element>()
		return filter { set.insert($0).inserted }
	}
}
