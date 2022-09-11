//
//  ServiceState.swift
//  PawsClub
//
//  Created by İhsan Akbay on 11.09.2022.
//

import Foundation

enum ServiceState {
	case successful
	case failed(error: Error)
	case na
}
