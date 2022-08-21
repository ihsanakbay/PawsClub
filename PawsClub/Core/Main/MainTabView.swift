//
//  MainTabView.swift
//  PawsClub
//
//  Created by İhsan Akbay on 21.08.2022.
//

import SwiftUI

enum Page {
	case home, favorite, profile
}

struct MainTabView: View {
	
	@StateObject var router = TabRouter()
	
    var body: some View {
		TabView(selection: $router.page) {
			HomeView()
				.tag(Page.home)
				.tabItem {
					Label("Home", systemImage: "house")
				}
			
			FavoriteView()
				.tag(Page.favorite)
				.tabItem {
					Label("Favorite", systemImage: "heart")
				}
			
			ProfileView()
				.tag(Page.profile)
				.tabItem {
					Label("Profile", systemImage: "person")
				}
		}
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
