//
//  ForgotPasswordViewModel.swift
//  PawsClub
//
//  Created by İhsan Akbay on 22.08.2022.
//

import SwiftUI
import Combine

protocol ForgotPasswordViewModelProtocol: ObservableObject {
	var service: ForgotPasswordService { get }
	var email: String { get }
	init(service: ForgotPasswordService)
	func sendPasswordReset()
}

final class ForgotPasswordViewModel: ForgotPasswordViewModelProtocol {
	
	var service: ForgotPasswordService
	private var subscriptions = Set<AnyCancellable>()
	
	@Published var email: String = ""
	
	init(service: ForgotPasswordService) {
		self.service = service
	}
	
	func sendPasswordReset() {
		service
			.sendPasswordReset(to: email)
			.sink { result in
				switch result {
				case .failure(let error):
					print("Failed: \(error)")
				default:
					break
				}
			} receiveValue: {
				print("Sent password reset request")
			}
			.store(in: &subscriptions)
	}
	
	
}
