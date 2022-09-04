//
//  PickerData.swift
//  PawsClub
//
//  Created by İhsan Akbay on 3.09.2022.
//

import Foundation

enum PET_GENDER: String, CaseIterable, Identifiable {
	case male = "Male",
	female = "Female"

	var id: Self { self }
}

enum PET_AGE: String, CaseIterable, Identifiable {
	case baby = "Baby",
	young = "Young",
	adult = "Adult",
	old = "Old"

	var id: Self { self }
}

enum PET_KIND: String, CaseIterable, Identifiable {
	case Dog, Cat, Bird, Fish, Other
	var id: Self { self }
}

let BREED_URL = "https://bit.ly/3QJ7Lsu"
