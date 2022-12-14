//
//  FirebaseError.swift
//  PawsClub
//
//  Created by İhsan Akbay on 10.09.2022.
//

import Foundation

enum FirebaseError: Error {
	case badSnapshot
	case notFound
	case noUid
	case noImage
	case badUrl
}
