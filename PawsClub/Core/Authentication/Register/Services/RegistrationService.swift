//
//  RegistrationService.swift
//  PawsClub
//
//  Created by İhsan Akbay on 25.08.2022.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore

enum RegistrationKeys: String {
	case email
	case username
	case fullname
	case imageUrl
}

protocol RegistrationService {
	func register(with credentials: RegisterCredentials) -> AnyPublisher<Void, Error>
}

final class RegistrationManager: RegistrationService {

	func register(with credentials: RegisterCredentials) -> AnyPublisher<Void, Error> {
		Deferred {
			Future { promise in
				Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { result, error in
					if let error = error {
						promise(.failure(error))
					} else {
						if let uid = result?.user.uid {
							let values = [
								RegistrationKeys.email.rawValue: credentials.email,
								RegistrationKeys.username.rawValue: credentials.username,
								RegistrationKeys.fullname.rawValue: credentials.fullname
							] as [String: Any]
							
							Firestore.firestore().collection("users").document(uid).setData(values) { error in
								if let error = error {
									promise(.failure(error))
								} else {
									promise(.success(()))
								}
							}
						} else {
							promise(.failure(NSError(domain: "Invalid user id", code: 0, userInfo: nil)))
						}
					}
				}
			}
		}
			.receive(on: RunLoop.main)
			.eraseToAnyPublisher()
	}
}
