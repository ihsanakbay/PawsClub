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
	@StateObject var session = SessionManager()
	
	var body: some Scene {
		WindowGroup {
			switch session.state {
			case .loggedIn:
				MainTabView()
					.environmentObject(session)
			case .loggedOut:
				LoginView()
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
