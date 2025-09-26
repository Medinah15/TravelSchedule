//
//  AppTabView.swift
//  TravelSchedule
//
//  Created by Medina Huseynova on 20.09.25.
//

import SwiftUI

// MARK: - Tab Enum
private enum AppTab {
    case schedule
    case settings
}

// MARK: - View
struct AppTabView: View {
    @State private var selectedTab: AppTab = .schedule
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            NavigationStack {
                MainView()
            }
            .tabItem {
                Image("schedule")
                    .renderingMode(.template)
            }
            .tag(AppTab.schedule)
            
            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Image("settings")
                    .renderingMode(.template)
            }
            .tag(AppTab.settings)
        }
        .tint(Color("BlackUniversal"))
    }
}
