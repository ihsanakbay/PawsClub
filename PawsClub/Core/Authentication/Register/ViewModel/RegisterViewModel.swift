//
//  RegisterViewModel.swift
//  PawsClub
//
//  Created by İhsan Akbay on 22.08.2022.
//

import SwiftUI
import Combine

enum RegistrationState {
	case successful
	case failed(error: Error)
	case na
}

protocol RegisterViewModelProtocol: ObservableObject {
	var state: RegistrationState { get }
	var userCredentials: RegisterCredentials { get }
	var service: RegistrationService { get }
	var hasError: Bool { get }
	var isLoading: Bool { get }
	func register()
	init(service: RegistrationService)
}

final class RegisterViewModel: RegisterViewModelProtocol {
	@Published var isLoading: Bool = false
	@Published var userCredentials: RegisterCredentials = RegisterCredentials.new
	@Published var state: RegistrationState = .na
	@Published var hasError: Bool = false
	
	var service: RegistrationService
	
	private var subscriptions = Set<AnyCancellable>()
	
	init(service: RegistrationService) {
		self.service = service
		setupErrorSubscription()
	}
	
	func register() {
		isLoading = true
		service.register(with: userCredentials)
			.sink { [weak self] result in
				switch result {
				case .failure(let error):
					self?.state = .failed(error: error)
				default:
					break
				}
			} receiveValue: { [weak self] in
				self?.state = .successful
			}
			.store(in: &subscriptions)
		isLoading = false
	}
	
}

private extension RegisterViewModel {
	func setupErrorSubscription() {
		$state
			.map { state -> Bool in
				switch state {
				case .successful, .na:
					return false
				case .failed:
					return true
				}
			}
			.assign(to: &$hasError)
	}
}
