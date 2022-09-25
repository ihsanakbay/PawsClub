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
	@State private var isSettingPresented: Bool = false
	@State private var isFilterSheetOpen: Bool = false
	@State private var isPostAddViewPresented: Bool = false

	var body: some View {
		NavigationView {
			TabView(selection: $selectedTab) {
				HomeView()
					.tag(Tab.home)
					.tabItem {
						Label("Home", systemImage: "house")
					}

				FavoritesView()
					.tag(Tab.favorites)
					.tabItem {
						Label("Favorite", systemImage: "heart")
					}

				ProfileView()
					.tag(Tab.profile)
					.tabItem {
						Label("Profile", systemImage: "person")
					}
			}
			.navigationBarTitleDisplayMode(.inline)
			.navigationTitle(selectedTab.rawValue.capitalized)
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					if selectedTab == .home {
						Button {
							isFilterSheetOpen.toggle()
						} label: {
							Image(systemName: "slider.horizontal.3")
						}
					}
				}
				ToolbarItem(placement: .navigationBarTrailing) {
					if selectedTab == .home {
						Button {
							isPostAddViewPresented.toggle()
						} label: {
							Image(systemName: "plus.app.fill")
						}
						.font(.system(size: 20))
					}

					if selectedTab == .profile {
						Button {
							isSettingPresented.toggle()
						} label: {
							Image(systemName: "gear")
						}
					}
				}
			}
			.sheet(isPresented: $isPostAddViewPresented, content: {
				NavigationView {
					PostAddView()
				}
			})
			.sheet(isPresented: $isSettingPresented) {
				SettingsView()
			}
			.sheet(isPresented: $isFilterSheetOpen) {
//				FilterView(selectedKinds: [], selectedBreeds: [], selectedGender: [], selectedAge: [])
			}
		}
		.accentColor(Color.theme.pinkColor)
	}
}

struct MainTabView_Previews: PreviewProvider {
	static var previews: some View {
		MainTabView()
			.environmentObject(AuthViewModel())
	}
}
