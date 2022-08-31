//
//  MainTabView.swift
//  PawsClub
//
//  Created by İhsan Akbay on 21.08.2022.
//

import SwiftUI

enum Page: String {
	case home, favorites, profile
}

struct MainTabView: View {
	@EnvironmentObject var sessionService: SessionManager
	@StateObject var router = TabRouter()
	@State private var isSettingPresented: Bool = false
	@State private var isFilterSheetOpen: Bool = false
	
	var body: some View {
		NavigationView {
			TabView(selection: $router.page) {
				HomeView()
					.tag(Page.home)
					.tabItem {
						Label("Home", systemImage: "house")
					}
				
				LazyView(FavoriteView())
					.tag(Page.favorites)
					.tabItem {
						Label("Favorite", systemImage: "heart")
					}
				
				LazyView(ProfileView())
					.tag(Page.profile)
					.tabItem {
						Label("Profile", systemImage: "person")
					}
					.environmentObject(sessionService)
			}
			.navigationBarTitleDisplayMode(.inline)
			.navigationTitle(router.page.rawValue.capitalized)
//			.toolbar {
//				ToolbarItem(placement: .navigationBarLeading) {
//					if selectedTab == .Home {
//						Button {
//							isFilterSheetOpen.toggle()
//						} label: {
//							Image(systemName: "slider.horizontal.3")
//						}
//
//					}
//				}
//				ToolbarItem(placement: .navigationBarTrailing) {
//					if selectedTab == .Home {
//						NavigationLink {
//							PostAddView()
//						} label: {
//							Image(systemName: "plus.app.fill")
//						}
//						.font(.system(size: 20))
//					}
//
//					if selectedTab == .Profile {
//						Button {
//							isSettingPresented.toggle()
//						} label: {
//							Image(systemName: "gear")
//						}
//					}
//				}
//			}
//			.sheet(isPresented: $isSettingPresented) {
//				SettingView()
//			}
//			.sheet(isPresented: $isFilterSheetOpen) {
//				FilterView(selectedKinds: [], selectedBreeds: [], selectedGender: [], selectedAge: [])
//			}
		}
		.accentColor(Color.theme.pinkColor)
	}
}

struct MainTabView_Previews: PreviewProvider {
	static var previews: some View {
		MainTabView()
	}
}
