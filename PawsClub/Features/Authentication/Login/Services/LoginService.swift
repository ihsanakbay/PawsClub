//
//  LoginService.swift
//  PawsClub
//
//  Created by İhsan Akbay on 29.08.2022.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore

protocol LoginService {
	func login(with credentials: LoginCredentials) -> AnyPublisher<Void, Error>
}

final class LoginManager: LoginService {
	func login(with credentials: LoginCredentials) -> AnyPublisher<Void, Error> {
		Deferred {
			Future { promise in
				Auth
					.auth()
					.signIn(withEmail: credentials.email, password: credentials.password) { result, error in
						if let error = error {
							promise(.failure(error))
						} else {
							promise(.success(()))
						}
					}
			}
		}
		.receive(on: RunLoop.main)
		.eraseToAnyPublisher()
	}
}
