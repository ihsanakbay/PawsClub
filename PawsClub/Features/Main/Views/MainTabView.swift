//
//  MainTabView.swift
//  PawsClub
//
//  Created by İhsan Akbay on 21.08.2022.
//

import SwiftUI

enum Tab: String {
	case home, favorites, profile
}

struct MainTabView: View {
	@State private var selectedTab: Tab = .home

	var body: some View {
		TabView(selection: $selectedTab) {
			NavigationView {
				HomeView()
			}
			.tag(Tab.home)
			.tabItem {
				Label("Home", systemImage: "house")
			}

			NavigationView {
				FavoritesView()
			}
			.tag(Tab.favorites)
			.tabItem {
				Label("Favorite", systemImage: "heart")
			}

			NavigationView {
				ProfileView()
			}
			.tag(Tab.profile)
			.tabItem {
				Label("Profile", systemImage: "person")
			}
		}
		.accentColor(Color.theme.pinkColor)
	}
}

struct MainTabView_Previews: PreviewProvider {
	static var previews: some View {
		MainTabView()
			.environmentObject(AuthViewModel(service: AuthenticationService()))
	}
}
