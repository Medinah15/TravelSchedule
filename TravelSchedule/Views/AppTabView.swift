//
//  AppTabView.swift
//  TravelSchedule
//
//  Created by Medina Huseynova on 20.09.25.
//

import SwiftUI

struct AppTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                MainView()
            }
            .tabItem {
                if selectedTab == 0 {
                    Image("schedule_active")
                } else {
                    Image("schedule_inactive")
                }
                
            }
            .tag(0)
            
            NavigationStack {
                SettingsView()
            }
            .tabItem {
                if selectedTab == 1 {
                    Image("settings_active")
                } else {
                    Image("settings_inactive")
                }
                
            }
            .tag(1)
        }
    }
}
