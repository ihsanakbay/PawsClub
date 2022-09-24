//
//  ForgotPasswordService.swift
//  PawsClub
//
//  Created by İhsan Akbay on 29.08.2022.
//

import Foundation
import Combine
import Firebase

protocol ForgotPasswordService {
	func sendPasswordReset(to email: String) -> AnyPublisher<Void, Error>
}

final class ForgotPasswordManager: ForgotPasswordService {
	func sendPasswordReset(to email: String) -> AnyPublisher<Void, Error> {
		Deferred {
			Future { promise in
				Auth.auth().sendPasswordReset(withEmail: email) { error in
					if let error = error {
						promise(.failure(error))
					} else {
						promise(.success(()))
					}
				}
			}
		}
		.eraseToAnyPublisher()
	}
}
