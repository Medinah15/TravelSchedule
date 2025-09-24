//
//  AppTabView.swift
//  TravelSchedule
//
//  Created by Medina Huseynova on 20.09.25.
//

import SwiftUI

// MARK: - Tab Enum
private enum AppTab: Int {
    case schedule
    case settings
}

// MARK: - View
struct AppTabView: View {
    
    // MARK: - State
    @State private var selectedTab: AppTab = .schedule
    
    // MARK: - Body
    var body: some View {
        TabView(selection: $selectedTab) {
            
            NavigationStack {
                MainView()
            }
            .tabItem {
                Image(selectedTab == .schedule ? "schedule_active" : "schedule_inactive")
            }
            .tag(AppTab.schedule)
            
            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Image(selectedTab == .settings ? "settings_active" : "settings_inactive")
            }
            .tag(AppTab.settings)
        }
    }
}
