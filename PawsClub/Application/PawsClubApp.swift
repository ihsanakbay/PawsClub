//
//  PawsClubApp.swift
//  PawsClub
//
//  Created by İhsan Akbay on 21.08.2022.
//

import SwiftUI
import FirebaseCore

@main
struct PawsClubApp: App {
	
	@UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
	@StateObject private var authViewModel = AuthViewModel()
	
	init() {
		fixiOS15AppearanceIssues()
	}
	
	var body: some Scene {
		WindowGroup {
			Group {
				if authViewModel.user != nil {
					MainTabView()
				} else {
					LoginView()
				}
			}
			.environmentObject(authViewModel)
			.onAppear {
				authViewModel.listenToAuthState()
			}
		}
	}
}

final class AppDelegate: NSObject, UIApplicationDelegate {
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
		FirebaseApp.configure()
		return true
	}
}
