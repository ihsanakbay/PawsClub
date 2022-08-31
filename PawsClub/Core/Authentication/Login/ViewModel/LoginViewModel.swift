//
//  LoginViewModel.swift
//  PawsClub
//
//  Created by İhsan Akbay on 21.08.2022.
//

import SwiftUI
import Combine

enum LoginState {
	case successful
	case failed(error: Error)
	case na
}

protocol LoginViewModelProtocol: ObservableObject {
	var service: LoginService { get }
	var state: LoginState { get }
	var credentials: LoginCredentials { get }
	var hasError: Bool { get }
	var isLoading: Bool { get }
	init(service: LoginService)
	func login()
}

final class LoginViewModel: LoginViewModelProtocol {
	
	@Published var state: LoginState = .na
	@Published var hasError: Bool = false
	@Published var isLoading: Bool = false
	@Published var credentials: LoginCredentials = .init(email: "", password: "")
	
	var service: LoginService
	
	private var subscriptions = Set<AnyCancellable>()
	
	init(service: LoginService) {
		self.service = service
		setupErrorSubscription()
	}
	
	func login() {
		isLoading = true
		service
			.login(with: credentials)
			.sink { result in
				switch result {
				case .failure(let error):
					self.state = .failed(error: error)
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

private extension LoginViewModel {
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
