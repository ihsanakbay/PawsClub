//
//  PawsClubApp+Injection.swift
//  PawsClub
//
//  Created by İhsan Akbay on 24.09.2022.
//

import Foundation
import Resolver
import Firebase

extension Resolver: ResolverRegistering {
	public static func registerAllServices() {
		// register Firebase services
		register { Firestore.firestore().enableLogging(on: true) }.scope(.application)
		
		// register application components
		register { AuthenticationService() }.scope(.application)
		register { PostRepository() }.scope(.application)
	}
}


extension Firestore {
  func enableLogging(on: Bool = true) -> Firestore {
	Self.enableLogging(on)
	return self
  }
}


